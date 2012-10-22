ROOT="/home/aditya/i9103"
CROSS_COMPILE="/home/aditya/Toolchain/arm-eabi-linaro-4.6.2/bin/arm-eabi"
KERNEL_DIR="/home/aditya/i9103/Kernel"
RAMDISK_DIR="/home/aditya/i9103/ramdisk"
MODULES_DIR="$RAMDISK_DIR/lib/modules"
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
echo "Please Release Version" 
read $version
echo ">> COMPILING! >>>"
make -j84
echo "Copying modules and stripping em"
find -name '*.ko' -exec cp -av {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Strip modules for size"

for m in $(find . | grep .ko | grep './')
do
        echo $m

$CROSS_COMPILE-strip --strip-unneeded $m
done
cd $KERNEL_DIR
echo "Packing Ramdisk"
cd $ROOT
./mkbootfs $RAMDISK_DIR | gzip > ramdisk.gz
./mkbootimg --kernel $KERNEL_DIR/arch/arm/boot/zImage --ramdisk ramdisk.gz -o $OUT/boot.img --base 10000000
cd $OUT
echo "CLear old zip files"
rm *.zip
echo "Making CWM Flashable zip"
zip -r GT-I9103_TITANIUM_KERNEL_BUILD-$version.zip META-INF boot.img
echo "DOne"
 
