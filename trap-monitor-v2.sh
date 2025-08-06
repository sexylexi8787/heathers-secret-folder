#!/bin/bash

ICLOUD_LOG_DIR="$HOME/Library/Mobile Documents/com~apple~CloudDocs/Shortcuts/Logs"
LOCAL_LOG_DIR="/mnt/f/trap_logs_v2"
CAPTURE_DIR="/var/mobile/trap_captures_v2"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")

mkdir -p "$ICLOUD_LOG_DIR"
mkdir -p "$LOCAL_LOG_DIR"
mkdir -p "$CAPTURE_DIR"

PHOTO="$CAPTURE_DIR/photo_$TIMESTAMP.jpg"
/usr/bin/idevicescreenshot "$PHOTO" 2>/dev/null || echo "Photo capture failed"

AUDIO="$CAPTURE_DIR/audio_$TIMESTAMP.m4a"
/usr/bin/rec -q "$AUDIO" trim 0 00:00:10 || echo "Audio capture failed"

ACTUAL_GPS=$(curl -s https://ipapi.co/json | grep '"latitude\|longitude' | tr -d ',')
CLAIMED_GPS_FILE="/var/mobile/Library/Caches/locationd/lastknown.plist"

if [ -f "$CLAIMED_GPS_FILE" ]; then
    /usr/libexec/PlistBuddy -c "Print" "$CLAIMED_GPS_FILE" > "$CAPTURE_DIR/gps_claimed_$TIMESTAMP.txt"
    echo "$ACTUAL_GPS" > "$CAPTURE_DIR/gps_actual_$TIMESTAMP.txt"
fi

FULL_SNAPSHOT="$CAPTURE_DIR/full_snapshot_$TIMESTAMP.txt"
uname -a > "$FULL_SNAPSHOT"
date >> "$FULL_SNAPSHOT"
uptime >> "$FULL_SNAPSHOT"
ps aux >> "$FULL_SNAPSHOT"
df -h >> "$FULL_SNAPSHOT"

zip_name="log_v2_$TIMESTAMP.zip"
cd "$CAPTURE_DIR"
zip -r "$zip_name" ./*

cp "$zip_name" "$ICLOUD_LOG_DIR/"
cp "$zip_name" "$LOCAL_LOG_DIR/"

rm -rf "$CAPTURE_DIR"/*
