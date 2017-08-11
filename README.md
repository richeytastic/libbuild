# libbuild

Provides a script (`makelibs.py`) that wraps CMake to configure,
build, and install the following libraries on both Linux and Windows:
- [rlib](../../../rlib/blob/master/README.md)
- [rFeatures](../../../rFeatures/blob/master/README.md)
- [rVTK](../../../rVTK/blob/master/README.md)
- [QTools](../../../QTools/blob/master/README.md)
- [rModelIO](../../../rModelIO/blob/master/README.md)
- [FaceTools](../../../FaceTools/blob/master/README.md)
- TestUtils (not available on GitHub at time of writing)

Dependencies for these libraries must already be met, with the necessary libraries
available through the PATH. Refer to the prerequisites in the above libraries for details.
In particular though, each library in the list above depends upon those prior to it so the
build and install order should process the libraries in this order. The provided script
does this automatically.

---

The script requires [CMake](https://cmake.org/) (tested with 3.5.1 on Windows & Linux),
the [Ninja build system](https://github.com/ninja-build/ninja.git),
and Python 2.7 (Python 3.\* not suppported).

Before running `makelibs.py`, ensure the following environment variables are set:
- `DEV_PARENT_DIR`

    Parent directory for the library source directories.

- `BUILD_PARENT_DIR`

    Parent directory for out of source builds of the libraries.

- `INSTALL_PARENT_DIR`

    Parent directory for where the libraries will be installed.

The following environment variables will also be read if set:
- `PDFLATEX_EXE`

    Location of pdflatex. Part of the [MiKTeK](https://miktex.org/) distribution on Windows, but usually
    installed in /usr/bin if installed systemwide on Linux as part of [TeX Live](https://www.tug.org/texlive/)

- `IDTF_CONVERTER_EXE`

    Location of [IDTFConverter](www2.iaas.msu.ru/tmp/u3d/u3d-1.4.5_current.zip)
    (with thanks to Michail Vidiassov)

In addition, on Windows, set the following environment variable to the particular Qt5
distribution to build against. This is so that conflicting Qt5 libraries (which are
sometimes included with other programs) aren't found instead:
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

