#!/usr/bin/env fish

set statefile "/tmp/sway_focus_follows_mouse"

# get current state
set state "$(cat "$statefile" 2>/dev/null || echo "yes")"

# update state
if [ "$state" = "yes" ]
  set state "no"
else
  set state "yes"
end

echo "$state" > "$statefile"

swaymsg focus_follows_mouse "$state"
