# libbuild

Provides a script (`makelibs.py`) that wraps CMake to configure,
build, and install the following software on both Linux and Windows:
- [rlib](../../../rlib)
- [rFeatures](../../../rFeatures)
- [rVTK](../../../rVTK)
- [QTools](../../../QTools)
- [rModelIO](../../../rModelIO)
- [FaceTools](https://github.com/frontiersi/facetools)
- [Cliniface](https://github.com/frontiersi/cliniface)

Dependencies for these libraries must already be met, with the necessary libraries
available through the PATH. Refer to the prerequisites in the above libraries for details.
In particular though, each library in the list above depends upon those prior to it so the
build and install order should process the libraries in this order. The provided script
does this automatically.

---

The script requires [CMake](https://cmake.org/) (requires version 3.8+ on Windows & Linux),
the [Ninja build system](https://github.com/ninja-build/ninja.git), and Python
2.7 (Python 3.\* not suppported).

Before running `makelibs.py`, ensure the following environment variables are set:
- `DEV_PARENT_DIR`

    Parent directory for the library source directories.

- `BUILD_PARENT_DIR`

    Parent directory for out of source builds of the libraries.

- `INSTALL_PARENT_DIR`

    Parent directory for where the libraries will be installed.

The following environment variables will also be read if set:

- `IDTF_CONVERTER_EXE`

    Location of [IDTFConverter](www2.iaas.msu.ru/tmp/u3d/u3d-1.4.5_current.zip)
    (with thanks to Michail Vidiassov)

On Windows, set the following environment variable to the particular Qt5 distribution to
build against. This is so that conflicting Qt5 libraries (which are sometimes included
with other programs) aren't found instead:
- `QT5_CMAKE_PATH`

    Parent directory for Qt5Config.cmake (e.g. "D:/Qt/5.7/msvc2015\_64/lib/cmake/Qt5")

This repository also comes with a convenient batch scipt for Windows ("makelibs.bat") but
this requires environment variable `PYTHON_EXE` to be set to the python.exe you want to use
(makelibs.bat is just a wrapper for makelibs.py).

The `makelibs.py` script will create subdirectories inside the build and installation
parent directories, with names corresponding to the selected libraries.
Within these created library subdirectories, the necessary headers, import binaries,
and cmake configuration scripts will be generated. In general, the installation
directory will receive copies of only these files, with the originals cached in
the corresponding build directory.

