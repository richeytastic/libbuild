# Since Windows doesn't have the concept of RPATH's for import libraries, we need to copy over
# all the required DLLs from all of the libraries used into the project's binary folder.
if(WIN32)
    include("cmake/Macros.cmake")
    #if(WITH_RLIB)
    #    copy_over_dll( 
    #endif()
    $<$<BOOL:WITH_RLIB>:copy_over_dll( ${rlib_ROOT_DIR})>
endif()

