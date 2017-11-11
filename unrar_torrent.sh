#!/bin/bash

UNRAR=/usr/bin/unrar

function extract_rar() {
  isRar=$(ls | grep *.rar)
  if [ -n "$isRar" ]; then
    # Handle an edge case with some distributors
    isPart01="$(ls *.rar | egrep -i 'part01.rar|part1.rar')"
    if [ -n "$isPart01" ]; then
      isRar=$isPart01
    fi

    toUnrar="$(pwd)/$isRar"

    # We need to move to new location so sonarr doesn't try to mv before it's done
    # Also, unrar doesn't support changing the filename on extracting, makes sense a little bit
    pushd /tmp
    fileName="$($UNRAR e -y $toUnrar | egrep "^\.\.\..*OK" | awk '{ print $2 }')"

    # mv it back so sonarr can now find it
    mv $fileName $(dirname $toUnrar)
    popd
  fi
}

echo "Starting  - $(date)"

cd "$TR_TORRENT_DIR"

# If the script is passed a filename as the first argument, use that instead of an ENV variable
if [[ $# -eq 1 ]] ; then
  TR_TORRENT_NAME=$1
fi

if [ -d "$TR_TORRENT_NAME" ]; then
  cd "$TR_TORRENT_NAME"
  # handle multiple episode packs, like those that contain a whole season, or just a single episode
  for rar in $(find . -name '*.rar' -exec dirname {} \; | sort -u);
  do
    pushd $rar
    extract_rar
    popd
  done
fi

