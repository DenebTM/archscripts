#!/usr/bin/env sh
echo 0 | sudo tee /sys/bus/usb/devices/1-6/bConfigurationValue
echo 1 | sudo tee /sys/bus/usb/devices/1-6/bConfigurationValue
