#!/bin/bash

gameDir=$1

readSize()
{
	if test -f "$gameDir/logo.png"
	then
		:
	else
		printf "Error: logo.png is missing\n"
		exit
	fi
	if test -f "$gameDir/ss.png"
	then
		:
	else
		printf "Error: ss.png is missing\n"
		exit
	fi
	logoSize=$(identify -quiet "$gameDir/logo.png")
	ssSize=$(identify -quiet "$gameDir/ss.png")
	logoSize1=${logoSize#"$gameDir/logo.png PNG "}
	ssSize1=${ssSize#"$gameDir/ss.png PNG "}
	logoSize2=$(echo "$logoSize1" | cut -d " " -f1)
	ssSize2=$(echo "$ssSize1" | cut -d " " -f1)
	logoX=$(echo "$logoSize2" | cut -d "x" -f1)
	logoY=$(echo "$logoSize2" | cut -d "x" -f2)
	ssX=$(echo "$ssSize2" | cut -d "x" -f1)
	ssY=$(echo "$ssSize2" | cut -d "x" -f2)
	printf "logo.png = %s x %s\n" "$logoX" "$logoY"
	printf "ss.png = %s x %s\n" "$ssX" "$ssY"
	if [ "$logoY" -gt "$ssY" ]; then
		printf "The logo is bigger than the screenshot. Fixing...\n"
		reSize
	else
		printf "The logo is smaller than the screenshot.\n"
	fi
}

reSize()
{
	hdiff=$(( "$logoY" - "$ssY" ))
	hdresvalue=$(( hdiff + ssY + 1))
	printf "The height difference is %s pixels, setting height of ss.png to %s...\n"\
	"$hdiff" "$hdresvalue"
	convert -quiet "$gameDir/ss.png" -resize x$hdresvalue "$gameDir/ss.png"
	echo Done
}

# Args check
if [[ $1 == "" ]]; then
	echo "Usage: $0 [game directory]"
	exit
else
	readSize
fi