#!/usr/bin/env bash

# Usage:
# ./mangadex_title_to_pdfs.sh https://mangadex.org/title/TITLE_ID/slug

set -e

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


while :; do
  RESPONSE=$(curl -s \
    "https://api.mangadex.org/chapter?manga=$TITLE_ID&translatedLanguage[]=en&limit=$LIMIT&offset=$OFFSET")

  COUNT=$(echo "$RESPONSE" | jq '.data | length')
  [[ "$COUNT" -eq 0 ]] && break

  echo "$RESPONSE" | jq -r '
    .data[] |
    "\(.attributes.volume // "0")",
    "\(.attributes.chapter // "0")",
    "\(.attributes.title // "0")",
    "\(.id)"
  ' | while read -r VOLUME \
           && read -r CHAPTER \
           && read -r TITLE \
           && read -r ID; do

    SAFE_TITLE=$(echo "$TITLE" | tr '/:' '_')

    PDF_NAME="${SAFE_MANGA_TITLE}_Vol${VOLUME}_Ch${CHAPTER}_${SAFE_TITLE}.pdf"

    if [[ -f "$PDF_NAME" ]]; then
      echo "⏭ Skipping existing PDF: $PDF_NAME"
      continue
    fi

    echo "⬇ Downloading Vol=$VOLUME Ch=$CHAPTER — $TITLE"

    # Fetch chapter image server info
    API_RESPONSE=$(curl -s "https://api.mangadex.org/at-home/server/$ID")

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

      curl -s -o "${OUTPUT_DIR}/${FILENAME}" "$IMAGE_URL"
      FILES+=("${OUTPUT_DIR}/${FILENAME}")
      ((PAGE++))
    done

    echo "🧩 Merging images into PDF..."
    img2pdf "${FILES[@]}" -o "${DIR}/${PDF_NAME}"

    rm -rf "$OUTPUT_DIR"
    echo "✅ Created: "${DIR}/${PDF_NAME}""
    echo
  done

  OFFSET=$((OFFSET + LIMIT))
done

echo "🎉 All done!"
