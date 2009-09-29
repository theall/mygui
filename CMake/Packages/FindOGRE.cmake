# Find OGRE includes and library
#
# This module defines
#  OGRE_INCLUDE_DIR
#  OGRE_LIBRARIES, the libraries to link against to use OGRE.
#  OGRE_LIB_DIR, the location of the libraries
#  OGRE_FOUND, If false, do not try to use OGRE

CMAKE_POLICY(PUSH)

IF (OGRE_LIBRARIES AND OGRE_INCLUDE_DIR)
	SET(OGRE_FIND_QUIETLY TRUE) # Already in cache, be silent
ENDIF (OGRE_LIBRARIES AND OGRE_INCLUDE_DIR)

IF (NOT OGRE_DIR)
	set(OGRE_DIR "" CACHE PATH "Path to Ogre sources (set it if you don't have OGRE_HOME or OGRE_SRC environment variables)")
ENDIF ()

IF (WIN32) #Windows
	MESSAGE(STATUS "Looking for OGRE")
	SET(OGRESDK $ENV{OGRE_HOME})
	SET(OGRESOURCE $ENV{OGRE_SRC})
	IF (OGRE_DIR)
		MESSAGE(STATUS "Using OGRE built from source (from specified path)")
		SET(OGRE_INCLUDE_DIR ${OGRE_DIR}/OgreMain/include)
		SET(OGRE_LIB_DIR ${OGRE_DIR}/lib)
	ELSEIF (OGRESDK)
		MESSAGE(STATUS "Using OGRE SDK")
		STRING(REGEX REPLACE "[\\]" "/" OGRESDK "${OGRESDK}")
		SET(OGRE_INCLUDE_DIR ${OGRESDK}/include/OGRE ${OGRESDK}/include)
		SET(OGRE_LIB_DIR ${OGRESDK}/lib)
		IF (NOT OGRE_DIR)
			set(OGRE_DIR $ENV{OGRE_HOME} CACHE PATH "Path to Ogre sources (set it if you don't have OGRE_HOME or OGRE_SRC environment variables)")
		ENDIF ()
	ELSEIF (OGRESOURCE)
		MESSAGE(STATUS "Using OGRE built from source")
		SET(OGRE_INCLUDE_DIR $ENV{OGRE_SRC}/OgreMain/include)
		SET(OGRE_LIB_DIR $ENV{OGRE_SRC}/lib)
		IF (NOT OGRE_DIR)
			set(OGRE_DIR $ENV{OGRE_SRC} CACHE PATH "Path to Ogre sources (set it if you don't have OGRE_HOME or OGRE_SRC environment variables)")
		ENDIF ()
	ENDIF ()

	IF (OGRESDK OR OGRESOURCE OR OGRE_DIR)
		SET(OGRE_LIBRARIES debug OgreMain_d optimized OgreMain)

		SET(OGRE_INCLUDE_DIR ${OGRE_INCLUDE_DIR} CACHE PATH "")
		SET(OGRE_LIBRARIES ${OGRE_LIBRARIES} CACHE STRING "")
		SET(OGRE_LIB_DIR ${OGRE_LIB_DIR} CACHE PATH "")
	ENDIF ()
ELSE (WIN32) #Unix
	IF (OGRE_DIR)
		MESSAGE(STATUS "Using OGRE built from source (from specified path)")
		SET(OGRE_INCLUDE_DIR ${OGRE_DIR}/OgreMain/include)
		SET(OGRE_LIB_DIR ${OGRE_DIR}/lib)
	ELSE ()
		CMAKE_MINIMUM_REQUIRED(VERSION 2.4.7 FATAL_ERROR)
		FIND_PACKAGE(PkgConfig)
		PKG_SEARCH_MODULE(OGRE OGRE)
		SET(OGRE_INCLUDE_DIR ${OGRE_INCLUDE_DIRS})
		SET(OGRE_LIB_DIR ${OGRE_LIBDIR})
	ENDIF ()

	SET(OGRE_INCLUDE_DIR ${OGRE_INCLUDE_DIR} CACHE PATH "")
	SET(OGRE_LIBRARIES ${OGRE_LIBRARIES} CACHE STRING "")
	SET(OGRE_LIB_DIR ${OGRE_LIB_DIR} CACHE PATH "")
ENDIF (WIN32)

IF (OGRE_INCLUDE_DIR AND OGRE_LIBRARIES)
	SET(OGRE_FOUND TRUE)
ENDIF (OGRE_INCLUDE_DIR AND OGRE_LIBRARIES)

IF (OGRE_FOUND)
	IF (NOT OGRE_FIND_QUIETLY)
		MESSAGE(STATUS "  libraries : ${OGRE_LIBRARIES} from ${OGRE_LIB_DIR}")
		MESSAGE(STATUS "  includes  : ${OGRE_INCLUDE_DIR}")
	ENDIF (NOT OGRE_FIND_QUIETLY)
ELSE (OGRE_FOUND)
	IF (OGRE_FIND_REQUIRED)
		MESSAGE(FATAL_ERROR "Could not find OGRE")
	ENDIF (OGRE_FIND_REQUIRED)
ENDIF (OGRE_FOUND)

CMAKE_POLICY(POP)
