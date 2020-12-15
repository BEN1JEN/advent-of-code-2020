#!/bin/zsh
notify-send -u normal -t 60000 -a "Advent of Code" "Advent of Code starts in 5 minutes\!"&
terminator -e "cd ~/programs/adventofcode/2020; zsh"&
firefox "https://adventofcode.com/2020/"&
