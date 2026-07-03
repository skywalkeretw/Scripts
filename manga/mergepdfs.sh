#!/usr/bin/env bash

# Usage:
# ./mergepdfs.sh output.pdf subdir prefix

set -e
shopt -s nullglob

if [[ "$#" -ne 3 ]]; then
  echo "Usage: $0 output.pdf subdir prefix"
  exit 1
fi

OUTPUT="$1"
SUBDIR="$2"
PREFIX="$3"

# Normalize directory (remove trailing slash)
SUBDIR="${SUBDIR%/}"

if [[ ! -d "$SUBDIR" ]]; then
  echo "Error: Directory not found -> $SUBDIR" >&2
  exit 1
fi

# Validate path to prevent directory traversal attacks
SUBDIR_REAL=$(realpath "$SUBDIR" 2>/dev/null || echo "$SUBDIR")
CWD_REAL=$(realpath "." 2>/dev/null || pwd)

if [[ ! "$SUBDIR_REAL" =~ ^"$CWD_REAL" ]]; then
  echo "Error: Directory must be within current working directory" >&2
  exit 1
fi
echo "SUBDIR: ${SUBDIR}"
echo "PREFIX: ${PREFIX}"

# Check if output file already exists
if [[ -f "$OUTPUT" ]]; then
  echo "Warning: Output file '$OUTPUT' already exists." >&2
  echo -n "Overwrite? (y/N): " >&2
  read -r response
  if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo "Aborted." >&2
    exit 0
  fi
fi

# Collect matching PDFs safely
FILES=()

while IFS= read -r file; do  
  FILES+=("$file")
done < <(
  printf "%s\n" "$SUBDIR"/"$PREFIX"*.pdf | sort -V
)

if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No matching PDF files found for prefix: $PREFIX"
  exit 1
fi

echo "Merging ${#FILES[@]} files:"
printf "  %s\n" "${FILES[@]}"

# Merge using pdfunite if available
if command -v pdfunite >/dev/null 2>&1; then
  pdfunite "${FILES[@]}" "$OUTPUT"
elif command -v gs >/dev/null 2>&1; then
  gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite \
     -sOutputFile="$OUTPUT" "${FILES[@]}"
else
  echo "Error: Install pdfunite (poppler-utils) or ghostscript."
  exit 1
fi

echo "✅ Created: $OUTPUT"
