# libbuild

Provides a script (`makelibs.py`) that wraps CMake to configure,
build, and install the following libraries on both Linux and Windows:
    *[rlib](../rlib/master/README.md)
    *[rFeatures](../rFeatures/master/README.md)
    *[rModelIO](../rModelIO/master/README.md)
    *[rVTK](../rVTK/master/README.md)
    *[QTools](../QTools/master/README.md)
    *[FaceTools](../FaceTools/master/README.md)
    *TestUtils (not available on GitHub at time of writing)

Dependencies for these libraries must already be met, with the necessary libraries
available through the PATH. Refer to the prerequisites in the above libraries for details.

---

The script requires the [Ninja build system](https://github.com/ninja-build/ninja.git)
and Python 2.7 (Python 3.\* not suppported).

Before running `makelibs.py`, ensure the following environment variables are set:
*`DEV_PARENT_DIR`        Parent directory for the library source directories.
*`BUILD_PARENT_DIR`      Parent directory for out of source builds of the libraries.
*`INSTALL_PARENT_DIR`    Parent directory for where the libraries will be installed.

The `makelibs.py` script will create subdirectories inside the build and installation
parent directories, with names corresponding to the selected libraries.
Within these created library subdirectories, the necessary headers, import binaries,
and cmake configuration scripts will be generated. In general, the installation
directory will receive copies of only these files, with the originals cached in
the corresponding build directory.

