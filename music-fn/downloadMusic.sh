#! /bin/bash

if [[ -z $1 ]]; then echo "Mode Missing"; exit 1; else MODE=$1; fi 

case $MODE in

  download|d)
        if [[ -z $2 ]]; then echo "Song Missing"; exit 1; else SONG=$2; fi 
        if [[ -z $3 ]]; then echo "Artist Missing"; exit 1; else ARTIST=$3; fi 
        if [[ -z $4 ]]; then echo "Album Missing"; exit 1; else ALBUM=$4; fi 
        if [[ -z $5 ]]; then echo "URL Missing"; exit 1; else URL=$5; fi 
        if [[ -z $GITMUSICACTIONAUTH ]]; then echo "GITMUSICACTIONAUTH Missing"; exit 1; fi 
        if [[ -z $GITMUSICACTIONURL ]]; then echo "GITMUSICACTIONURL Missing"; exit 1; fi 

        curl -X POST -H "'X-Require-Whisk-Auth: ${GITMUSICACTIONAUTH}'" -H "'Content-Type: application/json'" -d "\"{ 'merge': true, 'music': [{'song': '${SONG}', 'artist': '${ARTIST}', 'album': '${ALBUM}', 'url': '${URL}'}]}\"" "${GITMUSICACTIONURL}"
        ;;

  setup|s)

        if [[ -z $2 ]]; then echo "Missing Action Url"; exit 1; else GITMUSICACTIONURL=$2; fi 
        if [[ -z $3 ]]; then echo "Missing Action Key"; exit 1; else GITMUSICACTIONAUTH=$3; fi 
        

        if [[ "$SHELL" == "/bin/bash" ]]; then
            SHELLFILE="$HOME/.bashrc"

        elif [[ "$SHELL" == "/bin/zsh" ]]; then
            SHELLFILE="$HOME/.zshrc"
       
        else 
            echo "Missing shell option please add"
            exit 2
        fi
        echo "export GITMUSICACTIONURL='${GITMUSICACTIONURL}'" >> ${SHELLFILE}
        echo "export GITMUSICACTIONAUTH='${GITMUSICACTIONAUTH}'" >> ${SHELLFILE}
        echo "Setup Complete GITMUSICACTIONURL and GITMUSICACTIONAUTH added to ${SHELLFILE}"
        exit 0
    ;;

  *)
    STATEMENTS
    ;;
esac