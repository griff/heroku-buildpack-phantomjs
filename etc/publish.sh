#!/bin/sh

set -e

WINDOWS_1_9_URL="https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-windows.zip"
WINDOWS_1_9_DIR="phantomjs-1.9.8-windows"
DARWIN_1_9_URL="https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-1.9.8-macosx.zip"
DARWIN_1_9_DIR="phantomjs-1.9.8-macosx"
LINUX_2_0_URL="https://github.com/bprodoehl/phantomjs/releases/download/2.0.0-20141016/phantomjs-2.0.0-20141016-u1404-x86_64.zip"
LINUX_2_0_DIR="phantomjs-2.0.0-20141016"
DARWIN_2_0_URL="https://github.com/bprodoehl/phantomjs/releases/download/2.0.0-20141016/phantomjs-2.0.0-20141016-macosx.zip"
DARWIN_2_0_DIR="phantomjs-2.0.0-20141016"

make_tar() (
  local dir="$(eval "echo \${$1_DIR}")"
  local url="$(eval "echo \${$1_URL}")"
  if [ -z "$2" ]; then
    local out="${dir}.tar.bz2"
    local file="${dir}.zip"
  else
    local out="$2.tar.bz2"
    local file="$2.zip"
  fi
  echo "$dir $url"
  if [ -n "$dir" ]; then
    cd tmp
    rm -rf "$dir"
    if [ ! -s "$file" ]; then
      curl -L "$url" -o "$file"
    fi
    unzip "$file"
    if ! [ -d "${dir}/bin" ]; then
      mkdir -p "${dir}/bin"
      mv ${dir}/*.exe "${dir}/bin"
    fi
    mkdir -p "../out"
    tar cjf "../out/${out}" "${dir}/"
  fi
)
#rm -rf tmp
mkdir -p "tmp"

make_tar WINDOWS_1_9
make_tar DARWIN_1_9
make_tar LINUX_2_0 phantomjs-2.0.0-20141016-u1404-x86_64
make_tar DARWIN_2_0 phantomjs-2.0.0-20141016-macosx

scp -r out/* zev.maven-group.org:maven/www/default/phantomjs