# Terminate any running polybars
polybar-msg cmd quit
# Or go nuclear, if necessary
# killall -q polybar

echo "---" | tee -a /tmp/polybar.log
polybar bar 2>&1 | tee -a /tmp/polybar.log & disown
