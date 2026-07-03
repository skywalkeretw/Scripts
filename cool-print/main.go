package main

import (
	"fmt"
	"os"
	"strings"
	"time"
	"unicode"
	"unicode/utf8"
)

func main() {
	if len(os.Args) < 2 {
		fmt.Fprintln(os.Stderr, "Usage: cool-print <string>")
		os.Exit(1)
	}
	input := os.Args[1]

	printStringUntil(input)
}

func printStringUntil(str string) {
	charArray := strings.Split(str, "")

	completedStr := ""

	for _, char := range charArray {
		letter, _ := utf8.DecodeRuneInString(char)
		letter = unicode.ToLower(letter)
		
		// Only animate letters a-z, print other characters directly
		if letter < 'a' || letter > 'z' {
			completedStr = fmt.Sprintf("%s%s", completedStr, char)
			continue
		}
		
		for l := 'a'; l <= letter; l++ {
			currentStr := fmt.Sprintf("%s%s", completedStr, string(l))
			fmt.Printf("%s\n", currentStr)

			time.Sleep(10 * time.Millisecond)
		}
		completedStr = fmt.Sprintf("%s%s", completedStr, string(letter))
	}
}
