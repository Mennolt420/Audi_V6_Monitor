# Additional clean files
cmake_minimum_required(VERSION 3.16)

if("${CONFIG}" STREQUAL "" OR "${CONFIG}" STREQUAL "Debug")
  file(REMOVE_RECURSE
  "CMakeFiles\\appAudi_V6_Monitor_autogen.dir\\AutogenUsed.txt"
  "CMakeFiles\\appAudi_V6_Monitor_autogen.dir\\ParseCache.txt"
  "appAudi_V6_Monitor_autogen"
  )
endif()
