# libbuild

Provides a script (`makelibs.py`) that wraps CMake to configure,
build, and install the following software on both Linux and Windows:
- [rlib](../../../rlib)
- [rFeatures](../../../rFeatures)
- [rModelIO](../../../rModelIO)
- [rVTK](../../../rVTK)
- [QTools](../../../QTools)
- [FaceTools](https://github.com/frontiersi/facetools)

Dependencies for these libraries must already be met, with the necessary libraries
available through the PATH. Refer to the prerequisites in the above libraries for details.
In particular though, each library in the list above depends upon those prior to it so the
build and install order should process the libraries in this order. The provided script
does this automatically when passing the 'all' switch.

---

The script requires [CMake](https://cmake.org/) (requires version 3.12.2+),
the [Ninja build system](https://github.com/ninja-build/ninja.git) (tested with
version 1.8.2), and Python 3.6 or higher.

Before running `makelibs.py`, ensure the following environment variables are set:
- `DEV_PARENT_DIR`

    Parent directory for the library source directories e.g. '~/dev/libs'

- `BUILD_PARENT_DIR`

    Parent directory for out of source builds of the libraries e.g. '~/local_builds'

- `INSTALL_PARENT_DIR`

    Parent directory for where the libraries will be installed e.g. '~/local_libs'

The following environment variables will also be read if set:

- `IDTF_CONVERTER_EXE`

    Location of [IDTFConverter](www2.iaas.msu.ru/tmp/u3d/u3d-1.4.5_current.zip)
    (with thanks to Michail Vidiassov)

Set the QT5 environment variable to the particular Qt5 library to build against.
This is to avoid conflicts with other Qt runtime libraries which may be on the path.

- `QT5`

    Parent directory for Qt5 library (e.g. 'C:/Qt/5.12.3/msvc2015\_64')

This repository also comes with a convenient batch scipt for Windows ("makelibs.bat") but this
requires 'python.exe' to be on the PATH.

The `makelibs.py` script will create subdirectories inside the build and installation
parent directories, with names corresponding to the selected libraries.
Within these created library subdirectories, the necessary headers, import binaries,
and cmake configuration scripts will be generated. In general, the installation
directory will receive copies of only these files, with the originals cached in
the corresponding build directory.

Run 'makelibs.py' without switches to see its help output:

```
Usage: /home/rich/bin/makelibs.py (library1 [library2 ...] | all) ([debug] [install]) | [clean]

 This script uses CMake to configure and generate scripts for the Ninja build system for the following libraries:
 - rlib
 - rFeatures
 - rModelIO
 - rVTK
 - QTools
 - FaceTools

 Specify one of the libraries listed above, or use 'all' to build all available libraries.
 By default, libraries are built in release mode; use 'debug' to build libraries in debug mode instead.
 Libraries are not installed by default; use 'install' to copy over files into the installation directory.
 Passing 'clean' will remove all build and install directories for the specified libraries.

 The following environment variables must be set to use this script:
 DEV_PARENT_DIR     : The parent directory of library source directories (e.g. ~/dev/lib)
 BUILD_PARENT_DIR   : The parent directory for where building happens (e.g. ~/local_builds)
 INSTALL_PARENT_DIR : The parent directory for library installation (e.g. ~/local_libs)

 cmake found at /home/rich/opt/cmake-3.12.2/bin/cmake
 ninja found at /usr/bin/ninja
```
