#!/bin/bash
MP3DIR=$PWD
echo "How long in seconds before the sound stops? "
read FRAGMENT_SECONDS
for i in $(ls *.[mM][pP]3); do
    echo filename: $i
    mp3splt -fnx -d $MP3DIR/output -t 0.$FRAGMENT_SECONDS -O 0.1 $i
    done
echo "How many seconds of silence between fragments? "
read SILENCE_SECONDS
SILENCE_FILE=$(ls $MP3DIR/silenceFiles/*$SILENCE_SECONDS.[mM][pP]3)
echo $SILENCE_FILE
WRAP_PARAMS=" "
WRAP_EXTRA_PARAMS=" "
WRAP_FILE_COUNT=0
TOO_BIG_FILE_COUNT=0
for i in $(ls $MP3DIR/output/*.[mM][pP]3); do
	if (( $WRAP_FILE_COUNT%80 == 0 )); then  #WRAP_FILE_COUNT < 1 
		TOO_BIG_FILE_COUNT=$((TOO_BIG_FILE_COUNT + 1))
		mp3wrap -v silenceAdded${TOO_BIG_FILE_COUNT}.mp3 $i $SILENCE_FILE
	else
		mp3wrap -a silenceAdded${TOO_BIG_FILE_COUNT}_MP3WRAP.mp3 $i $SILENCE_FILE
	fi
	WRAP_FILE_COUNT=$((WRAP_FILE_COUNT + 1))
	echo "Current count: $WRAP_FILE_COUNT"
	done
#mp3wrap -v silenceAdded.mp3 $WRAP_PARAMS
#if (( WRAP_FILE_COUNT > 240 )); then
#    mp3wrap -a silenceAdded_MP3WRAP.mp3 $WRAP_EXTRA_PARAMS
#fi
rm -rf $MP3DIR/output

