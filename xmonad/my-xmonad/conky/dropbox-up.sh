# drobox-up
# echos the Dropbox upload speed
#!/usr/bin/env bash

status=`dropbox status | grep Uploading`
SYNC_REGEX="([0-9,]+) KB/sec"

[[ $status =~ $SYNC_REGEX ]]
upload_speed="${BASH_REMATCH[1]}"
if [[ $upload_speed != "" ]] ; then
  echo "$upload_speed KB/sec"
fi