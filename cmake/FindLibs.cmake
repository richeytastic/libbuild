set( CMAKE_COLOR_MAKEFILE TRUE)
set( CMAKE_VERBOSE_MAKEFILE FALSE)

if(UNIX)
    set( CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wno-deprecated -Wno-deprecated-declarations -Wno-error=unknown-pragmas")
endif()
set(CMAKE_CXX_STANDARD 17)

set( LIB_PRE_REQS "$ENV{INSTALL_PARENT_DIR}" CACHE PATH
    "Where library prerequisites are installed (if not in the standard system library locations).")
set( CMAKE_LIBRARY_PATH "${LIB_PRE_REQS}")
set( CMAKE_PREFIX_PATH "${LIB_PRE_REQS}")

set( BUILD_SHARED_LIBS TRUE CACHE BOOL "Dynamic Linking?" FORCE)
set( CMAKE_POSITION_INDEPENDENT_CODE TRUE)
set( BUILD_USING_SHARED_LIBS TRUE)

# Set IS_DEBUG and _dsuffix
set( IS_DEBUG FALSE)
set( _dsuffix "")
string( TOLOWER "${CMAKE_BUILD_TYPE}" CMAKE_BUILD_TYPE_LOWER)
if( CMAKE_BUILD_TYPE_LOWER STREQUAL "debug")
    set( IS_DEBUG TRUE)
    set(_dsuffix "d")
endif()
set( CMAKE_DEBUG_POSTFIX ${_dsuffix})


# Add definitions for Windows 7 build target (SDK 8.1 support Win 7 and up)
if(WIN32)
    add_definitions( -DWINVER=0x0601)
    add_definitions( -D_WIN32_WINNT=0x0601)
    set( CMAKE_SYSTEM_VERSION 8.1)
endif()
message( STATUS "OS Name build target:    ${CMAKE_SYSTEM_NAME}")
message( STATUS "OS Version build target: ${CMAKE_SYSTEM_VERSION}")

set( _cmake_dir "lib/cmake")


if(WITH_TESTUTILS)
    set( TestUtils_DIR "${LIB_PRE_REQS}/TestUtils/${_cmake_dir}" CACHE PATH "Location of TestUtilsConfig.cmake")
    find_package( TestUtils REQUIRED)
    include_directories( ${TestUtils_INCLUDE_DIRS})
    link_directories( ${TestUtils_LIBRARY_DIR})
    message( STATUS "TestUtils:         ${TestUtils_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${TestUtils_LIBRARY_DIR})
    set(WITH_FACETOOLS TRUE)
endif()


if(WITH_FACETOOLS)
    set( FaceTools_DIR "${LIB_PRE_REQS}/FaceTools/${_cmake_dir}" CACHE PATH "Location of FaceToolsConfig.cmake")
    find_package( FaceTools REQUIRED)
    include_directories( ${FaceTools_INCLUDE_DIRS})
    link_directories( ${FaceTools_LIBRARY_DIR})
    message( STATUS "FaceTools:         ${FaceTools_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${FaceTools_LIBRARY_DIR})
    set(WITH_R3DIO TRUE)
    set(WITH_QTOOLS TRUE)
    set(WITH_RNONRIGID TRUE)
    set(WITH_SOL TRUE)
endif()


if(WITH_QTOOLS)
    set( QTools_DIR "${LIB_PRE_REQS}/QTools/${_cmake_dir}" CACHE PATH "Location of QToolsConfig.cmake")
    find_package( QTools REQUIRED)
    include_directories( ${QTools_INCLUDE_DIRS})
    link_directories( ${QTools_LIBRARY_DIR})
    message( STATUS "QTools:            ${QTools_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${QTools_LIBRARY_DIR})

    set( AppImageToolName "appimagetool-x86_64.AppImage")
    set( AppImageToolPath "${QTools_BIN_DIR}/${AppImageToolName}")
    if ( UNIX)
        if (NOT EXISTS "${AppImageToolPath}")
            message( FATAL_ERROR "Can't find ${AppImageToolName}!")
        endif()
        message( STATUS "appimagetool:      ${AppImageToolPath}")
    endif()

    set( updateTool "updateTool")
    if (WIN32)
        set( updateTool "${updateTool}.exe")
    endif()
    set( updateToolPath "${QTools_BIN_DIR}/${updateTool}")
    if ( NOT EXISTS "${updateToolPath}")
        message( FATAL_ERROR "Can't find ${updateTool}!")
    endif()
    message( STATUS "updateTool:        ${updateToolPath}")

    set(WITH_R3DVIS TRUE)
    set(WITH_QUAZIP TRUE)
    set(WITH_QT TRUE)
endif()


if(WITH_R3DVIS)
    set( r3dvis_DIR "${LIB_PRE_REQS}/r3dvis/${_cmake_dir}" CACHE PATH "Location of r3dvisConfig.cmake")
    find_package( r3dvis REQUIRED)
    include_directories( ${r3dvis_INCLUDE_DIRS})
    link_directories( ${r3dvis_LIBRARY_DIR})
    message( STATUS "r3dvis:            ${r3dvis_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${r3dvis_LIBRARY_DIR})
    set(WITH_RIMG TRUE)
    set(WITH_R3D TRUE)
    set(WITH_VTK TRUE)
endif()


if(WITH_RPASCALVOC)
    set( rPascalVOC_DIR "${LIB_PRE_REQS}/rPascalVOC/${_cmake_dir}" CACHE PATH "Location of rPascalVOCConfig.cmake")
    find_package( rPascalVOC REQUIRED)
    include_directories( ${rPascalVOC_INCLUDE_DIRS})
    link_directories( ${rPascalVOC_LIBRARY_DIR})
    message( STATUS "rPascalVOC:        ${rPascalVOC_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${rPascalVOC_LIBRARY_DIR})
    set(WITH_TINYXML TRUE)
    set(WITH_RLEARNING TRUE)
endif()


if(WITH_RLEARNING)
    set( rLearning_DIR "${LIB_PRE_REQS}/rLearning/${_cmake_dir}" CACHE PATH "Location of rLearningConfig.cmake")
    find_package( rLearning REQUIRED)
    include_directories( ${rLearning_INCLUDE_DIRS})
    link_directories( ${rLearning_LIBRARY_DIR})
    message( STATUS "rLearning:         ${rLearning_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${rLearning_LIBRARY_DIR})
    set(WITH_RIMG TRUE)
endif()


if(WITH_R3DIO)
    set( r3dio_DIR "${LIB_PRE_REQS}/r3dio/${_cmake_dir}" CACHE PATH "Location of r3dioConfig.cmake")
    find_package( r3dio REQUIRED)
    include_directories( ${r3dio_INCLUDE_DIRS})
    link_directories( ${r3dio_LIBRARY_DIR})
    message( STATUS "r3dio:             ${r3dio_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${r3dio_LIBRARY_DIR})
    set(WITH_RIMG TRUE)
    set(WITH_R3D TRUE)
    set(WITH_ASSIMP TRUE)
endif()


if(WITH_RIMG)
    set( rimg_DIR "${LIB_PRE_REQS}/rimg/${_cmake_dir}" CACHE PATH "Location of rimgConfig.cmake")
    find_package( rimg REQUIRED)
    include_directories( ${rimg_INCLUDE_DIRS})
    link_directories( ${rimg_LIBRARY_DIR})
    message( STATUS "rimg:              ${rimg_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${rimg_LIBRARY_DIR})
    set(WITH_RLIB TRUE)
    set(WITH_ZLIB TRUE)
    set(WITH_OPENCV TRUE)
endif()


# r3dio::U3DExporter requires IDTFConverter
if(WITH_IDTF_CONVERTER)
    set( idtfconv_exe "$ENV{IDTF_CONVERTER_EXE}")   # Set location of IDTFConverter from env var if set
    if( "${idtfconv_exe}" STREQUAL "")              # If not set, try to guess based on platform
        set( idtfconv_exe "${LIB_PRE_REQS}/u3dIntel/bin/IDTFConverter")
    endif()

    if ( NOT EXISTS ${idtfconv_exe})
        set( idtfconv_exe "r3dio_IDTF_CONVERTER-NOTFOUND")
    endif()

    set( r3dio_IDTF_CONVERTER ${idtfconv_exe} CACHE FILEPATH "Location of the IDTFConverter executable.")
    if ( EXISTS ${r3dio_IDTF_CONVERTER})
        message( STATUS "[r3dio] r3dio::U3DExporter using IDTFConverter at ${rModelIO_IDTF_CONVERTER}")
        add_definitions( -DIDTF_CONVERTER=\"${r3dio_IDTF_CONVERTER}\")
    else()
        message( STATUS "[r3dio] IDTFConverter not found; r3dio::U3DExporter disabled.")
    endif()
endif()


if(WITH_R3D)
    set( r3d_DIR "${LIB_PRE_REQS}/r3d/${_cmake_dir}" CACHE PATH "Location of r3dConfig.cmake")
    find_package( r3d REQUIRED)
    include_directories( ${r3d_INCLUDE_DIRS})
    link_directories( ${r3d_LIBRARY_DIR})
    message( STATUS "r3d:               ${r3d_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${r3d_LIBRARY_DIR})
    set(WITH_BOOST TRUE)
    set(WITH_EIGEN TRUE)
    set(WITH_OPENCV TRUE)
    set(WITH_NANOFLANN TRUE)
endif()


if(WITH_RLIB)
    set( rlib_DIR "${LIB_PRE_REQS}/rlib/${_cmake_dir}" CACHE PATH "Location of rlibConfig.cmake")
    find_package( rlib REQUIRED)
    include_directories( ${rlib_INCLUDE_DIRS})
    link_directories( ${rlib_LIBRARY_DIR})
    message( STATUS "rlib:              ${rlib_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${rlib_LIBRARY_DIR})
    set(WITH_BOOST TRUE)
    set(WITH_EIGEN TRUE)
endif()


if(WITH_RNONRIGID)
    set( rNonRigid_DIR "${LIB_PRE_REQS}/rNonRigid/${_cmake_dir}" CACHE PATH "Location of rNonRigidConfig.cmake")
    find_package( rNonRigid REQUIRED)
    include_directories( ${rNonRigid_INCLUDE_DIRS})
    link_directories( ${rNonRigid_LIBRARY_DIR})
    message( STATUS "rNonRigid:         ${rNonRigid_LIBRARIES}")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${rNonRigid_LIBRARY_DIR})
    set(WITH_EIGEN TRUE)
    set(WITH_NANOFLANN TRUE)
endif()


if(WITH_EIGEN) # Eigen3
    set( Eigen3_DIR "${LIB_PRE_REQS}/eigen3/share/eigen3/cmake" CACHE PATH "Location of Eigen3Config.cmake")
    find_package( Eigen3 3.4 REQUIRED)
    message( STATUS "eigen3:            ${EIGEN3_INCLUDE_DIR}")
    #set( Eigen3_INCLUDE_DIR "${LIB_PRE_REQS}/eigen3/include/eigen3" CACHE PATH "Include directory of Eigen3")
    #if(EIGEN3_FOUND)
    #    include_directories( ${EIGEN3_INCLUDE_DIR})
    #else()
    #    message( FATAL_ERROR "Can't find Eigen3!")
    #endif()
endif()


if(WITH_NANOFLANN)
    set( nanoflann_DIR "${LIB_PRE_REQS}/nanoflann/lib/cmake/nanoflann" CACHE PATH "Location of nanoflannConfig.cmake")
    find_package( nanoflann REQUIRED)
endif()


if(WITH_ZLIB)
    # Uses standard CMake module FindZLIB.cmake but required ZLIB_ROOT
    # to be set to the locally installed version to prevent any available
    # system version from being detected instead. Note that all other
    # external libraries depending on zlib should use this same locally
    # installed version to keep all dynamic dependencies aligned to the
    # same version and prevent any weird runtime issues.
    set(ZLIB_ROOT "${LIB_PRE_REQS}/zlib" CACHE PATH "Location of zlib")
    find_package( ZLIB REQUIRED)
    include_directories( ${ZLIB_INCLUDE_DIRS})
    message( STATUS "zlib:              ${ZLIB_LIBRARIES}")
endif()


if(WITH_QUAZIP)     # QuaZIP
    set(WITH_ZLIB TRUE)
    set(WITH_QT TRUE)
    set( QuaZip-Qt5_DIR "${LIB_PRE_REQS}/quazip-1.3/lib/cmake/QuaZip-Qt5-1.3" CACHE PATH "Location of QuaZip (Qt/C++ wrapper for Minizip)")
    find_package( QuaZip-Qt5 REQUIRED)
endif()


if(WITH_ASSIMP)     # AssImp
    set(WITH_ZLIB TRUE)
    set(ASSIMP_DIR "${LIB_PRE_REQS}/AssImp-5.2.5/lib/cmake/assimp-5.2" CACHE PATH "Location of assimpConfig.cmake")
    find_package( assimp REQUIRED)
    #include_directories( ${ASSIMP_INCLUDE_DIRS})
endif()


# Lua with sol2 for C++ communication with data loaded via dynamically executed Lua scripts
if(WITH_SOL)
    set( sol2_DIR "${LIB_PRE_REQS}/sol/lib/cmake/sol2" CACHE PATH "Location of sol2-config.cmake)")
    find_package( sol2 REQUIRED)
    include_directories( "${SOL2_INCLUDE_DIRS}")
    message( STATUS "sol2:              ${SOL2_INCLUDE_DIRS}")
    set( WITH_LUA TRUE)
endif()


if(WITH_LUA)
    set( LUA_DIR "${LIB_PRE_REQS}/lua5" CACHE PATH "Location of Lua")
    set( LUA_LIBRARY_DIR  "${LUA_DIR}/lib")
    set( LUA_INCLUDE_DIRS "${LUA_DIR}/include")
    set( LUA_LIBRARY "${LUA_LIBRARY_DIR}/${CMAKE_STATIC_LIBRARY_PREFIX}lua${CMAKE_STATIC_LIBRARY_SUFFIX}")
    if(NOT EXISTS ${LUA_LIBRARY})
        message( FATAL_ERROR "Can't find Lua library at ${LUA_LIBRARY}!")
    endif()
    if(UNIX)
        set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${LUA_LIBRARY_DIR})
    endif()
    include_directories( ${LUA_INCLUDE_DIRS})
    message( STATUS "Lua:               ${LUA_LIBRARY}")
endif()


if(WITH_DLIB)   # dlib
    set( dlib_ROOT "${LIB_PRE_REQS}/dlib" CACHE PATH "Location of dlib")
    set( dlib_DIR "${dlib_ROOT}/${CMAKE_BUILD_TYPE_LOWER}/lib/cmake/dlib" CACHE PATH "Location of dlibConfig.cmake")
    find_package( dlib REQUIRED)
    get_filename_component( dlib_LIBRARY_DIR "${dlib_DIR}/../.." REALPATH)
    set( dlib_LIBRARY "${dlib_LIBRARY_DIR}/dlib.lib")
    if(UNIX)
        set( dlib_LIBRARY "${dlib_LIBRARY_DIR}/libdlib.so.${dlib_VERSION}")
        set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${dlib_LIBRARY_DIR})
    endif()
    if(NOT EXISTS ${dlib_LIBRARY})
        message( FATAL_ERROR "Can't find dlib library at ${dlib_LIBRARY}!")
    endif()
    include_directories( ${dlib_INCLUDE_DIRS})
    message( STATUS "dlib:              ${dlib_LIBRARY}")
endif()


#[[
if(WITH_LIBLAS)     # libLAS
    set( LibLAS_DIR "${LIB_PRE_REQS}/libLAS-1.7.0" CACHE PATH "Location of LibLASConfig.cmake")
    find_package( LibLAS REQUIRED)
    include_directories( ${LibLAS_INCLUDE_DIR})
endif()
#]]


if(WITH_TINYXML)    # tinyxml
    set( tinyxml_DIR "${LIB_PRE_REQS}/tinyxml/cmake" CACHE PATH "Location of tinyxmlConfig.cmake")
    find_package( tinyxml REQUIRED)
    include_directories( ${tinyxml_INCLUDE_DIR})
    link_directories( ${tinyxml_LIBRARY_DIR})
endif()


if(WITH_VTK)    # VTK
    set( WITH_ZLIB TRUE)
    set( WITH_EIGEN TRUE)
    set( VTK_VERSION "9.2")
    set( VTK_BASE "${LIB_PRE_REQS}/VTK-${VTK_VERSION}.6")
    set( VTK_DIR "${VTK_BASE}/lib/cmake/vtk-${VTK_VERSION}" CACHE PATH "Location of vtk-config.cmake")

    if(UNIX)
        set( VTK_LIBRARY_DIR "${VTK_DIR}/../.." CACHE PATH "Location of VTK shared libraries")
    elseif(WIN32)
        set( VTK_BIN "${VTK_DIR}/../../../bin" CACHE PATH "Location of VTK shared libraries")
    endif()

    find_package( VTK ${VTK_VERSION} REQUIRED)
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${VTK_LIBRARY_DIR})
    message( STATUS "VTK:               ${VTK_DIR}")
endif()


if(WITH_QT)     # Qt5
    set( Qt5_DIR "$ENV{QT5}/lib/cmake/Qt5" CACHE PATH "Location of Qt5Config.cmake")
    if(NOT IS_DIRECTORY ${Qt5_DIR})
        message( FATAL_ERROR "Can't find Qt5! Set environment variable QT5 to the location of the library!")
    endif()
    get_filename_component( Qt5_TOOLS "$ENV{QT5}/../../Tools" REALPATH)
    set( QT_INSTALLER_FRAMEWORK "${Qt5_TOOLS}/QtInstallerFramework/4.5/bin")
    set( QT_INF_BINARY_CREATOR "${QT_INSTALLER_FRAMEWORK}/binarycreator${CMAKE_EXECUTABLE_SUFFIX}")
    set( QT_INF_REPO_GEN "${QT_INSTALLER_FRAMEWORK}/repogen${CMAKE_EXECUTABLE_SUFFIX}")

    find_package( Qt5 CONFIG REQUIRED Core Widgets Charts Network Sql Svg)
    include_directories( ${Qt5Core_INCLUDE_DIRS})
    include_directories( ${Qt5Widgets_INCLUDE_DIRS})
    include_directories( ${Qt5Charts_INCLUDE_DIRS})
    include_directories( ${Qt5Network_INCLUDE_DIRS})
    include_directories( ${Qt5Sql_INCLUDE_DIRS})
    include_directories( ${Qt5Svg_INCLUDE_DIRS})
    set( QT_LIBRARIES Qt5::Core Qt5::Widgets Qt5::Charts Qt5::Network Qt5::Sql Qt5::Svg)

    set( QT_LIB_DIR "${Qt5_DIR}/../..")
    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${QT_LIB_DIR})

    message( STATUS "Qt5:               ${Qt5_DIR}")

    # Define the location of the Qt Tools version of OpenSSL.
    set( QT_SSL_LIB_DIR "${Qt5_TOOLS}/OpenSSL/binary/lib")
    set( OPENSSL_LIB_CRYPTO "${QT_SSL_LIB_DIR}/libcrypto.so.1.1")
    set( OPENSSL_LIB_SSL "${QT_SSL_LIB_DIR}/libssl.so.1.1")
    if(WIN32)
        set( QT_SSL_LIB_DIR "${Qt5_TOOLS}/OpenSSL/Win_x64/bin")
        set( OPENSSL_LIB_CRYPTO "${QT_SSL_LIB_DIR}/libcrypto-1_1-x64.dll")
        set( OPENSSL_LIB_SSL "${QT_SSL_LIB_DIR}/libssl-1_1-x64.dll")
    endif()

    if ( EXISTS "${OPENSSL_LIB_CRYPTO}" AND EXISTS "${OPENSSL_LIB_SSL}")
        message( STATUS "Qt5 OpenSSL:       ${QT_SSL_LIB_DIR}")
    else()
        message( FATAL_ERROR "Ensure you have installed the Qt provided version of the OpenSSL binaries!")
    endif()
endif()


if(WITH_OPENCV) # OpenCV
    set( WITH_ZLIB TRUE)
    set( OpenCV_BASE "${LIB_PRE_REQS}/opencv-4.7.0")
    set( OpenCV_DIR "${OpenCV_BASE}" CACHE PATH "Location of OpenCVConfig.cmake")
    find_package( OpenCV 4.7 REQUIRED)
    if(WIN32)
        set( OpenCV_MSVC "${OpenCV_DIR}/x64/vc16")
        set( OpenCV_BIN "${OpenCV_MSVC}/bin" CACHE PATH "Location of OpenCV binary (DLL) files")
    endif()
    include_directories( ${OpenCV_INCLUDE_DIRS})
    message( STATUS "OpenCV:            ${OpenCV_DIR}")
endif()


if(WITH_BOOST)  # Boost
    set( _boost_ver_major "1")
    set( _boost_ver_minor "80")
    set( _boost_ver_patch "0")
    set( _boost_ver_str "${_boost_ver_major}_${_boost_ver_minor}_${_boost_ver_patch}")
    set( BOOST_ROOT "${LIB_PRE_REQS}/boost/boost_${_boost_ver_str}" CACHE PATH "Location of boost")
    set( BOOST_LIBRARYDIR "${BOOST_ROOT}/lib")

    # Needed for 1.73 to avoid warning that practice of declaring Bind placeholders in global namespace is deprecated
    add_definitions( -DBOOST_BIND_GLOBAL_PLACEHOLDERS=1)

    if(WIN32)
        add_definitions( ${Boost_LIB_DIAGNOSTIC_DEFINITIONS})   # Info about Boost's auto linking
    endif()

    set( Boost_NO_SYSTEM_PATHS ON)  # Don't search for Boost in system directories
    set( Boost_USE_STATIC_LIBS OFF CACHE BOOL "use static Boost libraries")
    set( Boost_USE_MULTITHREADED ON)
    set( Boost_USE_STATIC_RUNTIME OFF)
    add_definitions( -DBOOST_ALL_NO_LIB)    # Disable autolinking
    add_definitions( -DBOOST_ALL_DYN_LINK)  # Force dynamic linking (probably don't need this)
    add_definitions( -DBOOST_SYSTEM_NO_DEPRECATED)

    find_package( Boost "${_boost_ver_major}.${_boost_ver_minor}"
        REQUIRED COMPONENTS regex random thread filesystem system program_options)

    include_directories( ${Boost_INCLUDE_DIRS})
    set( Boost_LIBRARIES Boost::regex Boost::random Boost::thread Boost::filesystem Boost::system Boost::program_options)

    set( CMAKE_INSTALL_RPATH ${CMAKE_INSTALL_RPATH} ${BOOST_LIBRARYDIR})
endif()


if(WITH_CGAL)   # CGAL
    set( CGAL_DIR "${LIB_PRE_REQS}/CGAL/${CMAKE_BUILD_TYPE_LOWER}/lib/CGAL" CACHE PATH "Location of CGALConfig.cmake")
    set( CGAL_BIN "${CGAL_DIR}/../../bin" CACHE PATH "Location of CGAL binary (dll) files")
    find_package( CGAL COMPONENTS Core)
    set( CGAL_DONT_OVERRIDE_CMAKE_FLAGS TRUE CACHE BOOL "Prevent CGAL from overwritting CMake flags.")
    include( ${CGAL_USE_FILE})
endif()


#[[
if(WITH_VCG)    # VCGLib (Visual and Computer Graphics Library)
    set( VCG_DIR "${LIB_PRE_REQS}/vcglib" CACHE PATH "Location of VCG header only library.")
    include_directories( ${VCG_DIR})    # Header only library
endif()
#]]


if(WITH_CPD) # Coherent Point Drift
    set( Cpd_ROOT "${LIB_PRE_REQS}/cpd" CACHE PATH "Location of CPD (Coherent Point Drift)")
    set( Cpd_DIR "${Cpd_ROOT}/${CMAKE_BUILD_TYPE_LOWER}/lib/cmake/cpd" CACHE PATH "Location of cpd-config.cmake")
    find_package( Cpd REQUIRED)
    set( Cpd_INCLUDE_DIRS "${Cpd_DIR}/../../../include")
    include_directories( ${Cpd_INCLUDE_DIRS})
    message( STATUS "Cpd:               ${Cpd_DIR}")
endif()
