#!/usr/bin/env python3
import os
import os.path
import time
import sys
import traceback
from blessed import Terminal
t = Terminal()

# update every 5 seconds by default
update_delay = 5
i = sys.argv.index('-t') if '-t' in sys.argv else None
if i and len(sys.argv) > i:
    update_delay = float(sys.argv[i+1])

# rows,columns = os.popen('stty size', 'r').read().split()

# relevant virtual files
pwr_path = '/sys/class/power_supply/'
energy_filenames = ['energy_full_design',
                    'energy_full', 'energy_now', 'power_now']
bat_list = [name for name in sorted(
    os.listdir(pwr_path)) if name.startswith('BAT')]


def printW(pwr):
    print(f'{pwr:7.2f}', end=' W')


def print_all():
    pwrvals = []
    totals = [0, 0, 0, 0]
    print('\n', end=t.clear_eos)
    for n, b in enumerate(bat_list):
        print(b+':')
        pwrvals.append([])
        for i, p in enumerate(energy_filenames):
            file = open(pwr_path+b + '/' + p, 'r')
            pwr = round(float(file.readline()) / 1000000, 2)
            pwrvals[n].append(pwr)
            totals[i] = round(totals[i] + pwrvals[n][i], 2)

            print(f'{p:28s}: ', end='')
            if p == "energy_now":
                percentage = pwrvals[n][2] / pwrvals[n][1]
                if percentage < 0.25:
                    print(t.bright_red, end='')
                elif percentage < 0.8:
                    print(t.bright_yellow, end='')
                else:
                    print(t.bright_green, end='')
            printW(pwr)
            if p != "power_now":
                print('h')
            if p == "energy_now":
                print(t.normal, end='')

        print('\n' * 2, end='')

    # total up all present batteries
    if len(bat_list) > 1:
        print('-' * 40)
        print('\nTotal:')
        for i, p in enumerate(energy_filenames):
            print(f'{energy_filenames[i]:28s}: ', end='')
            if p == "energy_now":
                percentage = totals[2] / totals[1]
                if percentage < 0.25:
                    print(t.bright_red, end='')
                elif percentage < 0.8:
                    print(t.bright_yellow, end='')
                else:
                    print(t.bright_green, end='')
            printW(totals[i])
            if p != "power_now":
                print('h')
            if p == "energy_now":
                print(t.normal, end='')
        print()

    print()


def update_bat_count():
    global bat_list
    bat_list = [name for name in sorted(
        os.listdir(pwr_path)) if name.startswith('BAT')]


try:
    if '--once' in sys.argv:
        print_all()
        sys.exit(0)
    else:
        while True:
            with t.hidden_cursor():
                with t.location():
                    print_all()
                time.sleep(update_delay)
                update_bat_count()

except KeyboardInterrupt:
    sys.exit(0)
except Exception:
    traceback.print_exc(file=sys.stdout)
