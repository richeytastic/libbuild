#!/usr/bin/env python

#************************************************************************
# * Copyright (C) 2017 Richard Palmer
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
import sys
import os


def getLibraryList():
    libList = ['rlib', 'rFeatures', 'rModelIO', 'rVTK', 'QTools', 'FaceTools']  # Build these
    #libList.extend(['rLearning', 'rPascalVOC', 'tinyxml', 'rHoughVoting', 'rEarthmine', 'TestUtils'])    # Don't build these
    return libList


def getModules( args):
    """Get the paths to the modules/libraries the user wants to build."""
    libList = getLibraryList()
    libDict = {}
    for l in libList:
        libDict[l.lower()] = l

    makeDebug = False
    doInstall = False
    ms = []
    for rq in args:
        arg = rq.lower()
        if libDict.keys().count(arg) > 0:    # Build a specific set of libraries
            ms.append(libDict[arg])
        elif arg == "all":
            ms = list(libList)  # Set ms to be the whole set of libraries to build
        elif arg == "debug":
            makeDebug = True
        elif arg == "install":
            doInstall = True
    return makeDebug, doInstall, ms


if __name__ == "__main__":
    makeDebug, doInstall, ms = getModules( sys.argv[1:])
    if len(ms) == 0:
        print "Usage: {0} (module | library1 [library2 ...] | all) [debug] [install]".format(sys.argv[0])
        print "\tThis is a script to help with the building, linking, and installation of the following libraries:"
        libList = getLibraryList()
        for lib in libList:
            print "\t\t{0}".format(lib)
        print "\tThe current CMake generator used is 'Ninja'; ensure ninja is on the PATH."
        print "\tSpecify one of the libraries listed above, or use 'all' to build all available libraries."
        print "\tBy default, libraries are built in release mode; use 'debug' to build libraries in debug mode instead."
        print "\tLibraries are not installed by default; use 'install' to copy over files into the installation directory."
        print "\tThe following environment variables must be defined prior to using this script:"
        print "\tDEV_PARENT_DIR     : The parent directory of library source directories (e.g. /home/user/dev/lib)"
        print "\tBUILD_PARENT_DIR   : The parent directory for where building happens (e.g. /home/user/local_builds)"
        print "\tINSTALL_PARENT_DIR : The parent directory for library installation (e.g. /home/user/local_libs)"
    else:
        envVars = EnvDirs()
        devDir = envVars.getDevEnv()
        buildDir = envVars.getBuildEnv()
        installDir = envVars.getInstallEnv()

        if not os.path.exists(devDir):
            print "Exiting - parent development directory not defined or doesn't exist. Ensure DEV_PARENT_DIR is a valid path."
            sys.exit(-1)

        if buildDir == "":
            print "Exiting - parent build directory not set; ensure environment variable BUILD_PARENT_DIR is set."
            sys.exit(-2)

        if doInstall and installDir == "":
            print "Exiting - installation not available - a valid parent installation directory was not defined; ensure INSTALL_PARENT_DIR is set."
            sys.exit(-3)

        cmakeDir = os.path.dirname(os.path.realpath(sys.argv[0])) + '{0}cmake'.format( os.path.sep) # adjacent cmake directory
        for mname in ms:
            libDevDir = devDir + os.path.sep + mname
            libBuildDir = buildDir + os.path.sep + mname
            libInstallDir = installDir + os.path.sep + mname

            if not os.path.exists(libDevDir):
                print "*** ERROR *** : Missing library directory '{0}' - aborting!".format(libDevDir)
                sys.exit(-4)

            if not os.path.exists(libBuildDir):
                print "** WARNING *** : Build directory '{0}' does not exist - it will be created!".format(libBuildDir)

            mb = CMakeBuilder( cmakeDir, libDevDir, makeDebug, libBuildDir)
            mb.makeFindConfig()
            mb.cmake()
            mb.build()
            if doInstall:
                if not os.path.exists( libInstallDir):
                    print "*** WARNING *** : Installation directory '{0}' does not exist - it will be created!".format(libInstallDir)
                mb.install( libInstallDir)

    sys.exit(0)

