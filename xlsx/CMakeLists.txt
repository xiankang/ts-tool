cmake_minimum_required(VERSION 2.8)

set(FIND_MODE REQUIRED)

# set(FIND_MODE QUIET)


project(xlsx)

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

set(private_SRCS
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxabstractooxmlfile_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxabstractsheet_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcell_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcellformula_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxchart_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcolor_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxchartsheet_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxconditionalformatting_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcontenttypes_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdatavalidation_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdocpropsapp_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdocpropscore_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdocument_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdrawing_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdrawinganchor_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxformat_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxmediafile_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxnumformatparser_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxrelationships_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxrichstring_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxsharedstrings_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxsimpleooxmlfile_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxstyles_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxtheme_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxutility_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxworkbook_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxworksheet_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxzipreader_p.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxzipwriter_p.h
)

set(xlsx_SRCS
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxabstractooxmlfile.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxabstractooxmlfile.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxabstractsheet.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxabstractsheet.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcell.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcell.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcellformula.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcellformula.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcellrange.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcellrange.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcellreference.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcellreference.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxchart.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxchart.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxchartsheet.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxchartsheet.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcolor.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxconditionalformatting.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxconditionalformatting.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxcontenttypes.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdatavalidation.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdatavalidation.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdocpropsapp.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdocpropscore.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdocument.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdocument.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdrawing.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxdrawinganchor.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxformat.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxformat.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxglobal.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxmediafile.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxnumformatparser.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxrelationships.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxrichstring.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxrichstring.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxsharedstrings.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxsimpleooxmlfile.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxstyles.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxtheme.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxutility.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxworkbook.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxworksheet.h
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxworksheet.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxzipreader.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/xlsxzipwriter.cpp
)

source_group(private 
  FILES
    ${private_SRCS}
)

set(all_SRCS
  ${private_SRCS}
  ${xlsx_SRCS}
)

add_library(${PROJECT_NAME}
  ${all_SRCS}
)

add_definitions(-DXLSX_NO_LIB)
add_definitions(-XLSX_NO_LIB)

#用到的qt模块
set(_link_type
  "LINK_PRIVATE"
)

qt5_use_modules(${PROJECT_NAME} Core Gui)
include_directories(${Qt5Gui_PRIVATE_INCLUDE_DIRS})


