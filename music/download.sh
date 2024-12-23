#! /bin/bash

SONG=$1
ARTIST=$2
ALBUM=$3
URL=$4
FILENAME="${SONG} - ${ARTIST}"
echo "----- Started Downloading: ${FILENAME} -----"
youtube-dlp \
    --extract-audio \
    --audio-format "mp3" \
    -o "${FILENAME}.%(ext)s" \
    ${URL}
DOWNEXITCODE=$?

if [[ "$DOWNEXITCODE" == "0" ]]; then
    echo "----- Finished Downloading: ${FILENAME} -----"
    echo "----- Started Tagging: ${FILENAME} -----"
    mid3v2 \
        --song="${SONG}" \
        --artist="${ARTIST}" \
        --album="${ALBUM}" \
        --track="$(ls ./*mp3 | wc -l)" \
        "${FILENAME}.mp3"
    TAGEXITCODE=$?    
    if [[ "$TAGEXITCODE" == "0" ]]; then
        echo "----- Finished Tagging: ${FILENAME} -----"
    else
        echo "----- Failed Tagging: ${FILENAME} -----"
        exit 1
    fi

else
    echo "----- Failed Downloading: ${FILENAME} -----"
    exit 1
fi

