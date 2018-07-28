set(config_Path
    ${CMAKE_SOURCE_DIR}/config
)

function(config_helper_install_dir target target_configs pattern source dest)
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

function(install_config target)
    config_helper_install_dir(${target} "Release;MinSizeRel;RelWithDebInfo"
    "config"
    "${config_Path}"
    "${CMAKE_RUNTIME_OUTPUT_DIRECTORY_RELEASE}")
    config_helper_install_dir(${target} "Debug"
    "config"
    "${config_Path}"
    "${CMAKE_RUNTIME_OUTPUT_DIRECTORY_DEBUG}")
endfunction()
