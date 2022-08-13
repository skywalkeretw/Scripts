#! /bin/bash

SONG=$1
ARTIST=$2
ALBUM=$3
URL=$4
FILENAME="${SONG} - ${ARTIST}"
echo "----- Started Downloading: ${FILENAME} -----"
youtube-dl \
    --extract-audio \
    --audio-format "mp3" \
    -o "${FILENAME}.%(ext)s" \
    ${URL}
EXITCODE=$?
echo "----- Finished Downloading: ${FILENAME} -----"

if [[ $EXITCODE == "0" ]]; then
    echo "----- Started Tagging: ${FILENAME} -----"
    mid3v2 \
        --song="${SONG}" \
        --artist="${ARTIST}" \
        --album="${ALBUM}" \
        --track="$(ls ./*mp3 | wc -l)" \
        "${FILENAME}.mp3"
    echo "----- Finished Tagging: ${FILENAME} -----"
else
    exit 1
fi

