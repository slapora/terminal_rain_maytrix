package main

import (
	"fmt"
	"math/rand"
	"os"
	"os/signal"
	"syscall"
	"time"

	"golang.org/x/term"
)

var (
	greenBright = "\033[1;32m"
	greenDim    = "\033[0;32m"
	greenFaint  = "\033[2;32m"
	reset       = "\033[0m"
	chars       = []rune("ｱｲｳｴｵｶｷｸｹｺｻｼｽｾｿﾀﾁﾂﾃﾄﾅﾆﾇﾈﾉﾊﾋﾌﾍﾎﾏﾐﾑﾒﾓﾔﾕﾖﾗﾘﾙﾚﾛﾜ")
)

func getTerminalSize() (int, int) {
	width, height, err := term.GetSize(int(os.Stdout.Fd()))
	if err != nil {
		width, height = 80, 24
	}
	return width, height
}

func hideCursor() {
	fmt.Print("\033[?25l")
}

func showCursor() {
	fmt.Print("\033[?25h")
}

func moveCursor(row, col int) {
	fmt.Printf("\033[%d;%dH", row+1, col+1)
}

func clearScreen() {
	fmt.Print("\033[2J")
}

func main() {
	rand.Seed(time.Now().UnixNano())
	width, height := getTerminalSize()
	streamPos := make([]int, width)

	for i := range streamPos {
		streamPos[i] = rand.Intn(height)
	}

	hideCursor()
	clearScreen()
	defer func() {
		showCursor()
		clearScreen()
	}()

	// Handle Ctrl+C gracefully
	sig := make(chan os.Signal, 1)
	signal.Notify(sig, syscall.SIGINT)
	go func() {
		<-sig
		showCursor()
		clearScreen()
		os.Exit(0)
	}()

	for {
		for i := 0; i < width; i++ {
			streamLen := rand.Intn(10) + 6
			for j := 0; j < streamLen; j++ {
				row := streamPos[i] - j
				if row >= 0 && row < height {
					moveCursor(row, i)
					char := string(chars[rand.Intn(len(chars))])
					switch {
					case j == 0:
						fmt.Print(greenBright, char, reset)
					case j < streamLen/2:
						fmt.Print(greenDim, char, reset)
					default:
						fmt.Print(greenFaint, char, reset)
					}
				}
			}

			// Clear tail
			tailClearRow := streamPos[i] - streamLen
			if tailClearRow >= 0 && tailClearRow < height {
				moveCursor(tailClearRow, i)
				fmt.Print(" ")
			}

			// Move stream down
			streamPos[i] = (streamPos[i] + 1) % (height + streamLen)
		}
		time.Sleep(110 * time.Millisecond)
	}
}
