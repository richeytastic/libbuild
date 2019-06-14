#!/usr/bin/env python3

#************************************************************************
# * Copyright (C) 2019 Richard Palmer
# *
# * This program is free software: you can redistribute it and/or modify
# * it under the terms of the GNU General Public License as published by
# * the Free Software Foundation, either version 3 of the License, or
# * (at your option) any later version.
# *
# * This program is distributed in the hope that it will be useful,
# * but WITHOUT ANY WARRANTY; without even the implied warranty of
# * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# * GNU General Public License for more details.
# *
# * You should have received a copy of the GNU General Public License
# * along with this program.  If not, see <http://www.gnu.org/licenses/>.
#************************************************************************

from CMakeBuild import CMakeBuilder
from CMakeBuild import EnvDirs
from CMakeBuild import hasFileOnPath
import shutil
import sys
import os


def getLibraryList():
    libList = ['rlib', 'rFeatures', 'rModelIO', 'rVTK', 'QTools', 'FaceTools']  # Build these
    return libList


def getModules( args):
    """Get the paths to the modules/libraries the user wants to build."""
    libList = getLibraryList()
    libDict = {}
    for l in libList:
        libDict[l.lower()] = l

    makeDebug = False
    doInstall = False
    doClean = False
    ms = []
    for rq in args:
        arg = rq.lower()
        if list(libDict.keys()).count(arg) > 0:    # Build a specific set of libraries
            ms.append(libDict[arg])
        elif arg == "all":
            ms = list(libList)  # Set ms to be the whole set of libraries to build
        elif arg == "debug":
            makeDebug = True
        elif arg == "install":
            doInstall = True
        elif arg == "clean":
            doClean = True
    return makeDebug, doInstall, doClean, ms


def cleanDirectory( d, lname):
    fulld = os.path.join( d, lname)
    if fulld != "" and os.path.exists( fulld):
        shutil.rmtree( fulld, ignore_errors=True)


if __name__ == "__main__":
    makeDebug, doInstall, doClean, ms = getModules( sys.argv[1:])

    cmakeexe = "cmake"
    ninjaexe = "ninja"
    if sys.platform == "win32":
        cmakeexe += ".exe"
        ninjaexe += ".exe"

    cmakepath = hasFileOnPath(cmakeexe)
    ninjapath = hasFileOnPath(ninjaexe)

    hascmake = len(cmakepath) > 0
    hasninja = len(ninjapath) > 0

    if len(ms) == 0:
        print( "Usage: {} (library1 [library2 ...] | all) ([debug] [install]) | [clean]".format( sys.argv[0]))
        print()
        print( " This script uses CMake to configure and generate scripts for the Ninja build system for the following libraries:")
        libList = getLibraryList()
        for lib in libList:
            print( " - %s" % lib)

        print()
        print( " Specify one of the libraries listed above, or use 'all' to build all available libraries.")
        print( " By default, libraries are built in release mode; use 'debug' to build libraries in debug mode instead.")
        print( " Libraries are not installed by default; use 'install' to copy over files into the installation directory.")
        print( " Passing 'clean' will remove all build and install directories for the specified libraries.")
        print()
        print( " The following environment variables must be set to use this script:")
        print( " DEV_PARENT_DIR     : The parent directory of library source directories (e.g. ~/dev/lib)")
        print( " BUILD_PARENT_DIR   : The parent directory for where building happens (e.g. ~/local_builds)")
        print( " INSTALL_PARENT_DIR : The parent directory for library installation (e.g. ~/local_libs)")
        print()
        if hascmake:
            print( " {0} found at {1}".format( "cmake", cmakepath))
        else:
            print( " cmake was not found on PATH!")
        if hasninja:
            print( " {0} found at {1}".format( "ninja", ninjapath))
        else:
            print( " ninja was not found on PATH!")
        sys.exit(0)

    envVars = EnvDirs()
    devDir = envVars.getDevEnv()
    buildDir = envVars.getBuildEnv()
    installDir = envVars.getInstallEnv()

    if buildDir == "":
        print( "Exiting - building not available; ensure BUILD_PARENT_DIR is set.")
        sys.exit(-1)

    if (doInstall or doClean) and installDir == "":
        print( "Exiting - installation not available; ensure INSTALL_PARENT_DIR is set.")
        sys.exit(-2)

    if doClean:
        for mname in ms:
            cleanDirectory( buildDir, mname)
            cleanDirectory( installDir, mname)
        sys.exit(0)

    if not hascmake:
        print( "Exiting - cmake was not found on the PATH - please fix and try again.")
        sys.exit(-3)

    if not hasninja:
        print( "Exiting - ninja was not found on the PATH - please fix and try again.")
        sys.exit(-4)

    if not os.path.exists(devDir):
        print( "Exiting - building not available; Ensure DEV_PARENT_DIR is set to a valid path where the libraries are located.")
        sys.exit(-5)

    cmakeDir = os.path.dirname(os.path.realpath(sys.argv[0])) + '{0}cmake'.format( os.path.sep) # adjacent cmake directory
    for mname in ms:
        libDevDir = os.path.join( devDir, mname)
        if not os.path.exists(libDevDir):
            print( "*** ERROR *** : Missing library directory '{0}' - aborting!".format(libDevDir))
            sys.exit(-6)

        mb = CMakeBuilder( libDevDir, makeDebug)
        mb.makeLibraryFindConfig( cmakeDir)

        libBuildDir = os.path.join( os.path.join( buildDir, mname), mb.buildType())
        libInstallDir = os.path.join( installDir, mname)
        if mb.cmake( libBuildDir, libInstallDir):
            if mb.build() and doInstall:
                mb.install()

    sys.exit(0)

