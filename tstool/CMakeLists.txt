cmake_minimum_required(VERSION 3.10.0)

if(DISABLE_UI)
	message(STATUS "UI disabled")
	return()
elseif(ENABLE_UI)
	set(FIND_MODE REQUIRED)
else()
	set(FIND_MODE QUIET)
endif()

#项目
project(tstool)

set(EXECUTABLE_NAME ${PROJECT_NAME})

set(EXECUTABLE_OUTPUT_PATH "${CMAKE_BINARY_DIR}/rundir")

# set(DISABLE_UPDATE_MODULE TRUE CACHE BOOL "Disables building the update module")
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(_lib_suffix 64)
else()
	set(_lib_suffix 32)
endif()

foreach (config ${CMAKE_CONFIGURATION_TYPES})
	string(TOUPPER "${config}" config_upper)
	set(CMAKE_RUNTIME_OUTPUT_DIRECTORY_${config_upper} ${EXECUTABLE_OUTPUT_PATH}/${config}/bin/${_lib_suffix}bit)
	message(${CMAKE_RUNTIME_OUTPUT_DIRECTORY_${config_upper}})
endforeach ()


if(DEFINED QTDIR${_lib_suffix})
	list(APPEND CMAKE_PREFIX_PATH "${QTDIR${_lib_suffix}}")
elseif(DEFINED QTDIR)
	list(APPEND CMAKE_PREFIX_PATH "${QTDIR}")
elseif(DEFINED ENV{QTDIR${_lib_suffix}})
	list(APPEND CMAKE_PREFIX_PATH "$ENV{QTDIR${_lib_suffix}}")
elseif(DEFINED ENV{QTDIR})
	list(APPEND CMAKE_PREFIX_PATH "$ENV{QTDIR}")
endif()


# Find includes in corresponding build directories
set(CMAKE_INCLUDE_CURRENT_DIR TRUE)
# Instruct CMake to run moc automatically when needed.
set(CMAKE_AUTOMOC TRUE)

# Find the QtWidgets library
find_package(Qt5Core ${FIND_MODE})

get_target_property(QtCore_location Qt5::Core LOCATION)

if(APPLE)
	find_package(Qt5MacExtras REQUIRED)
endif(APPLE)


# qt5_wrap_ui(UI_HEADERS ${forms_SRCS})

set(
	tstool_SRCS
	${CMAKE_CURRENT_SOURCE_DIR}/main.cpp
)
set(SRC_ALL_SRCS
  ${tstool_SRCS}
)

set(EXECUTABLE_SRCS  
  ${SRC_ALL_SRCS}
)

add_executable(${EXECUTABLE_NAME}
  ${EXECUTABLE_SRCS}
)

#用到的qt模块
qt5_use_modules(${PROJECT_NAME} Core Gui)

#添加xlsx模块
include(XlsxBins)
use_xlsx_module(${PROJECT_NAME})

#添加ts模块
include(TsBins)
use_ts_module(${PROJECT_NAME})

if(WIN32)
	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(_output_suffix "64")
	else()
		set(_output_suffix "32")
	endif()

	set_target_properties(${PROJECT_NAME}
		PROPERTIES
		OUTPUT_NAME "${PROJECT_NAME}${_output_suffix}")
endif()

if(APPLE)
  target_link_libraries(${PROJECT_NAME}
    Qt5::MacExtras
  )
endif()

obs_install_additional(${PROJECT_NAME})