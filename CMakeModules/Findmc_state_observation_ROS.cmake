# Copyright 2020 CNRS-AIST JRL
#
# Try to find ROS and some required ROS packages
#
# If everything if found:
# - ROSCPP_FOUND is true
# - you can link with ::ROS
#

if(NOT TARGET mc_state_observation::ROS)
  include(FindPkgConfig)
  pkg_check_modules(MC_STATE_OBSERVATION_roscpp QUIET roscpp)
  if(${MC_STATE_OBSERVATION_roscpp_FOUND})
    set(ROSCPP_FOUND True)
    set(MC_STATE_OBSERVATION_ROS_DEPENDENCIES ${mc_state_observation_ROS_FIND_COMPONENTS})
    foreach(DEP ${MC_STATE_OBSERVATION_ROS_DEPENDENCIES})
      pkg_check_modules(MC_STATE_OBSERVATION_${DEP} REQUIRED ${DEP})
      list(APPEND MC_STATE_OBSERVATION_ROS_LIBRARIES ${MC_STATE_OBSERVATION_${DEP}_LIBRARIES})
      list(APPEND MC_STATE_OBSERVATION_ROS_LIBRARY_DIRS ${MC_STATE_OBSERVATION_${DEP}_LIBRARY_DIRS})
      list(APPEND MC_STATE_OBSERVATION_ROS_INCLUDE_DIRS ${MC_STATE_OBSERVATION_${DEP}_INCLUDE_DIRS})
      foreach(FLAG ${MC_STATE_OBSERVATION_${DEP}_LDFLAGS})
        if(IS_ABSOLUTE ${FLAG})
          list(APPEND MC_STATE_OBSERVATION_ROS_FULL_LIBRARIES ${FLAG})
        endif()
      endforeach()
    endforeach()
    list(REMOVE_DUPLICATES MC_STATE_OBSERVATION_ROS_LIBRARIES)
    list(REMOVE_DUPLICATES MC_STATE_OBSERVATION_ROS_LIBRARY_DIRS)
    list(REMOVE_DUPLICATES MC_STATE_OBSERVATION_ROS_INCLUDE_DIRS)
    foreach(LIB ${MC_STATE_OBSERVATION_ROS_LIBRARIES})
      string(SUBSTRING "${LIB}" 0 1 LIB_STARTS_WITH_COLUMN)
      if(${LIB_STARTS_WITH_COLUMN} STREQUAL ":")
        string(SUBSTRING "${LIB}" 1 -1 LIB)
      endif()
      if(IS_ABSOLUTE ${LIB})
        list(APPEND MC_STATE_OBSERVATION_ROS_FULL_LIBRARIES ${LIB})
      else()
        find_library(${LIB}_FULL_PATH NAME ${LIB} HINTS ${MC_STATE_OBSERVATION_ROS_LIBRARY_DIRS})
        list(APPEND MC_STATE_OBSERVATION_ROS_FULL_LIBRARIES ${${LIB}_FULL_PATH})
      endif()
    endforeach()
    list(REMOVE_DUPLICATES MC_STATE_OBSERVATION_ROS_FULL_LIBRARIES)
    add_library(mc_state_observation::ROS INTERFACE IMPORTED)
    set_target_properties(mc_state_observation::ROS PROPERTIES
      INTERFACE_LINK_LIBRARIES "${MC_STATE_OBSERVATION_ROS_FULL_LIBRARIES}"
      INTERFACE_INCLUDE_DIRECTORIES "${MC_STATE_OBSERVATION_ROS_INCLUDE_DIRS}"
    )
    message("-- Found ROS libraries: ${MC_STATE_OBSERVATION_ROS_FULL_LIBRARIES}")
    message("-- Found ROS include directories: ${MC_STATE_OBSERVATION_ROS_INCLUDE_DIRS}")
  else()
    set(ROSCPP_FOUND False)
  endif()
endif()
