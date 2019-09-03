# =============================================================================
# The <XXX> CMake configuration file.
#
#           ** File generated automatically, DO NOT MODIFY! ***

# To use from an external project, in your project's CMakeLists.txt add:
#   FIND_PACKAGE( <XXX> REQUIRED)
#   INCLUDE_DIRECTORIES( <XXX> ${<XXX>_INCLUDE_DIRS})
#   LINK_DIRECTORIES( ${<XXX>_LIBRARY_DIR})
#   TARGET_LINK_LIBRARIES( MY_TARGET_NAME ${<XXX>_LIBRARIES})
#
# This module defines the following variables:
#   - <XXX>_FOUND         : True if <XXX> is found.
#   - <XXX>_ROOT_DIR      : The root directory where <XXX> is installed.
#   - <XXX>_INCLUDE_DIRS  : The <XXX> include directories.
#   - <XXX>_LIBRARY_DIR   : The <XXX> library directory.
#   - <XXX>_LIBRARIES     : The <XXX> imported libraries to link to.
#
# =============================================================================

get_filename_component( <XXX>_CMAKE_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)
get_filename_component( <XXX>_ROOT_DIR  "${<XXX>_CMAKE_DIR}"           PATH)

set( <XXX>_INCLUDE_DIRS "${<XXX>_ROOT_DIR}/../include" CACHE PATH "The <XXX> include directories.")
set( <XXX>_LIBRARY_DIR  "${<XXX>_ROOT_DIR}"            CACHE PATH "The <XXX> library directory.")

include( "${CMAKE_CURRENT_LIST_DIR}/Macros.cmake")
get_library_suffix( _lsuff)
set( _hints <XXX>${_lsuff} lib<XXX>${_lsuff})
find_library( <XXX>_LIBRARIES NAMES ${_hints} PATHS "${<XXX>_LIBRARY_DIR}/static" "${<XXX>_LIBRARY_DIR}")
set( <XXX>_LIBRARIES     ${<XXX>_LIBRARIES}         CACHE FILEPATH "The <XXX> imported libraries to link to.")

# handle QUIETLY and REQUIRED args and set <XXX>_FOUND to TRUE if all listed variables are TRUE
include( "${CMAKE_ROOT}/Modules/FindPackageHandleStandardArgs.cmake")
find_package_handle_standard_args( <XXX> <XXX>_FOUND <XXX>_LIBRARIES <XXX>_INCLUDE_DIRS)
