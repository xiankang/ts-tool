set(XLSX_INCLUDE_DIRS
  ${CMAKE_SOURCE_DIR}/xlsx
)

macro(use_xlsx_module _target)
  target_link_libraries(${_target} xlsx)
  include_directories(${XLSX_INCLUDE_DIRS})
endmacro()

set(xlsx_Debug_path
  ${CMAKE_BINARY_DIR}/xlsx/Debug/
)
set(xlsx_Release_path
  ${CMAKE_BINARY_DIR}/xlsx/Release/
)

function(xlsx_helper_install_dir target target_configs pattern source dest)
	add_custom_command(TARGET ${target} POST_BUILD
  COMMAND "${CMAKE_COMMAND}"
			"-DCONFIG=$<CONFIGURATION>"
      "-DTARGET_CONFIGS=${target_configs}"
      "-DPATTERN=${pattern}"
			"-DINPUT=${source}"
			"-DOUTPUT=${dest}"
			-P "${CMAKE_SOURCE_DIR}/cmake/install_helper.cmake"
		VERBATIM)
endfunction()

function(install_xlsx_bin target)
  xlsx_helper_install_dir(${target} "Release;MinSizeRel;RelWithDebInfo"
    ".*.dll"
    "${xlsx_Release_path}"
    "${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE}")
  xlsx_helper_install_dir(${target} "Debug"
    ".*.dll|.*.pdb"
    "${xlsx_Debug_path}"
    "${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG}")
endfunction()

