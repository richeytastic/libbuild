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

import os
import sys
import shutil
import subprocess32


class EnvDirs():
    """Gets environment variables for building and installing."""
    def __init__(self):
        self.__errStr = "{0} is not a valid directory! Set env. var. {1} to the parent directory for the module's {2} directory."

    def getInstallEnv( self):
        if os.environ.get('INSTALL_PARENT_DIR') is None:
            print( 'Env. var. INSTALL_PARENT_DIR must exist and specify the parent installation directory.')
            return ""
        idir = os.environ['INSTALL_PARENT_DIR']
        if not os.path.isdir(idir):
            print( errStr.format(idir, "INSTALL_PARENT_DIR", "install"))
            idir = ""
        return idir


    def getBuildEnv( self):
        if os.environ.get('BUILD_PARENT_DIR') is None:
            print( 'Env. var. BUILD_PARENT_DIR must exist and specify the parent build directory.')
            return ""
        bdir = os.environ['BUILD_PARENT_DIR']
        if not os.path.isdir(bdir):
            print( errStr.format(bdir, "BUILD_PARENT_DIR", "build"))
            bdir = ""
        return bdir


    def getDevEnv( self):
        if os.environ.get('DEV_PARENT_DIR') is None:
            print( 'Env. var DEV_PARENT_DIR must exist and point to the parent directory of the library source folders.')
            return ""
        ddir = os.environ['DEV_PARENT_DIR']
        if not os.path.isdir(ddir):
            print( errStr.format(ddir, "DEV_PARENT_DIR", "source"))
            ddir = ""
        return ddir


def makeDirectoryPath( bdir):
    adir = os.path.realpath(bdir)
    bdir = adir
    while not os.path.isdir(adir):
        adir = os.path.split(adir)[0]
    # adir is an existing directory
    pelems = [x for x in bdir.split(adir)[1].split(os.path.sep) if len(x) > 0]
    for d in pelems:
        adir = os.path.join(adir, d)
        os.mkdir(adir)


class CMakeBuilder():
    """Platform agnostic building of C++ modules using CMake."""

    def __init__(self, cmakeDir, devdir, makeDebug, buildDir):
        self.__cmakeDir = cmakeDir
        self.__mname = devdir.split(os.path.sep)[-1]    # devdir may be a full path or a name
        self.__buildType = 'Debug' if makeDebug else 'Release'

        envdirs = EnvDirs()
        # if devdir is a name, it won't exist on the filesystem
        if not os.path.isdir(devdir):
            pdevdir = envdirs.getDevEnv()
            print( "Looking for {0} in {1}...".format(devdir,pdevdir))
            devdir = os.path.join( pdevdir, devdir)

        self.__DEV_DIR = devdir
        if not os.path.exists(self.__DEV_DIR):
            print( "The source directory wasn't found at {0}!".format(self.__DEV_DIR))
            sys.exit(1)

        print( "====================== [ Building '{0}' {1} ] =======================".format( self.__mname, self.__buildType))

        # Make the cmake directory in the library if not present already.
        libCMakeDir = os.path.join( self.__DEV_DIR, 'cmake')
        makeDirectoryPath( libCMakeDir)
        self.__copyCMakeFiles()

        #self.__BUILD_DIR = os.path.join( buildDir, self.__buildType.lower())
        self.__BUILD_DIR = os.path.join( buildDir, self.__buildType)
        makeDirectoryPath( self.__BUILD_DIR)  # Create the module build directory and build type if not already present


    def makeFindConfig( self):
        """Create the Find*L*.cmake file inside library L's dev/cmake directory."""
        # Read in template LibConfig.cmake and replace all instances of XXX with self.__mname.
        configFile = os.path.join( self.__DEV_DIR, 'cmake', self.__mname + 'Config.cmake')  # Write destination
        fw = open( configFile, 'w')
        for ln in open( os.path.join( self.__cmakeDir, 'LibConfig.cmake'), 'r').readlines():  # Get template lines
            fw.write( ln.replace('XXX', self.__mname))  # Replace XXX tokens
        fw.close()
        print( ' + Created {0}'.format( configFile))


    def __copyCMakeFiles( self):
        """Copy across the other CMake config files into the development library cmake directory."""
        tdir = os.path.join( self.__DEV_DIR, 'cmake')
        shutil.copy( os.path.join( self.__cmakeDir, 'Macros.cmake'), tdir)
        shutil.copy( os.path.join( self.__cmakeDir, 'FindLibs.cmake'), tdir)
        shutil.copy( os.path.join( self.__cmakeDir, 'LinkLibs.cmake'), tdir)
        shutil.copy( os.path.join( self.__cmakeDir, 'LinkTargets.cmake'), tdir)
        print( ' + Created', os.path.join( tdir,'Macros.cmake'))
        print( ' + Created', os.path.join( tdir,'FindLibs.cmake'))
        print( ' + Created', os.path.join( tdir,'LinkLibs.cmake'))
        print( ' + Created', os.path.join( tdir,'LinkTargets.cmake'))


    def cmake( self):
        #generator = 'NMake Makefiles JOM'   # Use JOM for multi-threaded builds
        #if sys.platform.startswith('linux'):
        #    generator = 'Unix Makefiles'
        os.chdir( self.__BUILD_DIR)
        generator = 'Ninja' # Use Ninja for Windows and Linux
        shcall = ['cmake', '-DCMAKE_BUILD_TYPE={0}'.format( self.__buildType), '-G', generator, self.__DEV_DIR]
        if subprocess32.call( shcall) != 0:
            print( "** Error with CMake configuration! **")
            return False
        # Set the project name from the generated CMakeCache.txt
        self.__projectName = self.getCMakeCacheVariable( 'CMAKE_PROJECT_NAME');
        return True


    def getCMakeCacheVariable( self, varName):
        """Returns the value of CMake variable varName."""
        os.chdir( self.__BUILD_DIR)
        if not os.path.exists( 'CMakeCache.txt'):
            return ""

        for ln in open( 'CMakeCache.txt', 'r').readlines():
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


    def build( self):
        os.chdir( self.__BUILD_DIR)
        cmd = ['cmake', '--build', '.', '--']
        if subprocess32.call(cmd) != 0:
            print( " *** BUILD FAILED! ***")
            return False
        return self.__checkLinkage()


    def install( self, installDir):
        makeDirectoryPath( installDir) # Create the install directory if not already present
        os.chdir( self.__BUILD_DIR)
        cmd = ['cmake', '-DCMAKE_INSTALL_PREFIX={0}'.format( installDir), self.__DEV_DIR]
        if subprocess32.call(cmd) != 0:
            print( " *** CMAKE RUN FAILED! ***")
            return False
        cmd = ['cmake', '--build', '.', '--target', 'install']
        if subprocess32.call(cmd) != 0:
            print( " *** BUILD & INSTALL FAILED! ***")
            return False


    def __checkLinkage( self):
        """Check link dependencies of shared lib (Linux only) in build directory.
           Does nothing if no shared library present."""
        if not sys.platform.startswith("linux"):
            print( "Correct library linkage assumed; run dependency walker to check.")
            return True

        debugSuffix = 'd' if self.__buildType == 'Debug' else ''
        libPath = "lib{0}{1}.so".format( self.__projectName, debugSuffix)
        # Check if the shared lib exists with standard naming convension.
        if not os.path.exists(libPath):
            return True

        rval = True
        lddout = subprocess32.check_output(['ldd', libPath]).split('\n')
        missinglibs = [ln.strip() for ln in lddout if ln.find('not found') >= 0]
        if len(missinglibs) > 0:
            print( " *** LINKING FAILED! ***")
            for ln in missinglibs:
                print( ln)
            rval = False

        return rval

