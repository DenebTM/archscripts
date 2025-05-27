#!/bin/sh
sudo rsync -v --info=progress2 --info=name0 -aHAXS -x --exclude='/dev/*' --exclude='/proc/*' --exclude='/sys/*' --exclude='/tmp/*' --exclude='/run/*' --exclude='/mnt/*' --exclude='/media/*' --exclude='/lost+found/' $1/ $2/
