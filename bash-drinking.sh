#! /bin/bash

END= false
PARAM=""
PLAYER_LIST=()
PLAYERS=0
MODE_TEXT_EN=""
MODE_TEXT_DE=""
MODE="all"
LANG="en"

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

NEVERHAVEIEVER_DE=(
    "bekam ein Tattoo"
    "jemanden bei einem Date versetzt"
    "Hatte einen Strafzettel für zu schnelles Fahren"
    "Jemandem eine SMS gegeistert"
    "gelogen, um nicht zur Schule/Uni/Arbeit gehen zu müssen"
    "einen falschen Namen angegeben"
    "Jemanden per SMS abserviert"
    "in öffentlichen Verkehrsmitteln krank gewesen"
    "Jemanden in diesem Raum angelogen"
    "einem Ex aus dem Nichts eine SMS geschickt"
    "Bei einer Dating-App gelogen"
    "Das Geschwisterchen eines Freundes geküsst"
    "Wurde der Zutritt zu einem Club verweigert"
    "eine Urlaubs-Romanze gehabt"
    "die Zahnbürste einer anderen Person benutzt"
    "in die Dusche gepinkelt"
    "den neuen Partner eines Ex in den sozialen Medien gestalkt"
    "aus einer Bar oder einem Club rausgeschmissen worden"
    "mit der Ex eines Freundes ausgegangen"
    "überfallen worden"
    "einen Knochen gebrochen"
    "gelogen, um den Club früher zu verlassen"
    "jemandem übel mitgespielt"
    "einen Prominenten geküsst"
    "in einem Restaurant Essensreste von einem anderen Tisch gegessen"
    "auf ein Blind Date gegangen"
    "etwas gestohlen"
    "betrogen worden"
    "gegessen und gestrichen"
    "Irgendwo unerlaubt eingedrungen"
    "mehr als 200 Pfund für einen Abend ausgegeben"
    "für einen Sportkurs bezahlt und nicht teilgenommen"
    "die ganze Nacht durchgefeiert"
    "bei einem Test oder einer Prüfung geschummelt"
    "vorgetäuscht, jemand anderes zu sein"
    "jemanden, den ich kenne, in der Öffentlichkeit ignoriert"
    "ein Kleidungsstück ruiniert, das ich mir von einem Freund geliehen habe"
    "eine Fahrt per Anhalter gemacht"
    "mich auf ein Festival oder in einen Club geschlichen"
    "im Spiel gelogen"
    "in der Öffentlichkeit gepinkelt"
    "gelogen, jemanden zu küssen"
    "das Gesetz gebrochen"
    "betrunken aus meinem Haus ausgesperrt worden"
    "Meinen Chef angelogen"
    "Habe mir ein Tattoo stechen lassen, das ich bereue"
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

MOSTLIKELY_DE=(
    "jemanden versehentlich töten?"
    "noch nie im Kino gewesen sein?"
    "ein berühmter Schauspieler/eine berühmte Schauspielerin werden?"
    "weglaufen, um beim Zirkus mitzumachen?"
    "von einem fahrenden Zug springen?"
    "paranoid sein?"
    "der sportlichste sein?"
    "Romantische Filme sehen?"
    "Eine Stripperin werden?"
    "wegen Belästigung eines Polizeibeamten festgenommen werden?"
    "Unsicher sein?"
    "von einem Bären gerissen werden?"
    "am emotionalsten sein?"
    "spielsüchtig sein?"
    "der Erste gewesen sein, der einen Typen/ein Mädchen geküsst hat?"
    "am besten in Mathe sein?"
    "bei ihrem ersten Date unbeholfen sein?"
    "erfolgreicher sein als Bill Gates?"
    "als die mächtigste Person der Welt gelten?"
    "einen Geist treffen?"
    "bei der Arbeit betrunken sein?"
    "der Reichste sein?"
    "Eine Bank ausrauben?"
    "ein Wrestler werden?"
    "am längsten leben?"
    "in einen Schwulenclub gehen?"
    "ein Sadist sein?"
    "in eine Schlägerei geraten?"
    "Schlafwandeln?"
    "sich aus den dümmsten Gründen aufregen?"
    "mit Mord davonkommen?"
    "CEO einer Firma werden, die zu den 100 größten der Welt gehört?"
    "der sarkastischste Mensch sein?"
    "eine Woche lang nicht duschen?"
    "es lieben, Gerüchte zu verbreiten?"
    "immer fröhlich sein?"
    "am kreativsten sein?"
    "einen Freund in der Öffentlichkeit blamieren?"
    "keinen Computer haben?"
    "einen Dreier versuchen?"
    "wichtige Geburtstage vergessen?"
    "sich um die anderen kümmern, wenn sie krank sind?"
    "sich in den/die beste/n Freund/in verlieben?"
    "niemals ein Baby haben wollen?"
    "zuerst heiraten?"
    "einen Prominenten heiraten?"
    "jedes Buch in einer Schulbibliothek lesen?"
    "etwas Nützliches erfinden?"
    "es einfach finden, eine Wahl zu gewinnen?"
    "einen Weltkrieg auslösen?"
    "ein Kind adoptieren?"
    "der erste sein, der in einer Zombie-Apokalypse stirbt?"
    "mehrere Leute gleichzeitig daten?"
    "Seltsame Dinge in der Öffentlichkeit tun?"
    "im falschen Moment lachen?"
    "An etwas Dummen sterben?"
    "Dem Militär beitreten?"
    "Rauchen?"
    "nicht in der Lage sein, ein Geheimnis für nur 30 Minuten zu bewahren?"
    "einer Gang beitreten?"
    "Drogen nehmen?"
    "mit Tieren reden?"
    "in eine psychiatrische Klinik eingewiesen werden?"
    "gegen eine Wand schlagen?"
    "Sich auf der Arbeit krank melden, nur um auf ein Konzert zu gehen?"
    "Ein Alkoholiker werden?"
    "Im Knast landen?"
    "Am meisten trinken?"
)

help () {
    case $LANG in 
    de)
        echo "####################################################################################"
        echo "#"
        echo "#             Wilkommen beim Bash Drinking     "
        echo "#                     Hier ist die Hilfe"
        echo "#"
        echo "#     Gib mindestens 2 spieler an um spielen zu können"
        echo "#     nachdem das spiel begonnen hat drücken irgendeine Taste um fortzufahren"
        echo "#     drücke 'q' um das spiel zu beenden"
        echo "#"
        echo "#     Spiel arten:"
        echo "#     -n | --never     ich hab noch nie"
        echo "#     -d | --drink     Das Trinkspiel"
        echo "#     -r | --ring      Ring of Fire"
        echo "#     -m | --most      Am wahrscheinlichsten"
        echo "#     "
        echo "#     Wenn du kein Spiel modus angibst werden alle verwendet"
        echo "#    "        
        echo "#     -h| --help      Hilfe"
        echo "#     -l| --lang      ändere Sprache zu Deutsch"
        echo "####################################################################################"
    ;;

    *)
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
        echo "#     -h| --help      Help"
        echo "#     -l| --lang      change Language to German"
        echo "###########################################################"
    ;;
    esac


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
        MODE_TEXT_EN="You are playing Never have I ever"
        MODE_TEXT_DE="Du spielst jetzt ich hab noch nie"
        shift # Remove --initialize from processing
        ;;

        -d|--drink)
        MODE="drink"
        MODE_TEXT_EN="You are playing the drinking game"
        MODE_TEXT_DE="Du spielst nun das Trinkspiel"
        shift # Remove --initialize from processing
        ;;

        -r| --ring)
        MODE="ring"
        MODE_TEXT_EN="You are playing Ring of Fire"
        MODE_TEXT_DE="Du spielst nun Ring of Fire"

        shift
        ;;

        -m| --most)
        MODE="most"
        MODE_TEXT_EN="You are playing Who is most Likely"
        MODE_TEXT_DE="Du Spielst nun Am wahrscheinlischsten"
        shift
        ;;

        -l|--lang)
        LANG="de"
        shift
        
        #shift # Remove argument name from processing
        #shift # Remove argument value from processing
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

    case $LANG in 
    de)
        local l=${#NEVERHAVEIEVER_DE[@]}
        local num=$(( $RANDOM % $l))
        echo "Ich habe noch nie ${NEVERHAVEIEVER_DE[$num]}"
    ;;

    *)
        local l=${#NEVERHAVEIEVER[@]}
        local num=$(( $RANDOM % $l))
        echo "Never have I ever ${NEVERHAVEIEVER[$num]}"
    ;;
    esac

    
}

getRandomMostLikely () {
    case $LANG in 
    de)
        local l=${#MOSTLIKELY_DE[@]}
        local num=$(( $RANDOM % $l ))
        echo "Wer würde am wahrscheinlichsten ${MOSTLIKELY_DE[$num]}"
    ;;

    *)
        local l=${#MOSTLIKELY[@]}
        local num=$(( $RANDOM % $l ))
        echo "Who is most likely to ${MOSTLIKELY[$num]}"
    ;;
    esac
    
}

getAction () {
    local player=$(getRandomPlayer)
    local do=""
    local sipnum="$(( $PLAYERS - 1 ))"
    local randsip="$(( $RANDOM % $sipnum + 1 ))"
    local task="$(( $RANDOM % 6 ))"
    case $LANG in 
    de)
        case $task in
        0)
        do="nim ein schluck!!"
        ;;

        1)
        do="verteile $sipnum schlücke an die anderen!"
        ;;

        2)
        do="Wähle jemand der einen schluck trinken muss!"
        ;;

        3)
        do="verteile $randsip schlücke an die anderen!"
        ;;

        4)
        do="wähle jemand der nun $randsip schlücke verteilen darf"
        ;;
        
        5)
        do="trinke mit den anderen ein schluck!"
        ;;
    esac
    ;;

    *)
            case $task in
        0)
        do="take a sip of your drink!"
        ;;

        1)
        do="choose $sipnum sips to be shared with some or all of the others!"
        ;;

        2)
        do="choose someone who has to take a sip!"
        ;;

        3)
        do="choose $randsip sips to be shared with some or all of the others!"
        ;;

        4)
        do="pick someone who will choose $randsip sips for everyone else!"
        ;;
        
        5)
        do="have a sip with everyone else!"
        ;;
    esac
    ;;
    esac

    echo "${player} ${do}"
}


getRingOfFire () {
    local player=$(getRandomPlayer)
    local card=$(( $RANDOM % 13 + 1))
        case $LANG in 
    de)
    case $card in
        1)
        do="Wasserfall! Starte mit $player und gehe die liste durch -> ${PLAYER_LIST[*]}"
        ;;

        2)
        do="2 for you, $player wähle jemand der trinken muss"
        ;;

        3)
        do="3 for me, $player muss trinken"
        ;;

        4)
        do="Alle Mädels mussen trinken"
        ;;

        5)
        do="$player is the Thumb Master - Wenn $player seinen Daumen auf dem tisch legt müssen alle ihn nachmachen der letzte muss trinken"
        ;;

        6)
        do="Alle Jungs müssen trinken"
        ;;

        7)
        do="Seven to Heaven - Der letzte der seine hände in die luft streckt muss trinken"
        ;;

        8)
        do="$player Wähle einen trinkbuddy - Jedesmal wenn $player trinkt muss sein Trinkbuddy mit trinken"
        ;;

        9)
        do="Rhyme! fang mit $player an list is -> ${PLAYER_LIST[*]} - der der kein Rhyme darauf hat mus trinken"
        ;;

        10)
        do="$player wähle ein Thema liste ist -> ${PLAYER_LIST[*]}"
        ;;

        11)
        do="$player Erfinde eine regel"
        ;;

        12)
        do="$player ist nun Question master"
        ;;

        13)
        do="Jeder trinkt!"
        ;;

    esac
    ;;

    *)
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
    ;;
    esac


    echo "$do"
}



# Greeting
case $LANG in 
    de)
        echo "#################################################"
        echo "#                                     "
        echo "#                Hallo!               "
        echo "#                               "
        echo "#        Wilkommen zu Bash Drinking     "
        echo "#    $MODE_TEXT_DE                         "
        echo "#################################################"
        echo
    ;;

    *)
        echo "#################################################"
        echo "#                                     "
        echo "#                HELLO!               "
        echo "#                               "
        echo "#        Welcome to Bash Drinking     "
        echo "#    $MODE_TEXT_EN                         "
        echo "#################################################"
        echo
    ;;
esac

if [ $PLAYERS -lt 2 ]; then
    case $LANG in 
    de)
        echo "Such dir mehr Spieler"
    ;;

    *)
        echo "find some more players"
    ;;
    esac
    exit 0
fi

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