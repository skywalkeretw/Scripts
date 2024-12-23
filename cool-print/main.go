package main

import (
	"fmt"
	"os"
	"strings"
	"time"
	"unicode"
)

func main() {
	input := os.Args[1]

	printStringUntil(input)
}

func printStringUntil(str string) {
	charArray := strings.Split(str, "")

	completedStr := ""

	for _, char := range charArray {
		letter := unicode.ToLower(rune(char[0]))
		for l := 'a'; l <= letter; l++ {
			currentStr := fmt.Sprintf("%s%s", completedStr, string(l))
			fmt.Printf("%s\n", currentStr)

			time.Sleep(10 * time.Millisecond)
		}
		completedStr = fmt.Sprintf("%s%s", completedStr, string(letter))
	}
}
