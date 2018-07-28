
if(NOT EXISTS "${INPUT}")
return()
endif()

set(_do_pass FALSE)
foreach(target ${TARGET_CONFIGS})
if(target STREQUAL "${CONFIG}" OR target STREQUAL "ALL")
    set(_do_pass TRUE)
endif()
endforeach()

if(NOT _do_pass)
return()
endif()

message(${INPUT})
message(${OUTPUT})
message(${PATTERN})

# make_directory(${OUTPUT})
file(INSTALL "${INPUT}" 
    DESTINATION "${OUTPUT}" 
    USE_SOURCE_PERMISSIONS 
    FILES_MATCHING REGEX "${PATTERN}")
