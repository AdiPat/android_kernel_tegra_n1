ROOT="/home/aditya/i9103"
CROSS_COMPILE="/home/aditya/Toolchain/arm-eabi-linaro-4.6.2/bin/arm-eabi"
KERNEL_DIR="/home/aditya/i9103/Kernel"
RAMDISK_DIR="/home/aditya/i9103/ramdisk"
RAMDISK_CM_DIR="/home/aditya/i9103/ramdisk-cm10"
MODULES_DIR="$RAMDISK_DIR/lib/modules"
MODULES_CM_DIR="$RAMDISK_CM_DIR/lib/modules"
OUT="/home/aditya/i9103/out"

echo "|~~~~~~~~COMPILING TITANIUM KERNEL ~~~~~~~~~~~|"
echo "|---------------------------------------------|"
echo "Cleaning source"
cd ../
rm *.zip
rm *.img
rm *.gz
cd out 
rm *.img
cd $KERNEL_DIR 
export CROSS_COMPILE=$CROSS_COMPILE-
make clean mrproper
echo "Importing defconfig"
make tegra_n1_defconfig
echo "Please Enter Release Version" 
read $version
echo ">> COMPILING! >>>"
make -j84
echo "Copying modules and stripping em"
find -name '*.ko' -exec cp -av {} $MODULES_DIR/ \;
find -name '*.ko' -exec cp -av {} $MODULES_CM_DIR/ \;
cd $MODULES_DIR
echo "Strip modules for size"

for m in $(find . | grep .ko | grep './')
do
        echo $m

/home/aditya/Toolchain/arm-eabi-linaro-4.6.2/bin/arm-eabi-strip --strip-unneeded $m
done

cd $MODULES_CM_DIR
for m in $(find . | grep .ko | grep './')
do
        echo $m

/home/aditya/Toolchain/arm-eabi-linaro-4.6.2/bin/arm-eabi-strip --strip-unneeded $m
done
cd $KERNEL_DIR
echo "Packing Ramdisk"
cd $ROOT
./mkbootfs $RAMDISK_DIR | gzip > ramdisk.gz
./mkbootfs $RAMDISK_CM_DIR | gzip > ramdisk-cm10.gz 
./mkbootimg --kernel $KERNEL_DIR/arch/arm/boot/zImage --ramdisk ramdisk.gz -o $OUT/boot.img --base 10000000
./mkbootimg --kernel $KERNEL_DIR/arch/arm/boot/zImage --ramdisk ramdisk-cm10.gz -o $OUT/boot_cm10.img --base 10000000
cd $OUT
echo "CLear old zip files"
rm *.zip
echo "Making CWM Flashable zip"
zip -r ICS_KERNEL.zip META-INF boot.img

echo "Signing the zip file"

java -jar signapk.jar testkey.x509.pem testkey.pk8 ICS_KERNEL.zip SIGNED_ICS_KERNEL.zip

rm ICS_KERNEL.zip
rm boot.img 
mv boot_cm10.img boot.img 

# pack cm10 

echo "Making CWM Flashable zip"
zip -r CM10_KERNEL.zip META-INF boot.img

echo "Signing the zip file"

java -jar signapk.jar testkey.x509.pem testkey.pk8 CM10_KERNEL.zip SIGNED_CM10_KERNEL.zip

#########
rm CM10_KERNEL.zip 
rm boot.img 

echo "DONE, PRESS ENTER TO FINISH"
read ANS
 
