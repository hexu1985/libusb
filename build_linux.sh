
rm -rf ./build
cmake -Bbuild -H. -DCMAKE_INSTALL_PREFIX=./install -DLIBUSB_BUILD_SHARED=ON -DLIBUSB_BUILD_EXAMPLES=ON
cmake --build build/ --target install
