#! /bin/bash

# Use the letters or the number padd to play

turn="X"
fin=0

reset () {
a="a"
b="b"
c="c"
d="d"
e="e"
f="f"
g="g"
h="h"
i="i"
}

printBoard() {
clear
echo "It is $turn" 
echo "
*---*---*---*
| $g | $h | $i |
*---*---*---*
| $d | $e | $f |
*---*---*---*
| $a | $b | $c |
*---*---*---*
"
}

checkWinner () {
    # Vertical
    if [[ $g == "$turn" && $h == "$turn" && $i == "$turn" ]]; then
        fin=1
    fi

    if [[ $d == "$turn" && $e == "$turn" && $f == "$turn" ]]; then
        fin=1
    fi

    if [[ $a == "$turn" && $b == "$turn" && $c == "$turn" ]]; then
        fin=1
    fi

    # Horizontal
    if [[ $g == "$turn" && $d == "$turn" && $a == "$turn" ]]; then
        fin=1
    fi

    if [[ $h == "$turn" && $e == "$turn" && $b == "$turn" ]]; then
        fin=1
    fi

    if [[ $i == "$turn" && $f == "$turn" && $c == "$turn" ]]; then
        fin=1
    fi

    # Cross
    if [[ $g == "$turn" && $e == "$turn" && $c == "$turn" ]]; then
        fin=1
    fi

    if [[ $i == "$turn" && $e == "$turn" && $a == "$turn" ]]; then
        fin=1
    fi

    # final check
    if [[ $fin == 1 ]]; then
        printBoard
echo "#############
#           #
#   $turn Won   #
#           #
#############
"
    fi
}

reset


clear
printBoard
while true
do
    read -rsn1 input

    case $input in
        a | 1)
        if [[ $a == "X" || $a == "O" ]]; then
            continue
        else
            a="$turn"
        fi
        ;;

        b | 2)
        if [[ $b == "X" || $b == "O" ]]; then
            continue
        else
            b="$turn"
        fi
        ;;

        c | 3)
        if [[ $c == "X" || $c == "O" ]]; then
            continue
        else
            c="$turn"
        fi
        ;;

        d | 4)
        if [[ $d == "X" || $d == "O" ]]; then
            continue
        else
            d="$turn"
        fi
        ;;

        e | 5)
        if [[ $e == "X" || $e == "O" ]]; then
            continue
        else
            e="$turn"
        fi
        ;;

        f | 6)
        if [[ $f == "X" || $f == "O" ]]; then
            continue
        else
            f="$turn"
        fi
        ;;

        g | 7)
        if [[ $g == "X" || $g == "O" ]]; then
            continue
        else
            g="$turn"
        fi
        ;;

        h | 8)
        if [[ $h == "X" || $h == "O" ]]; then
            continue
        else
            h="$turn"
        fi
        ;;

        i | 9)
        if [[ $i == "X" || $i == "O" ]]; then
            continue
        else
            i="$turn"
        fi
        ;;
    esac

    checkWinner
    if [[ $fin == 1 ]]; then 
        read -rsn1 -p "Do you want to quit ('y')" input 
        if [[ $input == "y" ]]; then 
            exit 0
        else
            reset
            fin=0
            continue
        fi
    fi

    if [[ "$turn" == "X" ]]; then 
        turn="O"
    else
        turn="X"
    fi
    
    printBoard 
    

    
done
