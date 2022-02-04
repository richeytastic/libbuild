#!/usr/bin/env python3

#************************************************************************
# * Copyright (C) 2022 Richard Palmer
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
import time
import sys
import os


def __getLibraryList():
    libList = ['rlib', 'rimg', 'r3d', 'r3dio', 'r3dvis', 'rNonRigid', 'QTools', 'FaceTools']  # Build these
    return libList


def __getModules( args):
    """Get the paths to the modules/libraries the user wants to build."""
    libList = __getLibraryList()
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


def __cleanDirectory( d, lname):
    fulld = os.path.join( d, lname)
    if fulld != "" and os.path.exists( fulld):
        shutil.rmtree( fulld, ignore_errors=True)


if __name__ == "__main__":
    makeDebug, doInstall, doClean, ms = __getModules( sys.argv[1:])

    cmakeexe = "cmake"
    ninjaexe = "ninja"
    if sys.platform == "win32":
        cmakeexe += ".exe"
        ninjaexe += ".exe"

    cmakepath = hasFileOnPath(cmakeexe)
    ninjapath = hasFileOnPath(ninjaexe)
    hascmake = len(cmakepath) > 0
    hasninja = len(ninjapath) > 0

    CMAKE_DIR = os.path.dirname(os.path.realpath(__file__)) + '{0}cmake'.format( os.path.sep) # adjacent cmake directory

    if len(ms) == 0:
        print( "Usage: {0} (library1 [library2 ...] | all) ([debug] [install]) | [clean]".format(sys.argv[0]))
        print()
        print( " This script uses CMake to configure and generate scripts for the Ninja build system for the following libraries:")
        libList = __getLibraryList()
        for lib in libList:
            print( " - %s" % lib)

        print()
        print( " Specify one of the libraries listed above, or use 'all' to build all available libraries.")
        print( " By default, libraries are built in release mode; use 'debug' to build libraries in debug mode instead.")
        print( " Libraries are not installed by default; use 'install' to copy over files into the installation directory.")
        print( " Passing 'clean' will remove all build and install directories for the specified libraries.")
        print()
        print( " The following environment variables must be set to use this script:")
        print( " DEV_PARENT_DIR     : Directory with library sources (e.g. ~/dev/lib)")
        print( " BUILD_PARENT_DIR   : Directory for building libraries (e.g. ~/local_builds)")
        print( " INSTALL_PARENT_DIR : Directory for installing libraries (e.g. ~/local_libs)")
        print()
        if hascmake:
            print( " CMake found at {0}".format(cmakepath))
        else:
            print( " cmake was not found on PATH!")
        if hasninja:
            print( " ninja found at {0}".format(ninjapath))
        else:
            print( " ninja was not found on PATH!")
        sys.exit(0)

    if not hascmake or not hasninja:
        print( "Exiting - cmake and/or ninja was not found on the PATH!")
        sys.exit(-1)

    envVars = EnvDirs()
    devDir = envVars.getDevEnv()
    bldDir = envVars.getBuildEnv()
    insDir = envVars.getInstallEnv()

    if doClean:
        for mname in ms:
            __cleanDirectory( bldDir, mname)
            __cleanDirectory( insDir, mname)
            print( "Removed build and install directories for library {0}.".format(mname))
        sys.exit(0)

    if devDir == "" or bldDir == "" or insDir == "":
        print( "Exiting: required environment variables not set!")
        sys.exit(-2)

    for mname in ms:
        libDevDir = os.path.join( devDir, mname)

        if not os.path.exists(libDevDir):
            print( "*** ERROR *** : Missing library directory '{0}' - aborting!".format(libDevDir))
            sys.exit(-3)

        mb = CMakeBuilder( libDevDir, makeDebug)
        mb.makeLibraryFindConfig( CMAKE_DIR)    # Updates cmake files in library dev directory

        libBldDir = os.path.join( os.path.join( bldDir, mname), mb.buildType())
        libInsDir = os.path.join( insDir, mname)

        if mb.cmake( libBldDir, libInsDir):
            time.sleep(2)   # To prevent cmake from repeating self calls
            buildOk = mb.build()
            if not buildOk:
                break
            if doInstall:
                mb.install()

    sys.exit(0)

