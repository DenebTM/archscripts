#!/usr/bin/env -S python3 -u
import os
import os.path
import time
import sys
import traceback


def get_temp():
    # this monitors the wrong sensors sometimes, plsfix
    tfile = open(f'/sys/class/hwmon/{sensor_name}/temp1_input', 'r')
    cpu_temp = int(tfile.readline()) / 1000
    tfile.close()
    return cpu_temp


# Temperature / fan level hysteresis
thresholds = [
    (-255, 67),
    (61, 70),
    (67, 74),
    (71, 77),
    (74, 80),
    (77, 85),
    (80, 255)
]
level = 0
fan_on_threshold = 0

# Determine which sensor to monitor
sensors_path = '/sys/class/hwmon'
sensors = [name for name in sorted(os.listdir(
    sensors_path)) if name.startswith('hwmon')]
for n, s in enumerate(sensors):
    file = open(f'{sensors_path}/{s}/name', 'r')
    name = file.readline().strip()
    file.close()
    if name == 'coretemp':
        sensor_name = s

# Running index
# The fan speed will be set every ten seconds, even if the correct speed hasn't
# changed. This is primarily to deal with level=auto after standby.
run = 0

# Start infinite loop
try:
    while (True):
        cpu_temp = get_temp()

        # Determine the correct fan speed
        hyst_min, hyst_max = thresholds[level]
        if cpu_temp < hyst_min:
            new_level = filter(lambda i: i[1][0] <= cpu_temp <= i[1][1],
                               enumerate(thresholds[:level]))[0][0]
        elif cpu_temp > hyst_max:
            new_level = filter(lambda i: i[1][0] <= cpu_temp <= i[1][1],
                               enumerate(thresholds[(level+1):]))[0][0]
        else:
            new_level = level

        # Be initially reluctant to increase the fan speed beyond level 1
        if 1 < new_level < 4 and level <= 1:
            if fan_on_threshold < 15:
                # Indicate that the fan is going to turn on soon
                if 0 < fan_on_threshold < 15:
                    print(f'Inhibiting level {new_level}, waiting '
                          + f'{15 - fan_on_threshold} more seconds.')

                # Set the correct fan speed on first run, though
                if run == 0:
                    fan_on_threshold = 15
                else:
                    new_level = 1
                    fan_on_threshold += 1

            # Reset the counter to 0 if the level is <= 1 or >= 4
            else:
                if 0 < fan_on_threshold < 15:
                    print('Stopped waiting.')
                fan_on_threshold = 0

        # If the level has changed (or the running index is 0), set it and
        # notify the user
        if new_level != level or run == 0:
            os.system('setfan ' + str(new_level) + ' > /dev/null')
            if new_level != level or run == 0:
                if run == 0:
                    print('init:', end=' ')
                elif new_level != level:
                    print(f'{level} -> {new_level}:', end=' ')
                print(f'Fan set to level {new_level}.')
            level = new_level

        # Increment and reset running index
        run = (run + 1) % 10

        time.sleep(1)

except KeyboardInterrupt:
    sys.exit(0)
except Exception:
    traceback.print_exc(file=sys.stdout)
