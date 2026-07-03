#!/usr/bin/env bash

# Usage:
# ./mangadex_title_to_pdfs.sh https://mangadex.org/title/TITLE_ID/slug

set -e

# Check required dependencies
for cmd in curl jq img2pdf; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: Required command '$cmd' not found. Please install it first." >&2
    exit 1
  fi
done

TITLE_URL="$1"

if [[ -z "$TITLE_URL" ]]; then
  echo "Usage: $0 <mangadex title url>"
  exit 1
fi

# Extract title UUID
TITLE_ID=$(echo "$TITLE_URL" | grep -oE '[0-9a-f\-]{36}')

if [[ -z "$TITLE_ID" ]]; then
  echo "Could not extract title ID"
  exit 1
fi

echo "Title ID: $TITLE_ID"
echo

# Fetch manga info
MANGA_JSON=$(curl -s "https://api.mangadex.org/manga/$TITLE_ID")

# Prefer English title, fallback to any available title
MANGA_TITLE=$(echo "$MANGA_JSON" | jq -r '
  .data.attributes.title.en //
  (.data.attributes.title | to_entries[0].value)
')

# Sanitize manga title for filesystem
SAFE_MANGA_TITLE=$(echo "$MANGA_TITLE" | tr '/:' '_')

echo "📘 Manga title: $MANGA_TITLE"
echo

LIMIT=100
OFFSET=0

echo "Fetching English chapters..."
echo

DIR="$SAFE_MANGA_TITLE"

if [[ ! -d "$DIR" ]]; then
  echo "Creating directory: $DIR"
  mkdir -p "$DIR"
fi

# Get total chapter count first (URL-encoded brackets)
TOTAL_CHAPTERS=$(curl -s \
  "https://api.mangadex.org/chapter?manga=$TITLE_ID&translatedLanguage%5B%5D=en&limit=1&offset=0" \
  | jq -r '.total')

echo "📊 Total English chapters available: $TOTAL_CHAPTERS"
echo

CHAPTERS_PROCESSED=0
CHAPTERS_SKIPPED_EXTERNAL=0

while :; do
  # Add proper ordering to get chapters in sequential order (volume, then chapter)
  # Use URL-encoded brackets: %5B = [ and %5D = ]
  RESPONSE=$(curl -s \
    "https://api.mangadex.org/chapter?manga=$TITLE_ID&translatedLanguage%5B%5D=en&limit=$LIMIT&offset=$OFFSET&order%5Bvolume%5D=asc&order%5Bchapter%5D=asc")

  COUNT=$(echo "$RESPONSE" | jq '.data | length')
  [[ "$COUNT" -eq 0 ]] && break

  # Rate limiting to avoid API throttling (increased to 1 second for safety)
  sleep 1

  echo "$RESPONSE" | jq -r '
    .data[] |
    "\(.attributes.volume // "0")",
    "\(.attributes.chapter // "0")",
    "\(.attributes.title // "0")",
    "\(.id)",
    "\(.attributes.pages)",
    "\(.attributes.externalUrl // "null")"
  ' | while read -r VOLUME \
           && read -r CHAPTER \
           && read -r TITLE \
           && read -r ID \
           && read -r PAGES \
           && read -r EXTERNAL_URL; do

    SAFE_TITLE=$(echo "$TITLE" | tr '/:' '_')

    PDF_NAME="${SAFE_MANGA_TITLE}_Vol${VOLUME}_Ch${CHAPTER}_${SAFE_TITLE}.pdf"

    # Skip chapters with external URLs (official publisher content)
    if [[ "$PAGES" == "0" ]] || [[ "$EXTERNAL_URL" != "null" ]]; then
      echo "⏭ Skipping Vol=$VOLUME Ch=$CHAPTER — $TITLE (External/Official content: $EXTERNAL_URL)"
      ((CHAPTERS_SKIPPED_EXTERNAL++))
      continue
    fi

    # Fixed: Check PDF in the correct directory
    if [[ -f "$DIR/$PDF_NAME" ]]; then
      echo "⏭ Skipping existing PDF: $PDF_NAME"
      ((CHAPTERS_PROCESSED++))
      continue
    fi

    URL="https://api.mangadex.org/at-home/server/$ID"

    echo "⬇ Downloading Vol=$VOLUME Ch=$CHAPTER — $TITLE"
    
    # Fetch chapter image server info with retry logic
    MAX_RETRIES=3
    RETRY_COUNT=0
    API_RESPONSE=""
    
    while [[ $RETRY_COUNT -lt $MAX_RETRIES ]]; do
      API_RESPONSE=$(curl -s -w "\n%{http_code}" "$URL")
      HTTP_CODE=$(echo "$API_RESPONSE" | tail -n1)
      API_RESPONSE=$(echo "$API_RESPONSE" | sed '$d')
      
      if [[ "$HTTP_CODE" == "200" ]]; then
        break
      elif [[ "$HTTP_CODE" == "429" ]]; then
        echo "⚠️  Rate limited, waiting 5 seconds..."
        sleep 5
        ((RETRY_COUNT++))
      else
        echo "❌ HTTP error $HTTP_CODE for chapter $ID"
        ((RETRY_COUNT++))
        sleep 2
      fi
    done

    if [[ $RETRY_COUNT -eq $MAX_RETRIES ]]; then
      echo "❌ Failed to fetch chapter info after $MAX_RETRIES attempts"
      continue
    fi

    # Rate limiting to avoid API throttling
    sleep 1

    BASE_URL=$(echo "$API_RESPONSE" | jq -r '.baseUrl')
    HASH=$(echo "$API_RESPONSE" | jq -r '.chapter.hash')
    IMAGES=$(echo "$API_RESPONSE" | jq -r '.chapter.data[]')

    if [[ "$BASE_URL" == "null" || "$HASH" == "null" ]]; then
      echo "❌ Failed to fetch chapter info for $ID"
      continue
    fi

    OUTPUT_DIR="${SAFE_MANGA_TITLE}_Vol${VOLUME}_Ch${CHAPTER}_${SAFE_TITLE}_${ID}"
    mkdir -p "$OUTPUT_DIR"

    PAGE=1
    FILES=()

    for IMAGE in $IMAGES; do
      FILENAME=$(printf "%03d_%s" "$PAGE" "$IMAGE")
      IMAGE_URL="$BASE_URL/data/$HASH/$IMAGE"

      # Add retry logic for image downloads
      RETRY_COUNT=0
      while [[ $RETRY_COUNT -lt 3 ]]; do
        if curl -s -f -o "${OUTPUT_DIR}/${FILENAME}" "$IMAGE_URL"; then
          break
        else
          echo "⚠️  Failed to download page $PAGE, retrying..."
          ((RETRY_COUNT++))
          sleep 1
        fi
      done

      FILES+=("${OUTPUT_DIR}/${FILENAME}")
      ((PAGE++))
    done

    echo "🧩 Merging images into PDF..."
    img2pdf "${FILES[@]}" -o "${DIR}/${PDF_NAME}"

    rm -rf "$OUTPUT_DIR"
    echo "✅ Created: ${DIR}/${PDF_NAME}"
    ((CHAPTERS_PROCESSED++))
    DOWNLOADABLE=$((TOTAL_CHAPTERS - CHAPTERS_SKIPPED_EXTERNAL))
    echo "📈 Progress: $CHAPTERS_PROCESSED/$DOWNLOADABLE downloadable chapters"
    echo
  done

  OFFSET=$((OFFSET + LIMIT))
done

echo
echo "🎉 All done!"
echo "📊 Final count: $CHAPTERS_PROCESSED chapters downloaded"
echo "📊 External/Official chapters skipped: $CHAPTERS_SKIPPED_EXTERNAL"
echo "📊 Total chapters listed: $TOTAL_CHAPTERS"

if [[ $CHAPTERS_SKIPPED_EXTERNAL -gt 0 ]]; then
  echo
  echo "ℹ️  Note: Some chapters are hosted externally (e.g., MangaPlus) and cannot be downloaded."
  echo "   These are official publisher chapters that redirect to external platforms."
fi

DOWNLOADABLE=$((TOTAL_CHAPTERS - CHAPTERS_SKIPPED_EXTERNAL))
if [[ $CHAPTERS_PROCESSED -lt $DOWNLOADABLE ]]; then
  echo "⚠️  Warning: Not all downloadable chapters were processed. Some may have failed."
fi