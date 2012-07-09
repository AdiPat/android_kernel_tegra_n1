cp drivers/misc/fm_si4709/Si4709_driver.ko ../ramdisk/lib/modules/Si4709_driver.ko
cp drivers/scsi/scsi_wait_scan.ko ../ramdisk/lib/modules/scsi_wait_scan.ko
cp drivers/net/wireless/bcm4330/dhd.ko ../ramdisk/lib/modules/dhd.ko
cp drivers/bluetooth/bthid/bthid.ko ../ramdisk/lib/modules/bthid.ko

cd ../ramdisk/lib/modules

for i in $(find . | grep .ko | grep './')
do
        echo $i

/home/aditya/Toolchain/arm-eabi-4.4.3/bin/arm-eabi-strip --strip-unneeded $i
done
