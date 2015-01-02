#!/usr/bin/env bash

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testInstallDir() {
  compile

  assertCapturedSuccess
  assertTrue "Installs phantomjs" "[ -x ${BUILD_DIR}/vendor/phantomjs/bin/phantomjs ]"
  assertTrue "Profile.d file is created" "[ -f ${BUILD_DIR}/.profile.d/phantomjs.sh ]"

  . $BUILDPACK_HOME/export
  assertContains "Version is 1.9" "1.9.8" "$(phantomjs --version)"

  assertContains "User agent output" "SpecialAgent" \
    "$(phantomjs ${BUILD_DIR}/vendor/phantomjs/examples/useragent.js)"
}

testInstallVersion2() {
  echo "2.0" > $ENV_DIR/PHANTOMJS_VERSION
  compile

  assertCapturedSuccess
  assertTrue "Installs phantomjs" "[ -x ${BUILD_DIR}/vendor/phantomjs/bin/phantomjs ]"
  assertTrue "Profile.d file is created" "[ -f ${BUILD_DIR}/.profile.d/phantomjs.sh ]"

  . $BUILDPACK_HOME/export
  assertContains "Version is 2.0" "2.0.0" "$(phantomjs --version)"

  assertContains "User agent output" "SpecialAgent" \
    "$(phantomjs ${BUILD_DIR}/vendor/phantomjs/examples/useragent.js)"
}

testWrongVersion() {
  echo "3.0" > $ENV_DIR/PHANTOMJS_VERSION
  compile

  assertCapturedError 1 "Unsupported PhantomJS version: 3.0"
  assertFalse "Doesn't install phantomjs" "[ -x ${BUILD_DIR}/vendor/phantomjs/bin/phantomjs ]"
}

testInstallCrossTargetOS() {
  export TARGET_OS="WINDOWS"
  compile
  unset TARGET_OS

  assertCapturedSuccess
  assertTrue "Installs phantomjs" "[ -f ${BUILD_DIR}/vendor/phantomjs/bin/phantomjs.exe ]"
  assertTrue "Profile.d file is created" "[ -f ${BUILD_DIR}/.profile.d/phantomjs.sh ]"
}

testInstallCrossPhantomJsOS() {
  echo "WINDOWS" > $ENV_DIR/PHANTOMJS_OS
  compile

  assertCapturedSuccess
  assertTrue "Installs phantomjs" "[ -f ${BUILD_DIR}/vendor/phantomjs/bin/phantomjs.exe ]"
  assertTrue "Profile.d file is created" "[ -f ${BUILD_DIR}/.profile.d/phantomjs.sh ]"
}
