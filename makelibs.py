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
    libList = ['rlib', 'rFeatures', 'rModelIO', 'rVTK', 'QTools', 'FaceTools', 'TestUtils']  # Build these
    #libList.extend(['rLearning', 'rPascalVOC', 'tinyxml', 'rHoughVoting', 'rEarthmine'])    # Don't build these
    return libList


def getModules( args):
    """Get the paths to the modules/libraries the user wants to build."""
    libList = getLibraryList()
    libDict = {}
    for l in libList:
        libDict[l.lower()] = l

    makeDebug = False
    ms = []
    for rq in args:
        if libDict.keys().count(rq.lower()) > 0:    # Build a specific set of libraries
            ms.append(libDict[rq.lower()])
        elif rq.lower() == "all":
            ms = list(libList)  # Set ms to be the whole set of libraries to build
        elif rq.lower() == "debug":
            makeDebug = True
    return makeDebug, ms


if __name__ == "__main__":
    makeDebug, ms = getModules( sys.argv[1:])
    if len(ms) == 0:
        print "Usage: {0} (module | library1 [library2 ...] | all) [debug]".format(sys.argv[0])
        #print "\tSpecify either a custom module, or an existing library. Use 'all' to build all libraries."
        print "\tThe current CMake generator used is 'Ninja'. Ensure ninja is on the PATH."
        print "\tSpecify an existing library. Use 'all' to build all libraries."
        print "\tDebug builds are NOT built by default; specify 'debug' to build IN ADDITION to the release build."
        print "\tThe available libraries are:"
        libList = getLibraryList()
        for lib in libList:
            print "\t\t{0}".format(lib)
    else:
        envVars = EnvDirs()
        devDir = envVars.getDevEnv()
        buildDir = envVars.getBuildEnv()
        installDir = envVars.getInstallEnv()

        cmakeDir = os.path.dirname(os.path.realpath(sys.argv[0])) + '{0}cmake'.format( os.path.sep) # adjacent cmake directory
        for mname in ms:
            libDevDir = devDir + os.path.sep + mname
            libBuildDir = buildDir + os.path.sep + mname
            libInstallDir = installDir + os.path.sep + mname

            mb = CMakeBuilder( cmakeDir, libDevDir, False, libBuildDir)  # Make release
            mb.makeFindConfig()
            mb.cmake()
            mb.build()
            mb.install( libInstallDir)
            if makeDebug:   # Make the debug version?
                print
                mb = CMakeBuilder( cmakeDir, libDevDir, True, libBuildDir)
                mb.cmake()
                mb.build()
                mb.install( libInstallDir)
            print

    sys.exit(0)

