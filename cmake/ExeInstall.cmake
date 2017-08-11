# Since Windows doesn't have the concept of RPATH's for import libraries, we need to copy over
# all the required DLLs from all of the libraries used into the project's binary folder.
include("$ENV{DEV_PARENT_DIR}/libbuild/cmake/Macros.cmake")
if(WIN32)
    if(WITH_RLIB)
        copy_over_dll( rlib)
    endif()
    if(WITH_RFEATURES)
        copy_over_dll( rFeatures)
    endif()
    if(WITH_LEARNING)
        copy_over_dll( rLearning)
    endif()
    if(WITH_RPASCALVOC)
        copy_over_dll( rPascalVOC)
    endif()
    if(WITH_RMODELIO)
        copy_over_dll( rModelIO)
    endif()
    if(WITH_RVTK)
        copy_over_dll( rVTK)
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
        set( bsuff "-vc140-mt-1_59.dll")
        if(IS_DEBUG)
            set( bsuff "-vc140-mt-gd-1_59.dll")
        endif()
        file( COPY "${BOOST_LIBRARYDIR}/boost_system${bsuff}"     DESTINATION "${tdest}") 
        file( COPY "${BOOST_LIBRARYDIR}/boost_filesystem${bsuff}" DESTINATION "${tdest}") 
        file( COPY "${BOOST_LIBRARYDIR}/boost_thread${bsuff}"     DESTINATION "${tdest}")
        file( COPY "${BOOST_LIBRARYDIR}/boost_regex${bsuff}"      DESTINATION "${tdest}")
        file( COPY "${BOOST_LIBRARYDIR}/boost_date_time${bsuff}"  DESTINATION "${tdest}")
        file( COPY "${BOOST_LIBRARYDIR}/boost_chrono${bsuff}"     DESTINATION "${tdest}")
    endif()

    if(WITH_OPENCV)
        set( ocvs "2413.dll")
        file( COPY "${OpenCV_BIN}/opencv_core${ocvs}"       DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_highgui${ocvs}"    DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_contrib${ocvs}"    DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_features2d${ocvs}" DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_imgproc${ocvs}"    DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_objdetect${ocvs}"  DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_video${ocvs}"      DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_ml${ocvs}"         DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_flann${ocvs}"      DESTINATION "${tdest}")
        file( COPY "${OpenCV_BIN}/opencv_calib3d${ocvs}"    DESTINATION "${tdest}")
        # Copy in TBB DLL - OpenCV apparently doesn't reference it directly anywhere in its CMake
        # configuration files! Not really sure how it's managing to link it in, but it is
        # (I'm sure I've missed something obvious that will allow me to make this less version specific).
        file( COPY "${LIB_PRE_REQS}/tbb2017_20170604oss/bin/intel64/vc14/tbb.dll" DESTINATION "${tdest}")
    endif()

    if(WITH_VTK)
        set( vtks "-${VTK_VER}.dll")
        file( COPY "${VTK_BIN}/vtkImagingFourier${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingSources${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkAlgLib${vtks}"                      DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkZLIB${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkTIFF${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingVolume${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkPNG${vtks}"                         DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkMetaIO${vtks}"                      DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkJPEG${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOCore${vtks}"                      DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingHybrid${vtks}"               DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingGeneral${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingColor${vtks}"                DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersStatistics${vtks}"           DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersModeling${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersHybrid${vtks}"               DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersGeometry${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersGeneral${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkDicomParser${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonMisc${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonComputationalGeometry${vtks}" DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonColor${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingOpenGL2${vtks}"            DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingGL2PSOpenGL2${vtks}"       DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkInteractionStyle${vtks}"            DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingFreeType${vtks}"           DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonCore${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonDataModel${vtks}"             DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonExecutionModel${vtks}"        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonMath${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonSystem${vtks}"                DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkCommonTransforms${vtks}"            DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersCore${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersExtraction${vtks}"           DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFiltersSources${vtks}"              DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkFreeType${vtks}"                    DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkGL2PS${vtks}"                       DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkGLEW${vtks}"                        DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkGUISupportQt${vtks}"                DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkImagingCore${vtks}"                 DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkInteractionWidgets${vtks}"          DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOGeometry${vtks}"                  DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOImage${vtks}"                     DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkIOLegacy${vtks}"                    DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingAnnotation${vtks}"         DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkRenderingCore${vtks}"               DESTINATION "${tdest}")
        file( COPY "${VTK_BIN}/vtkSys${vtks}"                         DESTINATION "${tdest}")
    endif()

    if(WITH_CGAL)
        get_filename_component( GMP_LIBRARY_DIR "${GMP_LIBRARIES}" PATH)
        set( GMP_DLL  "${GMP_LIBRARY_DIR}/libgmp-10.dll")
        set( MPFR_DLL "${GMP_LIBRARY_DIR}/libmpfr-4.dll")
        file( COPY "${GMP_DLL}"  DESTINATION "${tdest}")
        file( COPY "${MPFR_DLL}" DESTINATION "${tdest}")
        set( cgsuff "-vc140-mt-4.10.dll")
        if(IS_DEBUG)
            set( cgsuff "-vc140-mt-gd-4.10.dll")
        endif()
        file( COPY "${CGAL_BIN}/CGAL${cgsuff}" DESTINATION "${tdest}")
    endif()

    if(WITH_ASSIMP)
        file( COPY "${ASSIMP_DIR}/../../../bin/assimp-vc140-mt.dll" DESTINATION "${tdest}")
    endif()

    if(WITH_QT)
        set(QT_BIN "${Qt5_DIR}/../../../bin")
        file( COPY "${QT_BIN}/Qt5Core${_dsuffix}.dll"    DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5GUI${_dsuffix}.dll"     DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5Widgets${_dsuffix}.dll" DESTINATION "${tdest}")
        file( COPY "${QT_BIN}/Qt5SQL${_dsuffix}.dll"     DESTINATION "${tdest}")
    endif()

endif()
