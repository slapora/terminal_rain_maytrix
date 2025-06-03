#!/bin/bash

# Enhanced Matrix-style falling code in terminal with twinkling green shades

# Get terminal size
cols=$(tput cols)
rows=$(tput lines)

# Hide the cursor
tput civis

# Restore cursor on exit
trap "tput cnorm; clear; exit" SIGINT

# Define green color shades
green_bright="\033[1;32m"   # Bright green
green_dim="\033[0;32m"      # Dim green
green_faint="\033[2;32m"    # Faint green
reset="\033[0m"

# Characters to use in the stream
chars=(ｱ ｲ ｳ ｴ ｵ ｶ ｷ ｸ ｹ ｺ ｻ ｼ ｽ ｾ ｿ ﾀ ﾁ ﾂ ﾃ ﾄ ﾅ ﾆ ﾇ ﾈ ﾉ ﾊ ﾋ ﾌ ﾍ ﾎ ﾏ ﾐ ﾑ ﾒ ﾓ ﾔ ﾕ ﾖ ﾗ ﾘ ﾙ ﾚ ﾛ ﾜ)

# Array to track stream positions
declare -a stream_pos

# Initialize stream positions randomly
for ((i = 0; i < cols; i++)); do
  stream_pos[$i]=$((RANDOM % rows))
done

# Infinite animation loop
while true; do
  for ((i = 0; i < cols; i++)); do
    # Decide the length of this stream (shorter for variation)
    stream_length=$((RANDOM % 10 + 6))
    
    for ((j = 0; j < stream_length; j++)); do
      row=$((stream_pos[i] - j))
      
      if (( row >= 0 && row < rows )); then
        tput cup $row $i
        
        char=${chars[$RANDOM % ${#chars[@]}]}
        
        # Twinkle brightness: bright at head, dimmer below
        if (( j == 0 )); then
          echo -ne "${green_bright}${char}${reset}"
        elif (( j < stream_length / 2 )); then
          echo -ne "${green_dim}${char}${reset}"
        else
          echo -ne "${green_faint}${char}${reset}"
        fi
      fi
    done
    
    # Clear the tail
    tail_clear_row=$((stream_pos[i] - stream_length))
    if (( tail_clear_row >= 0 && tail_clear_row < rows )); then
      tput cup $tail_clear_row $i
      echo -ne " "
    fi

    # Move stream down
    stream_pos[$i]=$(( (stream_pos[i] + 1) % (rows + stream_length) ))
  done

  # Slight delay
  sleep 0.05
done
