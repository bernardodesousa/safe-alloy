#!/bin/bash

export $(grep -v '^#' .env | xargs)

timestamp=""
setTimestamp() {
    timestamp=`date +%Y-%m-%d_%H-%M-%S`
}

l=$(bc <<< "$DISK_USAGE_LIMIT*100")
printf -v int %.0f "$float"
limit=${l%.*}
usage=0

checkUsage() {
    usage=$(df -h /dev/sda3 | egrep -o '[0-9]+%')
    usage=$(echo $usage | grep -o -E '[0-9]+')
}

freeStorage() {
    checkUsage

    # remove oldest files until under limit
    while [ $usage -gt $limit ]
    do
        rm "$RECORD_DIRECTORY/$(ls -t $RECORD_DIRECTORY | tail -1)"
        checkUsage
    done
}

while :
do
    freeStorage
    setTimestamp

    ffmpeg -i $CAM1 -map 0 -acodec copy -vcodec copy -hide_banner -loglevel fatal -f tee "$RECORD_DIRECTORY/cam1_$timestamp.mp4|[f=nut]pipe:" | \
    ffplay pipe: -hide_banner -loglevel fatal -nostats -x $ROW1_WIDTH -noborder -left 0 -top 27 &
    CAM1_PID=$!

    ffmpeg -i $CAM4 -map 0 -acodec copy -vcodec copy -hide_banner -loglevel fatal -f tee "$RECORD_DIRECTORY/cam4_$timestamp.mp4|[f=nut]pipe:" | \
    ffplay pipe: -hide_banner -loglevel fatal -nostats -x $ROW1_WIDTH -noborder -left $ROW1_WIDTH -top 27 &
    CAM4_PID=$!

    ffmpeg -i $CAM2 -map 0 -acodec copy -vcodec copy -hide_banner -loglevel fatal -f tee "$RECORD_DIRECTORY/cam2_$timestamp.mp4|[f=nut]pipe:" | \
    ffplay pipe: -hide_banner -loglevel fatal -nostats -x 455 -noborder -left 0 -top $ROW2_HEIGHT &
    CAM2_PID=$!

    ffmpeg -i $CAM3 -map 0 -acodec copy -vcodec copy -hide_banner -loglevel fatal -f tee "$RECORD_DIRECTORY/cam3_$timestamp.mp4|[f=nut]pipe:" | \
    ffplay pipe: -hide_banner -loglevel fatal -nostats -x 455 -noborder -left 455 -top $ROW2_HEIGHT &
    CAM3_PID=$!

    ffmpeg -i $CAM5 -map 0 -acodec copy -vcodec copy -hide_banner -loglevel fatal -f tee "$RECORD_DIRECTORY/cam5_$timestamp.mp4|[f=nut]pipe:" | \
    ffplay pipe: -hide_banner -loglevel fatal -nostats -x 455 -noborder -left 910 -top $ROW2_HEIGHT &
    CAM5_PID=$!

    sleep ${INTERVAL_MINUTES}m
    
    kill -9 $CAM1_PID
    kill -9 $CAM2_PID
    kill -9 $CAM3_PID
    kill -9 $CAM4_PID
    kill -9 $CAM5_PID
done
