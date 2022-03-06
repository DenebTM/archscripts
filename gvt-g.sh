#!/usr/bin/bash
sudo -A qemu-system-x86_64                                          \
    -enable-kvm -m 8G -smp cores=4,threads=2,sockets=1,maxcpus=8    \
    -cpu host,hv_relaxed,hv_spinlocks=0x1fff,hv_vapic,hv_time       \
    -machine q35 -display gtk,gl=on -vga none                       \
    -name win10 -usb -device usb-tablet                             \
    -netdev bridge,id=hn0,br=virbr0 -device virtio-net-pci,netdev=hn0,id=nic1\
    -device vfio-pci,sysfsdev="/sys/devices/pci0000:00/0000:00:02.0/8a88a4ed-e327-4ea2-a9c6-efb3467a04b3",x-igd-opregion=on,display=on,ramfb=on,driver=vfio-pci-nohotplug       \
    -drive file=/home/deneb/win10.qcow2,format=qcow2                &
#   -drive id=vda,if=none,file=/home/deneb/win10.qcow2,format=qcow2 \
#   -device virtio-blk-pci,drive=vda                                &

if [[ -z "$(pidof scream)" ]]; then scream -i virbr0; fi

#   -global PIIX4_PM.disable_s3=1 -global PIIX4_PM.disable_s4=1     \
#   -audiodev alsa,id=snd0 -device ich9-intel-hda -device hda-output,audiodev=snd0\
#   -device ich9-intel-hda,id=sound0,bus=pcie.0,addr=0x1b -device hda-duplex,id=sound0-codec0,bus=sound0.0,cad=0 \
