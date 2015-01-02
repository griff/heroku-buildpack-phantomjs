#!/bin/sh

set -e

mkdir -p "tmp"

tar -c --exclude out --exclude tmp -f - . | docker run --rm -e \
  BUILDPACK_URL=https://github.com/heroku/heroku-buildpack-testrunner \
  -v /tmp/app-cache/phantomjs-buildpack:/tmp/cache:rw -i flynn/slugbuilder - > tmp/slug.tgz

TARGET=$1
if [ -z "$TARGET" ]; then
  TARGET=tests
fi

cat tmp/slug.tgz | docker run --rm -i -a stdin -a stdout -a stderr \
  -e SHUNIT_HOME=/app/.shunit2 flynn/slugrunner start $TARGET