#!/bin/zsh
DAY=$(echo $(date +%d)+1 | bc)

notify-send -u normal -t 300000 -a "Advent of Code" "AoC starting soon\!" "Advent of Code starts in 5 minutes from now"&
if [ ! -d day-${DAY} ]; then
	cp -r template ~/programs/adventofcode/2020/day-${DAY};
fi
terminator -e "cd ~/programs/adventofcode/2020/day-${DAY}; zsh"&
firefox "https://adventofcode.com/2020/"&
