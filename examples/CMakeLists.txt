
include_directories(
	${CMAKE_CURRENT_SOURCE_DIR}/../include
	${CMAKE_CURRENT_SOURCE_DIR}/../libusb
    )

link_directories(${CMAKE_BINARY_DIR})

option(USE_LIBUSB_SHARED "use shared library" FALSE)
if (USE_LIBUSB_SHARED)
	link_directories(${CMAKE_CURRENT_SOURCE_DIR}/../lib)
else()
	link_directories(${CMAKE_CURRENT_SOURCE_DIR}/../lib_static)
endif()

# samples
add_executable(dpfp dpfp.c)
target_link_libraries(dpfp usb udev pthread)

add_executable(listdevs listdevs.c)
target_link_libraries(listdevs usb udev pthread)

add_executable(hotplugtest hotplugtest.c)
target_link_libraries(hotplugtest usb udev pthread)


