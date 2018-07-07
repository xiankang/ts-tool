# Doesn't realy make sense anywhere else
if(NOT MSVC)
	return()
endif()

# Internal variable to avoid copying more than once
if(COPIED_DEPENDENCIES)
	return()
endif()

option(COPY_DEPENDENCIES "Automaticaly try copying all dependencies" ON)
if(NOT COPY_DEPENDENCIES)
	return()
endif()

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(_bin_suffix 64)
else()
	set(_bin_suffix 32)
endif()

#用于验证
include(OpensslBins)
file(GLOB SSLEAY_LIBEAY_FILES
	${openssl_dll}
)

#openssl_dll文件作为qt依赖进行添加
file(GLOB QT_DEBUG_BIN_FILES
	${SSLEAY_LIBEAY_FILES}
	"${Qt5Core_DIR}/../../../bin/Qt5Cored.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Cored.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5Guid.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Guid.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5Widgetsd.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Widgetsd.pdb"
	"${Qt5Core_DIR}/../../../bin/libGLESv2d.dll"
	"${Qt5Core_DIR}/../../../bin/libGLESv2d.pdb"
	"${Qt5Core_DIR}/../../../bin/libEGLd.dll"
	"${Qt5Core_DIR}/../../../bin/libEGLd.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5Quickd.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Quickd.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5Qmld.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Qmld.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5Networkd.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Networkd.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickTemplates2d.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickTemplates2d.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickControls2d.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickControls2d.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickWidgetsd.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickWidgetsd.pdb"
	"${Qt5Core_DIR}/../../../bin/Qt5Xmld.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Xmld.pdb"
	)
file(GLOB QT_DEBUG_PLAT_BIN_FILES
	"${Qt5Core_DIR}/../../../plugins/platforms/qwindowsd.dll")
file(GLOB QT_DEBUG_STYLES_BIN_FILES
	"${Qt5Core_DIR}/../../../plugins/styles/qwindowsvistastyled.dll")

file(GLOB QT_BIN_FILES
	${SSLEAY_LIBEAY_FILES}
	"${Qt5Core_DIR}/../../../bin/Qt5Core.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Gui.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Widgets.dll"
	"${Qt5Core_DIR}/../../../bin/libGLESv2.dll"
	"${Qt5Core_DIR}/../../../bin/libEGL.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Quick.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Qml.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Network.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickTemplates2.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickControls2.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5QuickWidgets.dll"
	"${Qt5Core_DIR}/../../../bin/Qt5Xml.dll"
	)
file(GLOB QT_PLAT_BIN_FILES
	"${Qt5Core_DIR}/../../../plugins/platforms/qwindows.dll")
file(GLOB QT_STYLES_BIN_FILES
	"${Qt5Core_DIR}/../../../plugins/styles/qwindowsvistastyle.dll")

file(GLOB QT_ICU_BIN_FILES
    "${Qt5Core_DIR}/../../../bin/icu*.dll")
    
set(ALL_BASE_BIN_FILES
    ${QT_ICU_BIN_FILES})

set(ALL_REL_BIN_FILES
    ${QT_BIN_FILES})
    
set(ALL_DBG_BIN_FILES
    ${QT_DEBUG_BIN_FILES})

set(ALL_PLATFORM_BIN_FILES)
set(ALL_PLATFORM_REL_BIN_FILES
    ${QT_PLAT_BIN_FILES})
set(ALL_PLATFORM_DBG_BIN_FILES
    ${QT_DEBUG_PLAT_BIN_FILES})

set(ALL_STYLES_BIN_FILES)
set(ALL_STYLES_REL_BIN_FILES
    ${QT_STYLES_BIN_FILES})
set(ALL_STYLES_DBG_BIN_FILES
    ${QT_DEBUG_STYLES_BIN_FILES})

foreach(list
    ALL_BASE_BIN_FILES ALL_REL_BIN_FILES ALL_DBG_BIN_FILES
    ALL_PLATFORM_BIN_FILES ALL_PLATFORM_REL_BIN_FILES ALL_PLATFORM_DBG_BIN_FILES
    ALL_STYLES_BIN_FILES ALL_STYLES_REL_BIN_FILES ALL_STYLES_DBG_BIN_FILES)
if(${list})
    list(REMOVE_DUPLICATES ${list})
endif()
endforeach()

message(STATUS "QT Debug files: ${QT_DEBUG_BIN_FILES}")
message(STATUS "QT Debug Platform files: ${QT_DEBUG_PLAT_BIN_FILES}")
message(STATUS "QT Debug Styles files: ${QT_DEBUG_STYLES_BIN_FILES}")
message(STATUS "QT Release files: ${QT_BIN_FILES}")
message(STATUS "QT Release Platform files: ${QT_PLAT_BIN_FILES}")
message(STATUS "QT Release Styles files: ${QT_STYLES_BIN_FILES}")
message(STATUS "QT ICU files: ${QT_ICU_BIN_FILES}")

foreach(BinFile ${ALL_BASE_BIN_FILES})
	message(STATUS "copying ${BinFile} to ${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}/")
endforeach()

foreach(BinFile ${ALL_REL_BIN_FILES})
	message(STATUS "copying ${BinFile} to ${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}r")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}r/")
endforeach()

foreach(BinFile ${ALL_DBG_BIN_FILES})
	message(STATUS "copying ${BinFile} to ${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}d")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}d/")
endforeach()

foreach(BinFile ${ALL_PLATFORM_BIN_FILES})
	make_directory("${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}/platforms")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}/platforms/")
endforeach()

foreach(BinFile ${ALL_PLATFORM_REL_BIN_FILES})
	make_directory("${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}r/platforms")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}r/platforms/")
endforeach()

foreach(BinFile ${ALL_PLATFORM_DBG_BIN_FILES})
	make_directory("${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}d/platforms")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}d/platforms/")
endforeach()

foreach(BinFile ${ALL_STYLES_BIN_FILES})
	make_directory("${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}/styles")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}/styles/")
endforeach()

foreach(BinFile ${ALL_STYLES_REL_BIN_FILES})
	make_directory("${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}r/styles")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}r/styles/")
endforeach()

foreach(BinFile ${ALL_STYLES_DBG_BIN_FILES})
	make_directory("${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}d/styles")
	file(COPY "${BinFile}" DESTINATION "${CMAKE_SOURCE_DIR}/additional_install_files/exec${_bin_suffix}d/styles/")
endforeach()

set(COPIED_DEPENDENCIES TRUE CACHE BOOL "Dependencies have been copied, set to false to copy again" FORCE)