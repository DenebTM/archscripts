#!/usr/bin/python3
import os, os.path
import time, sys, traceback
import collections, operator
from functools import reduce

from blessed import Terminal
t = Terminal()

# check battery percentage twice per second by default
updateInterval = 0.5
i = sys.argv.index('-t') if '-t' in sys.argv else None
if i and len(sys.argv) > i:
    updateInterval = float(sys.argv[i+1])

# rows,columns = os.popen('stty size', 'r').read().split()

# relevant virtual files
powerpath = '/sys/class/power_supply'
batpath = powerpath + 'BAT'
paths = ['energy_full_design', 'energy_full', 'energy_now', 'power_now']
batts = [name for name in sorted(os.listdir(powerpath)) if name.startswith('BAT')]

def getPwrVals():
    global batts

    pwrvals = {}
    for batname in batts:
        pwrval = {}
        for path in paths:
            file = open(f'{powerpath}/{batname}/{path}', 'r')
            pwr = float(file.readline()) / 1e6
            pwrval[path] = pwr
        pwrvals[batname] = pwrval

    return pwrvals

def updateBatts():
    global batts
    batts = [name for name in sorted(os.listdir(powerpath)) if name.startswith('BAT')]

def printW(pwr):
    pwr = round(pwr, 2)
    if pwr < 10:
        print('  ', end='')
        print(str(pwr).ljust(4,'0').ljust(4), end=' W')
    elif pwr < 100:
        print(' ', end='')
        print(str(pwr).ljust(5,'0').ljust(5), end=' W')
    else:
        print(str(pwr).ljust(6,'0').ljust(6), end=' W')

def printPwrVal(key, pwrval):
    print(key+':')
    for path in pwrval:
        print((path+': ').ljust(30), end='')
        if path == "energy_now":
            percentage = float(pwrval['energy_now']) / float(pwrval['energy_full'])
            if percentage < 0.25:
                print(t.bright_red, end='')
            elif percentage < 0.8:
                print(t.bright_yellow, end='')
            else:
                print(t.bright_green, end='')
        printW(pwrval[path])
        if path != "power_now": print('h')
        if path == "energy_now":
            print(t.normal, end='')

def printAll(pwrvals):
    print(t.home + t.clear)
    totals = {}

    for key in pwrvals:
        pwrval = pwrvals[key]

        printPwrVal(key, pwrval)
        print('\n')

    # total up all present batteries
    if len(batts) > 1:
        totals = dict(reduce(operator.add,
                             map(collections.Counter,
                                 pwrvals.values())))

        print('-'.ljust(39, '-'), end='\n\n')
        printPwrVal('Total', totals)

    print()

if __name__ == '__main__':
    try:
        if '--once' in sys.argv:
            printAll(getPwrVals())
            sys.exit(0)
        else:
            pwrvals = {}
            with t.hidden_cursor(), t.fullscreen(), t.hidden_cursor():
                while True:
                    newvals = getPwrVals()
                    if newvals != pwrvals:
                        pwrvals = newvals
                        printAll(pwrvals)
                    time.sleep(updateInterval)
                    updateBatts()
    except KeyboardInterrupt:
        sys.exit(0)
    except Exception:
        traceback.print_exc(file=sys.stdout)
