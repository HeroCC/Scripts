#!/bin/bash

maxAge="30" # Max Time in Days to keep on local drive
localMedia="$HOME/localMedia" # Location of Local Media
movieDirName="Movies" # Name of Movies directory (inside $localMedia)
tvDirName="TV"
rcloneDest="SGDMedia" # Destination for rclone to move to 

function main {
  cd $localMedia

  # Start Moving Movies
  # Modified from http://askubuntu.com/a/80683/353466
  # Find files with media older than $maxAge days, then move it to remote
  echo "Starting Movie search..."
  find $movieDirName -type d -ctime +$maxAge -print | xargs -I{} rclone move --delete-after "{}" "$rcloneDest:{}"
  echo "All Movies older than $maxAge moved to $rcloneDest"
  echo
  echo "Removing the following Empty Directories..."
  find "$localMedia/$movieDirName" -type d -empty -delete -print # Remove Empty Folders
  echo "Removed empty Movie Directories"
  echo

  echo "Starting TV search..."
  find $tvDirName -type f -mtime +$maxAge -print | xargs -d'\n' -I{} bash -c 'moveTV "{}"' _
  echo "TV Search Finished"
}

function moveTV {
  remoteLocation=${@%/*} # http://stackoverflow.com/a/15137779/1709894
  echo "Moving $@ to $rcloneDest:$remoteLocation"
  rclone move --delete-after "$@" "$rcloneDest:$remoteLocation"
  echo
  #xargs -I{} rclone move --delete-after "{}" "$rcloneDest:$(dirname {})"
}
export -f moveTV

function setOpts {
  export rcloneDest
}

function cleanup {
  unset moveTV

  unset rcloneDest
}

setOpts
main "$@"
cleanup
