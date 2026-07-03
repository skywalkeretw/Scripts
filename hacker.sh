#! /bin/bash
TARGET="Pentagon"
ROUNDS=500
if [ ! -z "$1" ]; then
    TARGET=$1
fi


MSG () {
    TIME=1
    if [ ! -z "$2" ]; then
        TIME=${2}
    fi
    echo "-> ${1}..."
    sleep $TIME
}

MSG "Tageting ${TARGET}"
MSG "Preparing Rainbow Tables"
MSG "Initiating Brute Force Attack"
MSG "Implementing Code Breaker System"
MSG "Accessing TOR Network"
MSG "Initiate Ghost Protocol"
MSG "Activating Password Breaker Algorithm"
MSG "Connecting Bot Net Workers"
MSG "Decrypting Target System"
MSG "Granting Root Access"
MSG "Bypassing System Encryption"
MSG "Preforming DDoS Attack Against ${TARGET} Servers"
MSG "Operation Troya Activated: Trojan Deployed"

MSG "EXECUTE!" 4

for i in $(seq 1 "$ROUNDS"); do 
    if command -v md5sum &>/dev/null; then
        a=$(echo "$i" | md5sum | cut -d' ' -f1)
        b=$(echo "$((i + 1))" | md5sum | cut -d' ' -f1)
    else
        a=$(echo "$i" | md5)
        b=$(echo "$((i + 1))" | md5)
    fi
    echo "${a}${b}"
done
sleep 2
clear

echo
echo "|----------------------------------------------------|"
echo "  Access has been granted to the ${TARGET} System... "
echo "|----------------------------------------------------|"
echo
echo "|--------------------------------------------------|"
echo "           Activating Shell Access...             "            
echo "|--------------------------------------------------|"

sleep 5
bash