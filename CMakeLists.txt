cmake_minimum_required(VERSION 2.8)

#项目
project(ts-tool)

#库路径
set(LIB_PATH $(CMAKE_SOURCE_DIR)/lib)

#cmake 模块路径
set(CMAKE_MODULE_PATH
  ${CMAKE_MODULE_PATH}
  "${CMAKE_SOURCE_DIR}/cmake/Modules"
)
set(ENABLE_SCRIPTING TRUE CACHE BOOL "Enables scripting")
set(SCRIPTING_ENABLED OFF CACHE BOOL "Interal global cmake variable" FORCE)

# Force out-of-source build
if(${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR})
  message(FATAL_ERROR
    "This project requires an out of source build. Remove the file 'CMakeCache.txt' found in this directory before continuing, create a separate build directory and run 'cmake [options] <srcs>' from there."
  )
endif()

message("CMAKE_SOURCE_DIR= ${CMAKE_SOURCE_DIR}")
message("CMAKE_BINARY_DIR= ${CMAKE_BINARY_DIR}")

# TODO: allow other compilers under windows in the future
if(WIN32 AND NOT MSVC)
  message(FATAL_ERROR
    "Under Windows other compiler than Microsoft Visual Studio are not supported."
  )
endif()

# TODO: remove this in the future! it has only been added to make the switch easier for end users
if(PREFIX)
  message(FATAL_ERROR "The parameter PREFIX has been removed. Please re-run CMake and use CMAKE_INSTALL_PREFIX instead to define your installation location!")
endif()

# Override configuration-types - we don't use anything else than debug and release
if(CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_CONFIGURATION_TYPES Release Debug)
  set(CMAKE_CONFIGURATION_TYPES "${CMAKE_CONFIGURATION_TYPES}" CACHE STRING
    "Reset the configurations to what we need"
    FORCE)
endif()

set(BIN_DIR ${CMAKE_INSTALL_PREFIX}/bin)
set(CONF_DIR ${CMAKE_INSTALL_PREFIX}/etc)

# If win32 put it in the bin dir not lib
if(WIN32)
  set(LIBS_DIR ${CMAKE_INSTALL_PREFIX}/bin)
else()
  set(LIBS_DIR ${CMAKE_INSTALL_PREFIX}/lib)
endif()

# For Unix systems set the rpath so that libraries are found
set(CMAKE_INSTALL_RPATH ${LIBS_DIR})
set(CMAKE_INSTALL_NAME_DIR ${LIBS_DIR})
# Run out of build tree
set(CMAKE_BUILD_WITH_INSTALL_RPATH ON)
message("CMAKE_INSTALL_RPATH= ${CMAKE_INSTALL_RPATH}")

# 寻找包
# find_package()

if(PCH AND NOT PCHSupport_FOUND)
  set(PCH 0 CACHE BOOL
    "Use precompiled headers"
    FORCE)
  message(WARNING "No PCH for your system possible but PCH was set to 1. Resetting it."
  )
endif()
if(PCH)
  message(STATUS "Use PCH               : Yes")
else()
  message(STATUS "Use PCH               : No")
endif()

if(DEBUG)
  message(STATUS "Build in debug-mode   : Yes")
  set(CMAKE_BUILD_TYPE Debug)
else()
  set(CMAKE_BUILD_TYPE Release)
  message(STATUS "Build in debug-mode   : No  (default)")
endif()

# Handle debugmode compiles (this will require further work for proper WIN32-setups)
if(UNIX)
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -g")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -g")
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -g")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -g")
endif()

# Set warning levels for different builds
if(UNIX)
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} -fPIC -std=c++11 --no-warnings")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -fPIC -std=c++11 --no-warnings")
	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -fPIC -std=c++11 -Wall -Wfatal-errors -Wextra")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} -fPIC -std=c++11 -Wall -Wfatal-errors -Wextra")
elseif(WIN32)
  # Disable warnings in Visual Studio 8 and above and add /MP
  set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /Zi /wd4996 /wd4355 /wd4244 /wd4985 /wd4267 /wd4251 /MP")
  set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi /wd4996 /wd4355 /wd4244 /wd4267 /wd4251 /MP")
  set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /wd4996 /wd4355 /wd4244 /wd4985 /wd4267 /wd4251 /MP")
  set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /wd4996 /wd4355 /wd4244 /wd4985 /wd4267 /wd4251 /MP")
  set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /debug")
endif()

set(CMAKE_SKIP_BUILD_RPATH FALSE)
set(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
set(CMAKE_INSTALL_RPATH ${LIBS_DIR})
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)

# Add definitions for all build types
# Don't place this above 'dep' subdirectory! Because of defines build will crash.
set(DEFINITIONS  
	GLOG_NO_ABBREVIATED_SEVERITIES 
	GOOGLE_GLOG_DLL_DECL= 
	CPPCONN_LIB_BUILD 
	USE_CMAKE_CONFIG_H 
)
set(DEFINITIONS_RELEASE NDEBUG)
set(DEFINITIONS_DEBUG _DEBUG DEBUG)
if(WIN32)
  set(DEFINITIONS_DEBUG ${DEFINITIONS_DEBUG} WIN32 _WIN32 WIN32_LEAN_AND_MEAN ELPP_WINSOCK2)
  set(DEFINITIONS_RELEASE ${DEFINITIONS_RELEASE} WIN32 _WIN32 WIN32_LEAN_AND_MEAN ELPP_WINSOCK2 _CRT_SECURE_NO_WARNINGS)
endif()
 
macro(SET_COMMON_TARGET_PROPERTIES target)
  message("SET_COMMON_TARGET_PROPERTIES ${target}")
  target_compile_definitions(${target} PUBLIC ${DEFINITIONS})
  target_compile_definitions(${target} PUBLIC $<$<CONFIG:Debug>:${DEFINITIONS_DEBUG}>)
  target_compile_definitions(${target} PUBLIC $<$<CONFIG:Release>:${DEFINITIONS_RELEASE}>)
endmacro()


#依赖Qt
if(WIN32)
  if (QTDIR OR DEFINED ENV{QTDIR} OR DEFINED ENV{QTDIR32} OR DEFINED ENV{QTDIR64})
    # Qt path set by user or env var
  else()
    set(QTDIR "" CACHE PATH "Path to Qt (e.g. C:/Qt/5.7/msvc2015_64)")
    message(WARNING "QTDIR variable is missing.  Please set this variable to specify path to Qt (e.g. C:/Qt/5.7/msvc2015_64)")
  endif()
endif()

option(ENABLE_UI "Enables the OBS user interfaces" ON)
if(DISABLE_UI OR NOT ENABLE_UI)
  set(UI_ENABLED FALSE)
else()
  set(UI_ENABLED TRUE)
endif()

include(ObsHelpers)

add_subdirectory(xlsx)
add_subdirectory(tstool)

#增加运行子目录

#copy dll依赖
include(CopyMSVCBins)

