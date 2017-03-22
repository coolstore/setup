#!/bin/bash

GITHUB_ORG=coolstore

function unzip_strip() (
    local zip=$1
    local dest=${2:-.}
    local temp=$(mktemp -d XXXXXX) && unzip -qd "$temp" "$zip" && mkdir -p "$dest" &&
    shopt -s dotglob && local f=("$temp"/*) &&
    if (( ${#f[@]} == 1 )) && [[ -d "${f[0]}" ]] ; then
        mv -f "$temp"/*/* "$dest"
    else
        mv -f "$temp"/* "$dest"
    fi && rmdir "$temp"/* "$temp"
)

function download_and_extract() {
    curl -sL -o $1.zip https://github.com/${GITHUB_ORG}/$1/archive/master.zip && unzip_strip $1.zip ${repo} && rm -f $1.zip

}

if [ ! -z "$(ls)" ]; then
    read -p 'WARNING! The current directory is NOT empty are you sure you want to continue with the download, since it may override existing files? (y/N): ' answer
    if [ "$answer" != "" ]; then
      if [[ ! ${answer} =~ ^[Y|y] ]]; then 
        echo "User selected to abort"
        exit
      fi
    fi
fi

# repos=(setup common catalog gateway inventory sso ui)
repos=(setup common)


for repo in "${repos[@]}"
do
    echo "Downloading $repo"
    download_and_extract $repo 
done





