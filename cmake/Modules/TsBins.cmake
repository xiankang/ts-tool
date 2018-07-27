set(TS_INCLUDE_DIRS
  ${CMAKE_SOURCE_DIR}/ts
)

macro(use_ts_module _target)
  target_link_libraries(${_target} ts)
  include_directories(${TS_INCLUDE_DIRS})
endmacro()
