include("$ENV{DEV_PARENT_DIR}/libbuild/cmake/LinkTargets.cmake")
include("$ENV{DEV_PARENT_DIR}/libbuild/cmake/Macros.cmake")

# Since Windows doesn't have the concept of RPATH's for import libraries, we need to copy over
# all the required DLLs from all of the libraries used into the project's binary folder.
if(WIN32)
    if(WITH_RLIB)
        copy_over_dll( rlib)
    endif()
    if(WITH_RIMG)
        copy_over_dll( rimg)
    endif()
    if(WITH_RNONRIGID)
        copy_over_dll( rNonRigid)
    endif()
    if(WITH_R3D)
        copy_over_dll( r3d)
    endif()
    if(WITH_R3DIO)
        copy_over_dll( r3dio)
    endif()
    if(WITH_R3DVIS)
        copy_over_dll( r3dvis)
    endif()
    if(WITH_LEARNING)
        copy_over_dll( rLearning)
    endif()
    if(WITH_RPASCALVOC)
        copy_over_dll( rPascalVOC)
    endif()
    if(WITH_QTOOLS)
        copy_over_dll( QTools)
    endif()
    if(WITH_FACETOOLS)
        copy_over_dll( FaceTools)
    endif()
    if(WITH_TESTUTILS)
        copy_over_dll( TestUtils)
    endif()

    set( tdest "${${PROJECT_NAME}_BINARY_DIR}/bin")

    if(WITH_BOOST)
        # The suffix for the boost dlls
        set( _arch "-x64-")
        set( bsuff "-vc${MSVC_TOOLSET_VERSION}-mt${_arch}${Boost_LIB_VERSION}.dll")
        if(IS_DEBUG)
            set( bsuff "-vc${MSVC_TOOLSET_VERSION}-mt-gd${_arch}${Boost_LIB_VERSION}.dll")
        endif()
        file( COPY "${BOOST_LIBRARYDIR}/boost_system${bsuff}"     DESTINATION "${tdest}") 
        file( COPY "${BOOST_LIBRARYDIR}/boost_filesystem${bsuff}" DESTINATION "${tdest}") 
        file( COPY "${BOOST_LIBRARYDIR}/boost_thread${bsuff}"     DESTINATION "${tdest}")
        file( COPY "${BOOST_LIBRARYDIR}/boost_regex${bsuff}"      DESTINATION "${tdest}")
        file( COPY "${BOOST_LIBRARYDIR}/boost_date_time${bsuff}"  DESTINATION "${tdest}")
        file( COPY "${BOOST_LIBRARYDIR}/boost_chrono${bsuff}"     DESTINATION "${tdest}")
    endif()

    if(WITH_OPENCV)
        set( _ocv "${OpenCV_VERSION_MAJOR}${OpenCV_VERSION_MINOR}${OpenCV_VERSION_PATCH}")
        set( ocvs "${_ocv}.dll")
        if(IS_DEBUG)
            set( ocvs "${_ocv}d.dll")
        endif()
        file( COPY "${OpenCV_BIN}/opencv_world${ocvs}"              DESTINATION "${tdest}")
        #file( COPY "${OpenCV_BIN}/opencv_surface_matching${ocvs}"   DESTINATION "${tdest}")

        # Copy in TBB DLL - OpenCV apparently doesn't reference it directly anywhere in its CMake
        # configuration files! Not really sure how it's managing to link it in, but it is
        # (I'm sure I've missed something obvious that will allow me to make this less version specific).
        #set(TBBbin "${LIB_PRE_REQS}/tbb2017_20170604oss/bin/intel64/vc${MSVC_TOOLSET_VERSION}")
        #if(IS_DEBUG)
        #    file( COPY "${TBBbin}/tbb_debug.dll" DESTINATION "${tdest}")
        #else()
        #    file( COPY "${TBBbin}/tbb.dll" DESTINATION "${tdest}")
        #endif()

	    #set( _open_blas_bin "${LIB_PRE_REQS}/OpenBLAS-0.3.6-x64/bin")
        #file( COPY "${_open_blas_bin}/libopenblas.dll" DESTINATION "${tdest}")
        #file( COPY "${_open_blas_bin}/libgcc_s_seh-1.dll" DESTINATION "${tdest}")
        #file( COPY "${_open_blas_bin}/libgfortran-3.dll" DESTINATION "${tdest}")
        #file( COPY "${_open_blas_bin}/libquadmath-0.dll" DESTINATION "${tdest}")
        #file( COPY "${_open_blas_bin}/libwinpthread-1.dll" DESTINATION "${tdest}")
    endif()

    if(WITH_VTK)
        set( vtks "-9.0.dll")
        #file( COPY "${VTK_BIN}/vtkAlgLib${vtks}"                      DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonMisc${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonComputationalGeometry${vtks}" DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonColor${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonCore${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonDataModel${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonExecutionModel${vtks}"        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonMath${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonSystem${vtks}"                DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonTransforms${vtks}"            DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkDicomParser${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkDoubleConversion${vtks}"            DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkExPat${vtks}"                       DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersCore${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersExtraction${vtks}"           DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersGeneral${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersGeometry${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersHybrid${vtks}"               DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersModeling${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersSources${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersStatistics${vtks}"           DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFreeType${vtks}"                    DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkGL2PS${vtks}"                       DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkGLEW${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkGUISupportQt${vtks}"                DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingColor${vtks}"                DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingCore${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingGeneral${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingFourier${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingHybrid${vtks}"               DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingSources${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkInteractionStyle${vtks}"            DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkInteractionWidgets${vtks}"          DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOCore${vtks}"                      DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOGeometry${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOImage${vtks}"                     DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOLegacy${vtks}"                    DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOXML${vtks}"                       DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOXMLParser${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkJPEG${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtklz4${vtks}"                         DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtklzma${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkloguru${vtks}"                      DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkMetaIO${vtks}"                      DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkParallelCore${vtks}"                DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkParallelDIY${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkPNG${vtks}"                         DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkPugiXML${vtks}"                     DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingAnnotation${vtks}"         DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingCore${vtks}"               DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingFreeType${vtks}"           DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingGL2PSOpenGL2${vtks}"       DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingLabel${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingOpenGL2${vtks}"            DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingUI${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingVolume${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkSys${vtks}"                         DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkTIFF${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkZLIB${vtks}"                        DESTINATION "${tdest}")
    endif()

    if(WITH_CGAL)
        get_filename_component( GMP_LIBRARY_DIR "${GMP_LIBRARIES}" PATH)
        set( GMP_DLL  "${GMP_LIBRARY_DIR}/libgmp-10.dll")
        set( MPFR_DLL "${GMP_LIBRARY_DIR}/libmpfr-4.dll")
        file( COPY "${GMP_DLL}"  DESTINATION "${tdest}")
        file( COPY "${MPFR_DLL}" DESTINATION "${tdest}")
        set( cgsuff "-vc${MSVC_TOOLSET_VERSION}-mt-4.10.dll")
        if(IS_DEBUG)
            set( cgsuff "-vc${MSVC_TOOLSET_VERSION}-mt-gd-4.10.dll")
        endif()
        file( COPY "${CGAL_BIN}/CGAL${cgsuff}" DESTINATION "${tdest}")
    endif()

    if(WITH_ASSIMP)
        file( COPY "${ASSIMP_DIR}/../../../bin/assimp-vc${MSVC_TOOLSET_VERSION}-mt.dll" DESTINATION "${tdest}")
    endif()

    if(WITH_QUAZIP)
        file( COPY "${QuaZip_ROOT_DIR}/bin/QuaZip-vc${MSVC_TOOLSET_VERSION}.dll" DESTINATION "${tdest}")
    endif()

    if(WITH_ZLIB)
        file( COPY "${ZLIB_LIBRARY}" DESTINATION "${tdest}")
    endif()

    if(WITH_LUA)
        file( COPY "${LUA_LIBRARY}" DESTINATION "${tdest}")
    endif()

    # Note that CPD under Windows compiles to a static library so no DLL to copy over.

    if(WITH_QT)
        set( QT_BIN "${Qt5_DIR}/../../../bin")
        file( COPY "${QT_BIN}/Qt5Core${_dsuffix}.dll"    DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5Charts${_dsuffix}.dll"  DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5GUI${_dsuffix}.dll"     DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5Widgets${_dsuffix}.dll" DESTINATION "${tdest}")
        #file( COPY "${QT_BIN}/Qt5SQL${_dsuffix}.dll"     DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5Svg${_dsuffix}.dll"     DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5Network${_dsuffix}.dll" DESTINATION "${tdest}")
        # Ensure that the platform plugin qwindows.dll is installed into the "platforms" folder.
        file( COPY "${QT_BIN}/../plugins/platforms/qwindows${_dsuffix}.dll" DESTINATION "${tdest}/platforms")
        # Need imageformats and iconengines for SVG icons too.
        file( COPY "${QT_BIN}/../plugins/iconengines/qsvgicon${_dsuffix}.dll" DESTINATION "${tdest}/iconengines")
        file( COPY "${QT_BIN}/../plugins/imageformats/qsvg${_dsuffix}.dll" DESTINATION "${tdest}/imageformats")
        file( COPY "${QT_BIN}/../plugins/imageformats/qico${_dsuffix}.dll" DESTINATION "${tdest}/imageformats")

        set( _openssl "$ENV{programfiles}/OpenSSL-Win64/bin")
        file( COPY "${_openssl}/libcrypto-1_1-x64.dll" DESTINATION "${tdest}")
        file( COPY "${_openssl}/libssl-1_1-x64.dll" DESTINATION "${tdest}")
    endif()

    # Install Windows specific gubbins
    # DLL redirection to ensure that DLLs in the application directory are loaded
    file( WRITE "${PROJECT_NAME}.exe.local" "Exists to ensure Windows loads DLLs from this directory.")
    file( COPY "${PROJECT_NAME}.exe.local" DESTINATION "${tdest}")

    # Copy in the MSVC runtime dlls
    if(DEFINED ENV{VCToolsRedistDir})
        set( MSVC_REDIST "$ENV{VCToolsRedistDir}")
    else()
        set( MSVC_REDIST "$ENV{VCInstallDir}/redist")
    endif()

    if( IS_DEBUG)
        set( C_DLL_DIR "${MSVC_REDIST}/Debug_NonRedist/$ENV{PLATFORM}/Microsoft.VC${MSVC_TOOLSET_VERSION}.DebugCRT")
    else()
        set( C_DLL_DIR "${MSVC_REDIST}/$ENV{PLATFORM}/Microsoft.VC${MSVC_TOOLSET_VERSION}.CRT")
    endif()

    file( GLOB MSVC_REDIST "${C_DLL_DIR}/*${_dsuffix}.dll")
    file( COPY ${MSVC_REDIST} DESTINATION "${tdest}" FILE_PERMISSIONS OWNER_READ OWNER_WRITE GROUP_WRITE GROUP_READ WORLD_READ)
    file( GLOB UCRT_DLLS "$ENV{WindowsSDKDir}/Redist/$ENV{ucrtversion}/ucrt/DLLs/$ENV{PLATFORM}/*.dll")
    file( COPY ${UCRT_DLLS} DESTINATION "${tdest}" FILE_PERMISSIONS OWNER_READ OWNER_WRITE GROUP_WRITE GROUP_READ WORLD_READ)
endif()
