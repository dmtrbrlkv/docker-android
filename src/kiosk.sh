#!/bin/bash

function wait_emulator_to_be_ready () {
  boot_completed=false
  while [ "$boot_completed" == false ]; do
    status=$(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
    echo "Boot Status: $status"

    if [ "$status" == "1" ]; then
      boot_completed=true
    else
      sleep 1
    fi
  done
}

function run_package () {
  boot_completed=false
  while true
  do
    cur_package=$(adb shell "dumpsys activity activities | grep mResumedActivity" | cut -d "{" -f2 | cut -d " " -f3 | cut -d "/" -f1)
    echo "Current package: $cur_package"

    if [ "$cur_package" != "$PACKAGE_NAME" ]; then
      echo "Run App $PACKAGE_NAME"
      adb shell monkey -p $PACKAGE_NAME 1
    else
      sleep 5
    fi
  done
}

function install_apk() {
  echo "Install APK $APK_NAME"
  adb install "/var/apk/$APK_NAME" || exit_code=$?
  counter=0
  while $exit_code != 0 && $counter -lt 10
  do
    sleep 5
    counter=$(counter+1)
    echo "Try install $counter"
    adb install "/var/apk/$APK_NAME" || exit_code=$?
  done
}

wait_emulator_to_be_ready
sleep 1
install_apk
sleep 1
run_package