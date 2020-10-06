#[[
Sets the correct library suffix for the linker given the platform and whether we want a debug build or not.
User should set CMAKE_BUILD_TYPE [debug/...] and BUILD_SHARED_LIBS [true/false] (or BUILD_USING_SHARED_LIBS) before calling.
lsuffix set to one of [platform;build type]:
.so   [UNIX;SHARED]          d.so  [UNIX;DEBUG,SHARED]
.a    [UNIX;STATIC]          d.a   [UNIX;DEBUG,STATIC]
.lib  [WIN32;STATIC/SHARED]  d.lib [WIN32;DEBUG,STATIC/SHARED]
#]]


macro( get_debug_suffix dsuff)
    set( ${dsuff} "")
    string( TOLOWER "${CMAKE_BUILD_TYPE}" _build_type)
    if( _build_type MATCHES "debug")
        set( ${dsuff} "d")
    endif()
endmacro( get_debug_suffix)


macro( get_shared_suffix lsuffix)
    get_debug_suffix( _dsuffix)
    if(UNIX)
        set( ${lsuffix} "${_dsuffix}.so")
    elseif(WIN32)
        set( ${lsuffix} "${_dsuffix}-vc${MSVC_TOOLSET_VERSION}.dll")
    endif()
endmacro( get_shared_suffix)


macro( get_static_suffix lsuffix)
    get_debug_suffix( _dsuffix)
    if(UNIX)
        set( ${lsuffix} "${_dsuffix}.a")
    elseif(WIN32)
        set( ${lsuffix} "${_dsuffix}-vc${MSVC_TOOLSET_VERSION}.lib")
    endif()
endmacro( get_static_suffix)


# For looking for libraries
macro( get_library_suffix lsuffix)
    if(UNIX)
        if(BUILD_USING_SHARED_LIBS)
            get_shared_suffix( _lsuffix)
        else()
            get_static_suffix( _lsuffix)
        endif()
    elseif(WIN32)
        get_static_suffix( _lsuffix)
    else()
        message( FATAL_ERROR "Platform not supported!")
    endif()
    set( ${lsuffix} ${_lsuffix})
endmacro( get_library_suffix)

