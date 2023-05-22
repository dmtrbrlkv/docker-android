#!/bin/bash

function hide_other_window () {
  while true
  do
    wmctrl -c 'Running in Nested'
    wmctrl -r Emulator -b add,hidden
    wmctrl -a Android
    sleep 5
  done
}

if [[ $WINDOW_CONTROL == '1' ]]; then
	hide_other_window
fi