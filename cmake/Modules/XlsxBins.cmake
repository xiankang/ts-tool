set(XLSX_INCLUDE_DIRS
  ${CMAKE_SOURCE_DIR}/xlsx
)

macro(use_xlsx_module _target)
  target_link_libraries(${_target} xlsx)
  include_directories(${XLSX_INCLUDE_DIRS})
endmacro()
