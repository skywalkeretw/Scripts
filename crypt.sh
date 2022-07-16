#! /bin/bash
MODE=$1
ACTION=$2

help() {
    echo "Crypto Script used for encrypting and decrypting files"
    echo "MODE: enc | rsa"
    echo "ACTION: generate | g, encrypt | e, decrypt | d"

    echo ""
    echo "examples:"
    echo "$0 enc generate FILE "
    echo "$0 enc encrypt FILE KEY IV"
    echo "$0 enc decrypt FILE KEY IV"

    echo "$0 enc generate FILE "
    echo "$0 enc encrypt FILE KEY"
    echo "$0 enc decrypt FILE KEY"
}

while getopts ":h" option; do
   case $option in
      h) # display Help
         help
         exit;;
   esac
done

case $MODE in
    enc)
        FILE=$3
        KEY=$4
        IV=$5
        case $ACTION in
            generate | g )
                openssl enc -nosalt -aes-256-cbc -P -k Secret > $FILE
                echo "Key and IV have been created in: $FILE"
            ;;
            
            encrypt | e )
                openssl enc -nosalt -aes-256-cbc -in $FILE -out ${FILE}.enc -K $KEY -iv $IV
                echo "$FILE has been encrypted as ${FILE}.enc"
            ;;

            decrypt | d )
                openssl enc -nosalt -aes-256-cbc -in $FILE -out ${FILE}.enc -K $KEY -iv $IV -d
                echo "$FILE has been decrypted as ${FILE}.dec"
            ;;

            *)
                echo "specify a action"
            ;;
        esac
    ;;

    rsa)
        KEY=$3
        FILE=$4 
        case $ACTION in
            generate | g )
                openssl genrsa -out $KEY 4096
                echo "Private Key has been created: $KEY"
                openssl rsa -in $KEY -outform PEM  -pubout -out public_${KEY}
                echo "Public Key has been created: public_${KEY}"
            ;;
            
            encrypt | e )
                openssl rsautl -encrypt -inkey $KEY -pubin -in $FILE -out ${FILE}.enc
                echo "$FILE has been encrypted as ${FILE}.enc"
            ;;

            decrypt | d )
                openssl rsautl -decrypt -inkey $KEY -in $FILE -out  ${FILE}.dec
                echo "$FILE has been decrypted as ${FILE}.dec"
            ;;

            *)
                echo "specify a action"
            ;;
        esac
    ;;
esac

