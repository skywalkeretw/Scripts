#! /bin/bash

END= false
PARAM=""
PLAYER_LIST=()
PLAYERS=0
MSG=""
MODE="all"

NEVERHAVEIEVER=(
    "got a tattoo"
    "stood someone up on a date"
    "had a speeding ticket"
    "ghosted someones text"
    "lied to get out of going to school/uni/work"
    "given a fake name"
    "dumped someone over text"
    "been sick on public transport"
    "lied to someone in this room"
    "texted an ex out of nowhere"
    "lied on a dating app"
    "kiss a friend's sibling"
    "been refused entry to a club"
    "had a holiday romance"
    "used someone else's toothbrush"
    "peed in the shower"
    "stalked an ex's new partner on social media"
    "been thrown out of a bar or club"
    "gone out with a friend's ex"
    "been mugged"
    "broken a bone"
    "lied about leaving the club early"
    "been sick on someone else"
    "kissed a celebrity"
    "eaten leftover food from another table at a restaurant"
    "gone on a blind date"
    "stolen anything"
    "been cheated on"
    "dined and dashed"
    "trespassed somewhere"
    "spent more than £200 on a night out"
    "paid for a gym class and not attended"
    "pulled an all nighter"
    "cheated on a test or exam"
    "pretended to be someone else"
    "ignored someone I knew in public"
    "ruined an item of clothing I borrowed from a friend"
    "hitchhiked a ride"
    "snuck into a festival or club"
    "lied in this game"
    "peed in public"
    "lied about kissing someone"
    "broken the law"
    "got drunkenly locked out of my house"
    "lied to my boss"
    "got a tattoo I regretted"
    )

MOSTLIKELY=(
    "kill someone accidentally?"
    "have never been to the movies?"
    "become a famous actor/actress?"
    "run away to join the circus?"
    "jump off a moving train?"
    "be paranoid?"
    "be the most athletic?"
    "watch romantic movies?"
    "become a stripper?"
    "get detained for harassing a police officer?"
    "be insecure?"
    "get hauled by a bear?"
    "be the most emotional?"
    "be a gambling addict?"
    "have been the first to kiss a guy/a girl?"
    "be the best at math?"
    "awkward on her first date?"
    "be successful as Bill Gates?"
    "considered to be the most powerful person in the world?"
    "meet a ghost?"
    "be drunk at work?"
    "be the richest?"
    "rob a bank?"
    "become a wrestler?"
    "live the longest?"
    "gone to a gay club?"
    "be a sadist?"
    "get in a fight?"
    "sleepwalk?"
    "get upset for the most stupid reasons?"
    "get away with murder?"
    "become a CEO at a company ranked amongst the top 100 largest in the world?"
    "be the most sarcastic?"
    "not take a shower for a week?"
    "love to spread rumors?"
    "always be happy?"
    "be the most creative?"
    "embarrass a friend in public?"
    "not have a computer?"
    "try a threesome?"
    "forget important birthdays?"
    "take care of the others when they are sick?"
    "fall in love with his/her best friend?"
    "never want to have a baby?"
    "get married first?"
    "marry a celebrity?"
    "read every book in a school library?"
    "invent something useful?"
    "find it easy winning an election?"
    "cause a world war?"
    "adopt a child?"
    "be the first one to die in a zombie apocalypse?"
    "date multiple people at the same time?"
    "do weird things in public?"
    "laugh at the wrong moment?"
    "die of something stupid?"
    "join the military?"
    "smoke?"
    "be unable to keep a secret for just 30 minutes?"
    "join a gang?"
    "do drugs?"
    "talk to animals?"
    "be admitted into a psychiatric hospital?"
    "punch a wall?"
    "call in sick at work just to go to a concert?"
    "become an alcoholic?"
    "end up in jail?"
    "drink the most?"
)

help () {
    echo "###########################################################"
    echo "#"
    echo "#             Welcome to Bash Drinking     "
    echo "#                     HELP ME!"
    echo "#"
    echo "#     Enter at least 2 Players to start"
    echo "#     After Games has started press Any button to continue"
    echo "#     press 'q' to quit"
    echo "#"
    echo "#     Modes:"
    echo "#     -n | --never     Never Have I Ever"
    echo "#     -d | --drink     The drinking game"
    echo "#     -r | --ring      Ring of Fire"
    echo "#     -m | --most      Most Likely"
    echo "#     IF yo dont specify a mode all modes are used"
    echo "#    "
    echo "###########################################################"
    exit 0
}

# Loop through arguments and process them
for arg in "$@"
do
    case $arg in
        -h|--help)
        help
        shift # Remove --initialize from processing
        ;;

        -n|--never)
        MODE="never"
        MSG="You are playing Never have I ever"
        shift # Remove --initialize from processing
        ;;

        -d|--drink)
        MODE="drink"
        MSG="You are playing the drinking game"
        shift # Remove --initialize from processing
        ;;

        -r| --ring)
        MODE="ring"
        MSG="You are playing Ring of Fire"
        shift
        ;;

        -m| --most)
        MODE="most"
        MSG="You are playing Who is most Likely"
        shift
        ;;

        -p|--param)
        PARAM="$2"
        shift # Remove argument name from processing
        shift # Remove argument value from processing
        ;;

        *)
        PLAYER_LIST+=("$1")
        PLAYERS=${#PLAYER_LIST[@]}
        shift # Remove generic argument from processing
        ;;
    esac
done

# returns a Random Player
getRandomPlayer () {
    local num="$(( $RANDOM % $PLAYERS ))"
    echo "${PLAYER_LIST[$num]}"
}


#Games
getRandomNeverHaveIEver () {
    local l=${#NEVERHAVEIEVER[@]}
    local num=$(( $RANDOM % $l))
    echo "Never have I ever ${NEVERHAVEIEVER[$num]}"
}

getRandomMostLikely () {
    local l=${#MOSTLIKELY[@]}
    local num=$(( $RANDOM % $l ))
    echo "Who is most likely to ${MOSTLIKELY[$num]}"
}

getAction () {
    local player=$(getRandomPlayer)
    local task="$(( $RANDOM % 5 ))"
    local do=""
    local sipnum="$(( $PLAYERS -1 ))"
    local randsip="$(( $RANDOM % $sipnum + 1 ))"
    case $task in
        0)
        do="take a sip of your drink"
        ;;

        1)
        do="distribute $sipnum sips between the others"
        ;;

        2)
        do="choose someone who has to take a sip"
        ;;
        3)
        do="distribute $randsip sips between the others"
        ;;
        4)
        do="choose someone who will distribute $randsip sips between everyone"
        ;;
    esac
    echo "${player} ${do}"
}


getRingOfFire () {
    local player=$(getRandomPlayer)
    local card=$(( $RANDOM % 13 + 1))
    case $card in
        1)
        do="Waterfall! start with $player list is -> ${PLAYER_LIST[*]}"
        ;;

        2)
        do="2 for you, $player choose someone who has to take a sip"
        ;;

        3)
        do="3 for me, $player take a sips"
        ;;

        4)
        do="All girls must drink"
        ;;

        5)
        do="$player is the Thumb Master - When you put your thumb on the table everyone must follow and whomever is last must drink."
        ;;

        6)
        do="All boys must drink"
        ;;

        7)
        do="Seven to Heaven - Last one to raise their hand has to drink"
        ;;

        8)
        do="$player choose a Drinking Buddy - everytime you drink they have to drink too"
        ;;

        9)
        do="Rhyme! Start with $player list is -> ${PLAYER_LIST[*]}"
        ;;

        10)
        do="$player choose a Topic list ist -> ${PLAYER_LIST[*]}"
        ;;

        11)
        do="$player make up a rule"
        ;;

        12)
        do="$player you are now the Question Master everyone who answers your questions must drink"
        ;;

        13)
        do="Everyone Drinks"
        ;;

    esac

    echo "$do"
}

# Greeting
echo "#################################################"
echo "#                                     "
echo "#                HELLO!               "
echo "#                               "
echo "#        Welcome to Bash Drinking     "
echo "#    $MSG                         "
echo "#################################################"
echo

if [ $PLAYERS -lt 2 ]; then
    echo "find some more players"
    exit 0
fi
read -rsn1

# Game Loop
while true
do
    case $MODE in
        all)
        GAME="$(( $RANDOM % 3 ))"
        case $GAME in
            0)
            getRandomNeverHaveIEver
            ;;

            1)
            getAction
            ;;
            
            2)
            getRingOfFire
            ;;

            3)
            getRandomMostLikely
            ;;
        esac
        ;;

        never)
        getRandomNeverHaveIEver
        ;;

        drink)
        getAction
        ;;

        ring)
        getRingOfFire
        ;;

        most)
        getRandomMostLikely
        ;;
    esac
    
    

    # Expect only one letter dont wait for submitting and dont writte back letter
    sleep 0.5
    read -rsn1 INPUT
    if [ "$INPUT" = "q" ]; then
        exit 0
    fi

done