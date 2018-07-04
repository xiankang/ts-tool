if(CMAKE_SIZEOF_VOID_P EQUAL 8)
	set(_lib_suffix 64)
else()
	set(_lib_suffix 32)
endif()

set(OBS_OUTPUT_DIR "${CMAKE_BINARY_DIR}/rundir")

if(WIN32 OR APPLE)
	set(_struct_def FALSE)
else()
	set(_struct_def TRUE)
endif()

if(NOT UNIX_STRUCTURE)
	set(OBS_DATA_DESTINATION "data")
	if(APPLE)
		set(OBS_EXECUTABLE_DESTINATION "bin")
		set(OBS_EXECUTABLE32_DESTINATION "bin")
		set(OBS_EXECUTABLE64_DESTINATION "bin")
		set(OBS_LIBRARY_DESTINATION "bin")
		set(OBS_LIBRARY32_DESTINATION "bin")
		set(OBS_LIBRARY64_DESTINATION "bin")
		set(OBS_PLUGIN_DESTINATION "obs-plugins")
		set(OBS_PLUGIN32_DESTINATION "obs-plugins")
		set(OBS_PLUGIN64_DESTINATION "obs-plugins")

		set(OBS_DATA_PATH "../${OBS_DATA_DESTINATION}")
		set(OBS_INSTALL_PREFIX "")
		set(OBS_RELATIVE_PREFIX "../")

		set(OBS_SCRIPT_PLUGIN_DESTINATION "${OBS_DATA_DESTINATION}/obs-scripting/${_lib_suffix}bit")
	else()
		set(OBS_EXECUTABLE_DESTINATION "bin/${_lib_suffix}bit")
		set(OBS_EXECUTABLE32_DESTINATION "bin/32bit")
		set(OBS_EXECUTABLE64_DESTINATION "bin/64bit")
		set(OBS_LIBRARY_DESTINATION "bin/${_lib_suffix}bit")
		set(OBS_LIBRARY32_DESTINATION "bin/32bit")
		set(OBS_LIBRARY64_DESTINATION "bin/64bit")
		set(OBS_PLUGIN_DESTINATION "obs-plugins/${_lib_suffix}bit")
		set(OBS_PLUGIN32_DESTINATION "obs-plugins/32bit")
		set(OBS_PLUGIN64_DESTINATION "obs-plugins/64bit")

		set(OBS_DATA_PATH "../../${OBS_DATA_DESTINATION}")
		set(OBS_INSTALL_PREFIX "")
		set(OBS_RELATIVE_PREFIX "../../")

		set(OBS_SCRIPT_PLUGIN_DESTINATION "${OBS_DATA_DESTINATION}/obs-scripting/${_lib_suffix}bit")
	endif()
	set(OBS_CMAKE_DESTINATION "cmake")
	set(OBS_INCLUDE_DESTINATION "include")
	set(OBS_UNIX_STRUCTURE "0")

	set(OBS_SCRIPT_PLUGIN_PATH "${OBS_RELATIVE_PREFIX}${OBS_SCRIPT_PLUGIN_DESTINATION}")
else()
	if(NOT OBS_MULTIARCH_SUFFIX AND DEFINED ENV{OBS_MULTIARCH_SUFFIX})
		set(OBS_MULTIARCH_SUFFIX "$ENV{OBS_MULTIARCH_SUFFIX}")
	endif()

	set(OBS_EXECUTABLE_DESTINATION "bin")
	set(OBS_EXECUTABLE32_DESTINATION "bin32")
	set(OBS_EXECUTABLE64_DESTINATION "bin64")
	set(OBS_LIBRARY_DESTINATION "lib${OBS_MULTIARCH_SUFFIX}")
	set(OBS_LIBRARY32_DESTINATION "lib32")
	set(OBS_LIBRARY64_DESTINATION "lib64")
	set(OBS_PLUGIN_DESTINATION "${OBS_LIBRARY_DESTINATION}/obs-plugins")
	set(OBS_PLUGIN32_DESTINATION "${OBS_LIBRARY32_DESTINATION}/obs-plugins")
	set(OBS_PLUGIN64_DESTINATION "${OBS_LIBRARY64_DESTINATION}/obs-plugins")
	set(OBS_DATA_DESTINATION "share/obs")
	set(OBS_CMAKE_DESTINATION "${OBS_LIBRARY_DESTINATION}/cmake")
	set(OBS_INCLUDE_DESTINATION "include/obs")

	set(OBS_DATA_PATH "${OBS_DATA_DESTINATION}")
	set(OBS_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}/")
	set(OBS_RELATIVE_PREFIX "../")
	set(OBS_UNIX_STRUCTURE "1")

	set(OBS_SCRIPT_PLUGIN_DESTINATION "${OBS_LIBRARY_DESTINATION}/obs-scripting")
	set(OBS_SCRIPT_PLUGIN_PATH "${OBS_INSTALL_PREFIX}${OBS_SCRIPT_PLUGIN_DESTINATION}")
endif()


function(obs_helper_copy_dir target target_configs source dest)
	add_custom_command(TARGET ${target} POST_BUILD
		COMMAND "${CMAKE_COMMAND}"
			"-DCONFIG=$<CONFIGURATION>"
			"-DTARGET_CONFIGS=${target_configs}"
			"-DINPUT=${source}"
			"-DOUTPUT=${dest}"
			-P "${CMAKE_SOURCE_DIR}/cmake/copy_helper.cmake"
		VERBATIM)
endfunction()

function(obs_install_additional maintarget)
	set(addfdir "${CMAKE_SOURCE_DIR}/additional_install_files")
	if(DEFINED ENV{obsAdditionalInstallFiles})
		set(addfdir "$ENV{obsAdditionalInstallFiles}")
	endif()

	if(CMAKE_SIZEOF_VOID_P EQUAL 8)
		set(_lib_suffix 64)
	else()
		set(_lib_suffix 32)
	endif()

	# install(DIRECTORY "${addfdir}/misc/"
	# 	DESTINATION "."
	# 	USE_SOURCE_PERMISSIONS
	# 	PATTERN ".gitignore" EXCLUDE)
	# install(DIRECTORY "${addfdir}/data/"
	# 	DESTINATION "${OBS_DATA_DESTINATION}"
	# 	USE_SOURCE_PERMISSIONS
	# 	PATTERN ".gitignore" EXCLUDE)

	if(INSTALLER_RUN)
		install(DIRECTORY "${addfdir}/libs32/"
			DESTINATION "${OBS_LIBRARY32_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec32/"
			DESTINATION "${OBS_EXECUTABLE32_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/libs64/"
			DESTINATION "${OBS_LIBRARY64_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec64/"
			DESTINATION "${OBS_EXECUTABLE64_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			PATTERN ".gitignore" EXCLUDE)

		install(DIRECTORY "${addfdir}/libs32d/"
			DESTINATION "${OBS_LIBRARY32_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Debug
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec32d/"
			DESTINATION "${OBS_EXECUTABLE32_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Debug
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/libs64d/"
			DESTINATION "${OBS_LIBRARY64_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Debug
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec64d/"
			DESTINATION "${OBS_EXECUTABLE64_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Debug
			PATTERN ".gitignore" EXCLUDE)

		install(DIRECTORY "${addfdir}/libs32r/"
			DESTINATION "${OBS_LIBRARY32_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Release RelWithDebInfo MinSizeRel
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec32r/"
			DESTINATION "${OBS_EXECUTABLE32_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Release RelWithDebInfo MinSizeRel
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/libs64r/"
			DESTINATION "${OBS_LIBRARY64_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Release RelWithDebInfo MinSizeRel
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec64r/"
			DESTINATION "${OBS_EXECUTABLE64_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Release RelWithDebInfo MinSizeRel
			PATTERN ".gitignore" EXCLUDE)
	else()
		install(DIRECTORY "${addfdir}/libs${_lib_suffix}/"
			DESTINATION "${OBS_LIBRARY_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec${_lib_suffix}/"
			DESTINATION "${OBS_EXECUTABLE_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			PATTERN ".gitignore" EXCLUDE)

		install(DIRECTORY "${addfdir}/libs${_lib_suffix}d/"
			DESTINATION "${OBS_LIBRARY_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Debug
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec${_lib_suffix}d/"
			DESTINATION "${OBS_EXECUTABLE_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Debug
			PATTERN ".gitignore" EXCLUDE)

		install(DIRECTORY "${addfdir}/libs${_lib_suffix}r/"
			DESTINATION "${OBS_LIBRARY_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Release RelWithDebInfo MinSizeRel
			PATTERN ".gitignore" EXCLUDE)
		install(DIRECTORY "${addfdir}/exec${_lib_suffix}r/"
			DESTINATION "${OBS_EXECUTABLE_DESTINATION}"
			USE_SOURCE_PERMISSIONS
			CONFIGURATIONS Release RelWithDebInfo MinSizeRel
			PATTERN ".gitignore" EXCLUDE)
	endif()

	# obs_helper_copy_dir(${maintarget} ALL
	# 	"${addfdir}/misc/"
	# 	"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/")
	# obs_helper_copy_dir(${maintarget} ALL
	# 	"${addfdir}/data/"
	# 	"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/${OBS_DATA_DESTINATION}/")
	# obs_helper_copy_dir(${maintarget} ALL
	# 	"${addfdir}/libs${_lib_suffix}/"
	# 	"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/${OBS_LIBRARY_DESTINATION}/")
	# obs_helper_copy_dir(${maintarget} ALL
	# 	"${addfdir}/exec${_lib_suffix}/"
	# 	"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/${OBS_EXECUTABLE_DESTINATION}/")

	obs_helper_copy_dir(${maintarget} "Release;MinSizeRel;RelWithDebInfo"
		"${addfdir}/exec${_lib_suffix}r/"
		"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/${OBS_EXECUTABLE_DESTINATION}/")
	obs_helper_copy_dir(${maintarget} "Debug"
		"${addfdir}/exec${_lib_suffix}d/"
		"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/${OBS_EXECUTABLE_DESTINATION}/")
	# obs_helper_copy_dir(${maintarget} "Release;MinSizeRel;RelWithDebInfo"
	# 	"${addfdir}/libs${_lib_suffix}r/"
	# 	"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/${OBS_LIBRARY_DESTINATION}/")
	# obs_helper_copy_dir(${maintarget} "Debug"
	# 	"${addfdir}/libs${_lib_suffix}d/"
	# 	"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/${OBS_LIBRARY_DESTINATION}/")
endfunction()

function(install_obs_bin target mode)
	foreach(bin ${ARGN})
		if(APPLE)
			set(_bit_suffix "")
		elseif(CMAKE_SIZEOF_VOID_P EQUAL 8)
			set(_bit_suffix "64bit/")
		else()
			set(_bit_suffix "32bit/")
		endif()

		if(NOT IS_ABSOLUTE "${bin}")
			set(bin "${CMAKE_CURRENT_SOURCE_DIR}/${bin}")
		endif()

		get_filename_component(fname "${bin}" NAME)

		if(NOT "${mode}" MATCHES "INSTALL_ONLY")
			add_custom_command(TARGET ${target} POST_BUILD
				COMMAND "${CMAKE_COMMAND}" -E copy
					"${bin}"
					"${OBS_OUTPUT_DIR}/$<CONFIGURATION>/bin/${_bit_suffix}${fname}"
				VERBATIM)
		endif()

		install(FILES "${bin}"
			DESTINATION "${OBS_EXECUTABLE_DESTINATION}")

		if(DEFINED ENV{obsInstallerTempDir})
			add_custom_command(TARGET ${target} POST_BUILD
				COMMAND "${CMAKE_COMMAND}" -E copy
					"${bin}"
					"$ENV{obsInstallerTempDir}/${OBS_EXECUTABLE_DESTINATION}/${fname}"
				VERBATIM)
		endif()
	endforeach()
endfunction()