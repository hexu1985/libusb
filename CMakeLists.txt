# set minimum cmake version                                                                                                                                            
cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

project(libusb LANGUAGES C)
message(STATUS "CMake version: " ${CMAKE_VERSION})
message(STATUS "CMake system name: " ${CMAKE_SYSTEM_NAME})

set(LIBUSB_VERSION_MAJOR 1)
set(LIBUSB_VERSION_MINOR 0)
set(LIBUSB_VERSION_PATCH 23)
set(LIBUSB_VERSION ${LIBUSB_VERSION_MAJOR}.${LIBUSB_VERSION_MINOR}.${LIBUSB_VERSION_PATCH})

## --- Build options ---
option(LIBUSB_BUILD_STATIC "Build static library" TRUE)
option(LIBUSB_BUILD_SHARED "Build shared library" FALSE)
option(LIBUSB_BUILD_EXAMPLES "Build examples" FALSE)

## compilation/linkage settings                                                                                                                                        
include_directories(
    .
	libusb
	#    ${CMAKE_BINARY_DIR}
    )

set(common_src
	libusb/core.c
	libusb/descriptor.c
	libusb/hotplug.c
	libusb/io.c
	libusb/strerror.c
	libusb/sync.c
	)

if (UNIX)
	list(APPEND common_src
		libusb/os/poll_posix.c
		libusb/os/threads_posix.c
		libusb/os/linux_usbfs.c
		libusb/os/linux_udev.c
		)
endif()

## common compilation for libusb 
add_library(common_obj OBJECT ${common_src}) 
set_target_properties(common_obj PROPERTIES POSITION_INDEPENDENT_CODE 1)

add_library(usb_shared
	SHARED
	$<TARGET_OBJECTS:common_obj>
	)

if (UNIX)
	target_link_libraries(usb_shared udev pthread)
endif()

set_target_properties(
	usb_shared PROPERTIES
	VERSION ${LIBUSB_VERSION}
	SOVERSION ${LIBUSB_VERSION_MAJOR})

set_target_properties(usb_shared
	PROPERTIES
	OUTPUT_NAME "usb"
	)

add_library(usb_static
	STATIC
	$<TARGET_OBJECTS:common_obj>
	)

set_target_properties(usb_static
	PROPERTIES
	OUTPUT_NAME "usb"
	)

## install file and targets
install(TARGETS usb_shared usb_static
	RUNTIME DESTINATION bin
	LIBRARY DESTINATION lib
	ARCHIVE DESTINATION lib_static
	)

install(FILES libusb/libusb.h 
	DESTINATION include
	)

install(DIRECTORY examples/ 
	DESTINATION examples
	)

## build examples
if (LIBUSB_BUILD_EXAMPLES)
	add_subdirectory(examples)
endif()

