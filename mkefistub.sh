#!/usr/bin/env bash
linver="linux-mainline"
opts="$1"
opts_add="${*:2}"
if ([ -z "$opts" ] || [ "$opts" = "default" ]); then
    #opts='intel_pstate=disable quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0'
    opts='quiet splash loglevel=3 rd.udev.log_level=3 vt.global_cursor_default=0 mitigations=off retbleed=off'
fi

efibootmgr -Bb0000
efibootmgr -d /dev/nvme0n1 -p 2 -c -L "Arch Linux" -l /vmlinuz-$linver -u "root=UUID=1456d5f8-fd84-4b43-88b9-bb84661adf8a resume=UUID=3742e812-e4cc-4721-82e5-67cbf8185ef4 rw initrd=\intel-ucode.img initrd=\initramfs-$linver.img $opts $opts_add" -v
