#!/bin/bash

# Matrix-like green characters in terminal

# Get terminal dimensions
cols=$(tput cols)
lines=$(tput lines)

# Hide cursor
tput civis

# Trap CTRL+C to show cursor again
trap "tput cnorm; clear; exit" SIGINT

# Create an array to store "drop positions"
declare -a drops
for ((i = 0; i < cols; i++)); do
  drops[$i]=0
done

# Infinite loop
while true; do
  for ((i = 0; i < cols; i++)); do
    # Randomly pick a character
    char=$(echo "$RANDOM" | md5sum | fold -w1 | head -n1)
    
    # Move cursor to position
    tput cup ${drops[$i]} $i
    
    # Print character in green
    echo -ne "\033[1;32m$char"

    # Occasionally print a blank space for trailing effect
    if (( ${drops[$i]} > 0 )); then
      tput cup $((${drops[$i]} - 1)) $i
      echo -ne " "
    fi

    # Move the drop down
    drops[$i]=$(( ${drops[$i]} + 1 ))

    # Reset to top randomly
    if (( ${drops[$i]} > lines || RANDOM % 100 > 98 )); then
      drops[$i]=0
    fi
  done
  sleep 0.05
done

