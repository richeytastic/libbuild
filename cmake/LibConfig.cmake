# =============================================================================
# The XXX CMake configuration file.
#
#           ** File generated automatically, DO NOT MODIFY! ***

# To use from an external project, in your project's CMakeLists.txt add:
#   FIND_PACKAGE( XXX REQUIRED)
#   INCLUDE_DIRECTORIES( XXX ${XXX_INCLUDE_DIRS})
#   LINK_DIRECTORIES( ${XXX_LIBRARY_DIR})
#   TARGET_LINK_LIBRARIES( MY_TARGET_NAME ${XXX_LIBRARIES})
#
# This module defines the following variables:
#   - XXX_FOUND         : True if XXX is found.
#   - XXX_ROOT_DIR      : The root directory where XXX is installed.
#   - XXX_INCLUDE_DIRS  : The XXX include directories.
#   - XXX_LIBRARY_DIR   : The XXX library directory.
#   - XXX_LIBRARIES     : The XXX imported libraries to link to.
#
# =============================================================================

get_filename_component( XXX_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component( XXX_ROOT_DIR  "${XXX_CMAKE_DIR}"           PATH)

set( XXX_INCLUDE_DIRS "${XXX_ROOT_DIR}/include" CACHE PATH "The XXX include directories.")
set( XXX_LIBRARY_DIR  "${XXX_ROOT_DIR}/lib"     CACHE PATH "The XXX library directory.")

include( "${CMAKE_CURRENT_LIST_DIR}/Macros.cmake")
get_library_suffix( _lsuff)
set( _hints XXX${_lsuff} libXXX${_lsuff})
find_library( XXX_LIBRARIES NAMES ${_hints} PATHS "${XXX_LIBRARY_DIR}/static" "${XXX_LIBRARY_DIR}")
set( XXX_LIBRARIES     ${XXX_LIBRARIES}         CACHE FILE "The XXX imported libraries to link to.")

# handle QUIETLY and REQUIRED args and set XXX_FOUND to TRUE if all listed variables are TRUE
include( "${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake")
find_package_handle_standard_args( XXX "Found:\t${XXX_LIBRARIES}" XXX_LIBRARIES XXX_INCLUDE_DIRS)
