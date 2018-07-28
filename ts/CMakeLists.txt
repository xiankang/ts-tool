
cmake_minimum_required(VERSION 3.10.0)

set(FIND_MODE REQUIRED)

# set(FIND_MODE QUIET)


project(ts)

# set(DISABLE_UPDATE_MODULE TRUE CACHE BOOL "Disables building the update module")
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(_lib_suffix 64)
else()
	set(_lib_suffix 32)
endif()

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

set(ts_SRCS
  ${CMAKE_CURRENT_SOURCE_DIR}/download_excel.h
  ${CMAKE_CURRENT_SOURCE_DIR}/download_excel.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/excel_to_ts.h
  ${CMAKE_CURRENT_SOURCE_DIR}/excel_to_ts.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/excel_rw.h
  ${CMAKE_CURRENT_SOURCE_DIR}/excel_rw.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/ts_rw.h
  ${CMAKE_CURRENT_SOURCE_DIR}/ts_rw.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/translate_model.h
  ${CMAKE_CURRENT_SOURCE_DIR}/translate_model.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/config.h
  ${CMAKE_CURRENT_SOURCE_DIR}/config.cpp
)

set(all_SRCS
  ${ts_SRCS}
)

add_library(${PROJECT_NAME}
  ${all_SRCS}
)

qt5_use_modules(${PROJECT_NAME} Core WebSockets Xml)

#添加xlsx模块
include(XlsxBins)
use_xlsx_module(${PROJECT_NAME})

