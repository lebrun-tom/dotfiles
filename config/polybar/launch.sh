#!/bin/env bash

# Terminate already running bars
killall -q polybar

# Wait until bars have been terminated
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar
# polybar top &

# Manage multiple monitors
if type "xrandr"; then
  IFS=$'\n'  # must set internal field separator to avoid dumb
  for m in $(xrandr --query | grep " connected"); do
    mon=$(cut -d" " -f1 <<< "$m")
    status=$(cut -d" " -f3 <<< "$m")
    tray_pos=""  
    divider="" 

    if [ "$status" == "primary" ]; then      
        divider="|"                      
        tray_pos="right"                                              
    fi  

    MONITOR=$mon TRAY_POS=$tray_pos DIVIDER=$divider polybar -r top &
  done
    unset IFS  # avoid mega dumb by resetting the IFS
else
  polybar --reload top &
fi