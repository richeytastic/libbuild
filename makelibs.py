#!/usr/bin/env python
import os
import sys
import shutil
import subprocess32


class ModuleBuilder():
    """Platform agnostic building of C++ modules using CMake."""

    def __init__(self, parentDirs, cmakeDir, mname, makeDebug):
        self.__cmakeDir = cmakeDir
        self.__mname = mname
        self.__buildType = 'Debug' if makeDebug else 'Release'

        self.__DEV_DIR = parentDirs[0] + mname + os.path.sep
        if not os.path.exists(self.__DEV_DIR):
            print "The module's source directory can't be found at {0}!".format(self.__DEV_DIR)
            sys.exit(1)

        self.__INSTALL_DIR = parentDirs[2] + mname + os.path.sep
        if not os.path.exists( self.__INSTALL_DIR): # Create the install directory if not already present
            os.mkdir( self.__INSTALL_DIR)

        self.__BUILD_DIR = parentDirs[1] + mname + os.path.sep
        if not os.path.exists( self.__BUILD_DIR): # Create the module build directory if not already present
            os.mkdir( self.__BUILD_DIR)

        self.__BUILD_DIR += self.__buildType.lower()
        if not os.path.exists( self.__BUILD_DIR): # Create the build type directory if not already present
            os.mkdir( self.__BUILD_DIR)


    def makeCMakeFiles( self):
        print "== [ Creating cmake directory & files in '{0}' source directory ] ==".format( self.__mname)

        """Create the cmake directory inside the library source directory, and copy over/create the necessary files."""
        # Make the cmake directory in the library if not present already.
        libCMakeDir = "{0}cmake{1}".format( self.__DEV_DIR, os.path.sep)
        if not os.path.exists(libCMakeDir):
            os.mkdir( libCMakeDir)

        # Read in template LibConfig.cmake and replace all instances of XXX with self.__mname.
        configFile = libCMakeDir + self.__mname + 'Config.cmake'
        fw = open( configFile, 'w')
        for ln in file( self.__cmakeDir + 'LibConfig.cmake', 'r').readlines():
            fw.write( ln.replace('XXX', self.__mname))
        fw.close()
        print ' + Created {0}'.format( configFile)

        # Copy across the other CMake config files
        shutil.copy( "{0}LibCommon.cmake".format( self.__cmakeDir), libCMakeDir)
        shutil.copy( "{0}LibInstall.cmake".format( self.__cmakeDir), libCMakeDir)
        shutil.copy( "{0}Macros.cmake".format( self.__cmakeDir), libCMakeDir)

        print ' + Created {0}LibCommon.cmake'.format( libCMakeDir)
        print ' + Created {0}LibInstall.cmake'.format( libCMakeDir)
        print ' + Created {0}Macros.cmake'.format( libCMakeDir)


    def cmake( self):
        print "============ [ Building and installing '{0}' {1} ] =============".format( self.__mname, self.__buildType)

        os.chdir( self.__BUILD_DIR)
        #generator = 'NMake Makefiles JOM'   # Use JOM for multi-threaded builds
        #if sys.platform.startswith('linux'):
        #    generator = 'Unix Makefiles'
        generator = 'Ninja' # Use Ninja for Windows and Linux
        shcall = ['cmake', '-DCMAKE_BUILD_TYPE={0}'.format( self.__buildType),
                           '-G', generator,
                           '-DCMAKE_INSTALL_PREFIX={0}'.format( self.__INSTALL_DIR), 
                           self.__DEV_DIR]
        if subprocess32.call( shcall) != 0:
            print "** Error with CMake configuration! **"
            sys.exit(1)


    def make( self):
        retval = subprocess32.call(["cmake", "--build", ".", "--target", "install", "--"])
        if retval != 0:
            print " *** Compilation failed! ***"
            sys.exit(1)


    def checkLinkage( self):
        """Check link dependencies of shared lib (Linux only) in current directory."""
        if not sys.platform.startswith("linux"):
            print "Correct library linkage assumed; run dependency walker to check."
            return

        debugSuffix = 'd' if self.__buildType == 'Debug' else ''
        libPath = "lib{0}{1}.so".format( self.__mname, debugSuffix)
        lddout = subprocess32.check_output(['ldd', libPath]).split('\n')
        missinglibs = [ln.strip() for ln in lddout if ln.find('not found') >= 0]
        if len(missinglibs) > 0:
            print " *** LINKING FAILED! ***"
            for ln in missinglibs:
                print ln
            sys.exit(1)





def buildModule( dirs, cmakeDir, mname, makeDebug):

    print "========================= Building {0} =============================".format(mname)
    mb = ModuleBuilder( dirs, cmakeDir, mname, False)
    mb.makeCMakeFiles()

    print
    mb.cmake()
    mb.make()
    mb.checkLinkage()

    if makeDebug:
        print
        mb = ModuleBuilder( dirs, cmakeDir, mname, True)
        mb.cmake()
        mb.make()
        mb.checkLinkage()
    print "==================================={0}==============================".format('=' * len(mname))
    print


def getEnvVars():
    if not os.environ.has_key('DEV_PARENT_DIR') or not os.environ.has_key('BUILD_PARENT_DIR') or not os.environ.has_key('INSTALL_PARENT_DIR'):
        print 'Env. var DEV_PARENT_DIR must exist and point to the parent directory of the library source folders.'
        print 'Env. vars BUILD_PARENT_DIR and INSTALL_PARENT_DIR must exist and specify the parent build and installation directories.'
        return ()
    ddir = os.environ['DEV_PARENT_DIR'] + os.path.sep
    bdir = os.environ['BUILD_PARENT_DIR'] + os.path.sep
    idir = os.environ['INSTALL_PARENT_DIR'] + os.path.sep
    pdirs = (ddir, bdir, idir)

    # Check to ensure that the parent directories pointed to by the environment variables exist.
    errStr = "{0} is not a valid directory! Set env. var. {1} to the parent directory for the module's {2} directory."
    if not os.path.isdir(ddir):
        print errStr.format(ddir, "DEV_PARENT_DIR", "source")
        pdirs = ()

    if not os.path.isdir(bdir):
        print errStr.format(bdir, "BUILD_PARENT_DIR", "build")
        pdirs = ()

    if not os.path.isdir(idir):
        print errStr.format(idir, "INSTALL_PARENT_DIR", "install")
        pdirs = ()

    return pdirs


def getLibraryList():
    libList = ['rlib', 'rFeatures', 'rModelIO', 'rVTK', 'QTools', 'FaceTools', 'TestUtils']  # Build these
    #libList.extend(['rLearning', 'rPascalVOC', 'tinyxml', 'rHoughVoting', 'rEarthmine'])    # Don't build these
    return libList


def getModules( args):
    """Get the modules/libraries the user wants to build."""
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
        #else:   # Assume rq is the fully qualified name of some other dev directory
        #    if os.path.exists(rq):
        #        ms.append(rq)
        #    else:
        #        print "IGNORING {0}; not a fully qualified path to a source directory, or an available library.".format(rq)
    return makeDebug, ms


if __name__ == "__main__":
    dirs = getEnvVars()
    if len(dirs) == 0:
        sys.exit(1)

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
        cmakeDir = os.path.dirname(os.path.realpath(sys.argv[0])) + '{0}cmake{0}'.format( os.path.sep) # adjacent cmake directory
        for mname in ms:
            buildModule( dirs, cmakeDir, mname, makeDebug)

    sys.exit(0)
