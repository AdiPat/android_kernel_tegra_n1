echo "|~~~~~~~~COMPILING TITANIUM KERNEL ~~~~~~~~~~~|"
echo "|---------------------------------------------|"
echo "Cleaning source"
cd ../
rm *.zip
rm *.img
rm *.gz
cd out 
rm *.img
cd ../Kernel  
make clean mrproper
echo "Importing defconfig"
make tegra_n1_defconfig
echo "Please Release Version" 
read $version
echo ">> COMPILING! >>>"
make -j84
echo "Copying modules and stripping em"
find -name '*.ko' -exec cp -av {} ../ramdisk/lib/modules/ \;
cd ../ramdisk/lib/modules
echo "Strip modules for size"

for m in $(find . | grep .ko | grep './')
do
        echo $m

/home/aditya/Toolchain/arm-eabi-4.4.3/bin/arm-eabi-strip --strip-unneeded $m
done
cd ~/i9103/Kernel 
echo "Packing Ramdisk"
cd ..
./mkbootfs ramdisk | gzip > ramdisk.gz
./mkbootimg --kernel Kernel/arch/arm/boot/zImage --ramdisk ramdisk.gz -o out/boot.img --base 10000000
cd out
echo "CLear old zip files"
rm *.zip
echo "Making CWM Flashable zip"
zip -r GT-I9103_TITANIUM_KERNEL_BUILD-$version.zip META-INF boot.img
echo "DOne"
 
