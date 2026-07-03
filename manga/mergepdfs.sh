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
  echo "Error: Directory not found -> $SUBDIR"
  exit 1
fi
echo "SUBDIR: ${SUBDIR}"
echo "PREFIX: ${PREFIX}"
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
