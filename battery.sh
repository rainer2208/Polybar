#!/bin/sh

export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

# Battery percentage at which to notify
WARNING_LEVEL=30
BATTERY_DISCHARGING=`acpi -b | grep "Battery 0" | grep -c "Discharging"`
BATTERY_LEVEL=`acpi -b | grep "Battery 0" | grep -P -o '[0-9]+(?=%)'`

# Use two files to store whether we've shown a notification or not (to prevent multiple notifications)
EMPTY_FILE=/tmp/batteryempty
FULL_FILE=/tmp/batteryfull

# Reset notifications if the computer is charging/discharging
if [ $BATTERY_DISCHARGING -eq 1 ] && [ -f $FULL_FILE ]; then
    rm $FULL_FILE
elif [ $BATTERY_DISCHARGING -eq 0 ] && [ -f $EMPTY_FILE ]; then
    rm $EMPTY_FILE
fi

# If the battery is charging and is full (and has not shown notification yet)
if [ $BATTERY_LEVEL -gt 95 ] && [ $BATTERY_DISCHARGING -eq 0 ] && [ ! -f $FULL_FILE ]; then
    notify-send "Battery Charged" "Battery is fully charged." -r 9991
    touch $FULL_FILE
# If the battery is low and is not charging (and has not shown notification yet)
elif [ $BATTERY_LEVEL -le $WARNING_LEVEL ] && [ $BATTERY_DISCHARGING -eq 1 ] && [ ! -f $EMPTY_FILE ]; then
    notify-send "Low Battery" "${BATTERY_LEVEL}% of battery remaining." -u critical -r 9991
    touch $EMPTY_FILE
fi

#!/bin/sh
# You could place this script in e.g. `${HOME}/scripts/alert-battery.sh`

#threshold=46  # threshold percentage to trigger alert

# Use `awk` to capture `acpi`'s percent capacity ($2) and status ($3) fields
# and read their values into the `status` and `capacity` variables


#acpi -b | awk -F'[,:%]' '{print $2, $3}' | {
#  read -r status capacity

  # If battery is discharging with capacity below threshold
 # if [ "${status}" = Discharging -a "${capacity}" -lt ${threshold} ];
  #then
    # Send a notification that appears for 300000 ms (5 min)
   # notify-send -t 300000 "Charge your battery!"
 # fi
#}