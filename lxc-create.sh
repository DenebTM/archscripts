#!/usr/bin/env sh
sudo systemctl start libvirtd
sudo lxc-create -t /usr/share/lxc/templates/lxc-download -n "$1" &&
sudo lxc-start -n "$1" &&
sudo lxc-attach -n "$1"
