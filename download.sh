#!/bin/zsh
DAY=$(echo $(date +%d)+1 | bc)

if [ ! -d day-${DAY} ]; then
	cp -r template ~/programs/adventofcode/2020/day-${DAY};
	pushd ~/programs/adventofcode/2020/day-${DAY}
	curl "https://adventofcode.com/2020/day/${DAY}/input" | data.txt
	popd
fi
