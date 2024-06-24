#!/usr/bin/env sh
echo 0 | sudo tee /sys/bus/usb/devices/1-3/bConfigurationValue
echo 3 | sudo tee /sys/bus/usb/devices/1-3/bConfigurationValue
