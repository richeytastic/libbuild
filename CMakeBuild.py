#!/bin/env python3

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

import os
import sys
import shutil
import subprocess
from pathlib import Path


class EnvDirs():
    """Gets environment variables for building and installing."""
    def __init__(self) -> None:
        self.__errStr = "{0} is not a valid directory! Set env. var. {1} to the parent directory for the module's {2} directory."

    def getInstallEnv( self) -> str:
        if os.environ.get('INSTALL_PARENT_DIR') is None:
            print( 'Env. var. INSTALL_PARENT_DIR must exist and be the parent installation directory.')
            return ""
        idir = os.environ['INSTALL_PARENT_DIR']
        if not os.path.isdir(idir):
            print( self.__errStr.format(idir, "INSTALL_PARENT_DIR", "install"))
            idir = ""
        return idir


    def getBuildEnv( self) -> str:
        if os.environ.get('BUILD_PARENT_DIR') is None:
            print( 'Env. var. BUILD_PARENT_DIR must exist and be the parent build directory.')
            return ""
        bdir = os.environ['BUILD_PARENT_DIR']
        if not os.path.isdir(bdir):
            print( self.__errStr.format(bdir, "BUILD_PARENT_DIR", "build"))
            bdir = ""
        return bdir


    def getDevEnv( self) -> str:
        if os.environ.get('DEV_PARENT_DIR') is None:
            print( 'Env. var DEV_PARENT_DIR must exist and be the parent of the library source directories.')
            return ""
        ddir = os.environ['DEV_PARENT_DIR']
        if not os.path.isdir(ddir):
            print( self.__errStr.format(ddir, "DEV_PARENT_DIR", "source"))
            ddir = ""
        return ddir


def makeDirectoryPath( bdir, warn=True) -> None:
    adir = os.path.realpath(bdir)
    bdir = adir
    if warn and not os.path.exists( bdir):
        print( "** WARNING ** : Directory '{0}' does not exist - it will be created!".format(bdir))
    while not os.path.isdir(adir):
        adir = os.path.split(adir)[0]
    # adir is an existing directory
    pelems = [x for x in bdir.split(adir)[1].split(os.path.sep) if len(x) > 0]
    for d in pelems:
        adir = os.path.join(adir, d)
        os.mkdir(adir)


def hasFileOnPath( fname) -> str:
    """Returns the full path to the given file iff the file is found on the PATH."""
    pdirs = os.environ['PATH'].split(os.pathsep)
    for pdir in pdirs:
        fpath = os.path.join(pdir, fname)
        if os.path.exists(fpath):
            return str(Path(fpath).resolve())
    return ""


class CMakeBuilder():
    """Platform agnostic building of C++ modules using CMake."""

    def __init__(self, devdir, makeDebug, mname:str="") -> None:
        # Get the module name from devdir unless specified explicitly
        self.__mname = devdir.split(os.path.sep)[-1] if mname == "" else mname
        self.__buildType = 'Debug' if makeDebug else 'Release'

        # if devdir is a name, it won't exist on the filesystem
        if not os.path.isdir(devdir):
            envdirs = EnvDirs()
            pdevdir = envdirs.getDevEnv()
            print( "Looking for {0} in {1}...".format(devdir, pdevdir))
            devdir = os.path.join( pdevdir, devdir)

        self.__DEV_DIR = devdir


    def buildType( self) -> str:
        return self.__buildType


    def makeLibraryFindConfig( self, cmakeDir) -> bool:
        if not os.path.exists(self.__DEV_DIR):
            print( "Cannot configure library cmake files - the source directory wasn't found at {0}!".format(self.__DEV_DIR))
            return False

        print( "~~~~~~~~~~~~~~~~~~~~| Creating '{0}Config.cmake' |~~~~~~~~~~~~~~~~~~~~~".format(self.__mname))
        # Make the cmake directory in the library if not present already.
        libCMakeDir = os.path.join( self.__DEV_DIR, 'cmake')
        makeDirectoryPath( libCMakeDir)

        # Copy across the other CMake config files into the development library cmake directory.
        tdir = os.path.join( self.__DEV_DIR, 'cmake')
        shutil.copy( os.path.join( cmakeDir, 'FindLibs.cmake'), tdir)
        shutil.copy( os.path.join( cmakeDir, 'LinkLibs.cmake'), tdir)
        shutil.copy( os.path.join( cmakeDir, 'LinkTargets.cmake'), tdir)
        print( " + Updated {0}".format(os.path.join( tdir,'FindLibs.cmake')))
        print( " + Updated {0}".format(os.path.join( tdir,'LinkLibs.cmake')))
        print( " + Updated {0}".format(os.path.join( tdir,'LinkTargets.cmake')))

        """Create the Find*L*.cmake file inside library L's dev/cmake directory."""
        # Read in template LibConfig.cmake and replace all instances of <XXX> with self.__mname.
        configFile = os.path.join( self.__DEV_DIR, 'cmake', self.__mname + 'Config.cmake')  # Write destination
        fw = open( configFile, 'w')
        for ln in open( os.path.join( cmakeDir, 'LibConfig.cmake'), 'r').readlines():  # Get template lines
            fw.write( ln.replace('<XXX>', self.__mname))  # Replace <XXX> tokens
        fw.close()
        print( ' + Updated {0}'.format(configFile))
        return True


    def cmake( self, buildDir, installDir) -> bool:
        if not os.path.exists( self.__DEV_DIR):
            print( "Cannot configure - the source directory wasn't found at {0}!".format(self.__DEV_DIR))
            return False

        print( "~~~~~~~~~~~~~~~~~~~~| Configuring '{0}' {1} |~~~~~~~~~~~~~~~~~~~~~~".format(self.__mname, self.__buildType))
        self.__BUILD_DIR = buildDir
        self.__INSTALL_DIR = installDir

        makeDirectoryPath( self.__BUILD_DIR)    # Create the module build directory and build type if not already present

        #generator = 'NMake Makefiles JOM'   # Use JOM for multi-threaded builds
        #if sys.platform.startswith('linux'):
        #    generator = 'Unix Makefiles'
        #pwd = os.path.realpath(os.curdir)   # Remember current working directory
        #os.chdir( self.__BUILD_DIR)         # Change to the build directory

        generator = 'Ninja' # Use Ninja for Windows and Linux
        cmd = ['cmake',
               '-G', generator,
               '-DCMAKE_BUILD_TYPE={0}'.format(self.__buildType),
               '-DCMAKE_INSTALL_PREFIX={0}'.format(self.__INSTALL_DIR),
               '-S', self.__DEV_DIR,
               '-B', self.__BUILD_DIR]

        print( ' '.join(cmd))
        if subprocess.run( cmd).returncode != 0:
            print( "** Error with CMake configuration! **")
            return False

        # Set the project name from the generated CMakeCache.txt
        self.__projectName = self.__getCMakeCacheVariable( 'CMAKE_PROJECT_NAME');

        print( "~~~| Finished configuring '{0}' {1} |~~~".format(self.__mname, self.__buildType))
        return True


    def __getCMakeCacheVariable( self, varName) -> str:
        """Returns the value of CMake variable varName."""
        cachefile = os.path.join( self.__BUILD_DIR, 'CMakeCache.txt')
        if not os.path.exists( cachefile):
            return ""

        for ln in open( cachefile, 'r').readlines():
            if ln.startswith(varName):
                x, z = ln.split('=')
                x, y = x.split(':')  # Get the type into y (x == varName)
                z = z.strip()
                # z is a string (STRING, PATH, FILEPATH), unless y is BOOL
                if y == 'BOOL':
                    lz = z.lower()
                    if lz == 'false' or lz == 'off' or lz == '0':
                        return False
                    return True
                return z
        return ""   # Not found


    def build( self) -> bool:
        if not os.path.exists(self.__DEV_DIR):
            print( "Cannot build - the source directory wasn't found at {0}!".format(self.__DEV_DIR))
            return False

        print( "~~~~~~~~~~~~~~~~~~~~~~| Building '{0}' {1} |~~~~~~~~~~~~~~~~~~~~~~~".format(self.__mname, self.__buildType))
        cmd = ['cmake', '--build', self.__BUILD_DIR]
        print( ' '.join(cmd))
        okay = True
        if subprocess.run(cmd).returncode != 0:
            okay = False
            print( " *** BUILD FAILED! ***")
        else:
            print( "~~~| Finished building '{0}' {1} |~~~".format(self.__mname, self.__buildType))
        return okay


    def install( self) -> bool:
        if not os.path.exists(self.__DEV_DIR):
            print( "Cannot install - the source directory wasn't found at {0}!".format(self.__DEV_DIR))
            return False

        print( "~~~~~~~~~~~~~~~~~~~~~| Installing '{0}' {1} |~~~~~~~~~~~~~~~~~~~~~~".format(self.__mname, self.__buildType))
        makeDirectoryPath( self.__INSTALL_DIR)  # Create the install directory if not already present

        cmd = ['cmake', '--build', self.__BUILD_DIR, '--target', 'install']
        print( ' '.join(cmd))
        okay = False
        if subprocess.run(cmd).returncode != 0:
            print( " *** INSTALL FAILED! ***")
        else:
            okay = True
        print( "~~~| Finished installing '{0}' {1} |~~~".format(self.__mname, self.__buildType))
        return okay


    def isLinkageOkay( self) -> bool:
        """Check link dependencies of shared lib (Linux only) in build directory.
           Does nothing if no shared library present."""
        if not sys.platform.startswith("linux"):
            print( "Correct library linkage assumed; run dependency walker to check.")
            return True

        # Check if the shared lib exists with standard naming convension.
        debugSuffix = 'd' if self.__buildType == 'Debug' else ''
        libPath = os.path.join( self.__BUILD_DIR, "lib{0}{1}.so".format(self.__projectName, debugSuffix))
        if not os.path.exists(libPath):
            print( '"{0}" does not exist!'.format( libPath))
            return False

        rval = True
        try:
            print( 'Checking library linkage for "{0}"'.format( libPath))
            lddout = subprocess.check_output(['ldd', libPath], universal_newlines=True).split('\n')
            missinglibs = [ln.strip() for ln in lddout if ln.find('not found') >= 0]
            if len(missinglibs) > 0:
                print( " *** LINKING FAILED! ***")
                for ln in missinglibs:
                    print( ln)
                rval = False
        except:
            print( '** WARNING ** ldd failed! Assuming correct linkage.')

        return rval

