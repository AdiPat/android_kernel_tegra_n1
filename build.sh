setprop --bold
echo "|~~~~~~~~STARTING TITANIUM COMPILER~~~~~~~~~~~|"
echo "|---------------------------------------------|"
echo "Cleaning source"
make clean mrproper
echo "Importing defconfig"
make titanium_defconfig
echo ">> COMPILING! >>>"
make -j32
echo "Copying modules and stripping em"
./copy.sh
cd ../
echo "Packing Kernel"
./repack.sh
cd out
echo "CLear old zip files"
rm *.zip
echo "Making CWM Flashable zip"
echo "Enter kernel name"
read abc;
zip -r $abc.zip META-INF boot.img
echo "DOne"
 
