# drobox-down
# echos the Dropbox download speed
# http://y.tsutsumi.io/getting-dropbox-statuss-into-conky-dzen2.html
#!/usr/bin/env bash

status=`dropbox-cli status | grep Downloading`
SYNC_REGEX="([0-9,]+) KB/sec"

[[ $status =~ $SYNC_REGEX ]]
download_speed="${BASH_REMATCH[1]}"
if [[ $download_speed != "" ]] ; then
  echo "$download_speed KB/sec"
fi