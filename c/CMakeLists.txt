cmake_minimum_required (VERSION 2.6)
project (psfmo-external-auth-driver-tests-c)

# Find the MongoDB C library locations

FIND_PATH(MONGOC_INCLUDE_DIR NAMES mongoc.h
      PATHS /usr/include /usr/include/libmongoc-1.0 /usr/local/include /usr/local/include/libmongoc-1.0
            $ENV{HOME}/mongoc/include/libmongoc-1.0
      )

FIND_LIBRARY(MONGOC_LIBRARY NAMES mongoc-1.0 PATHS /lib /usr/lib /usr/local/lib $ENV{HOME}/mongoc/lib)

IF (MONGOC_INCLUDE_DIR AND MONGOC_LIBRARY)
    MESSAGE(STATUS "mongoc Include dir: ${MONGOC_INCLUDE_DIR}")
    MESSAGE(STATUS "libmongoc library: ${MONGOC_LIBRARY}")
ELSE()
    MESSAGE(FATAL_ERROR "Cannot find libmongoc library")
ENDIF()

FIND_PATH(BSON_INCLUDE_DIR NAMES bson.h
  PATHS /usr/include /usr/include/libbson-1.0 /usr/local/include /usr/local/include/libbson-1.0 
  $ENV{HOME}/mongoc/include/libbson-1.0)

FIND_LIBRARY(BSON_LIBRARY NAMES bson-1.0 PATHS /lib /usr/lib /usr/local/lib $ENV{HOME}/mongoc/lib)

IF (BSON_INCLUDE_DIR AND BSON_LIBRARY)
    MESSAGE(STATUS "bson Include dir: ${BSON_INCLUDE_DIR}")
    MESSAGE(STATUS "libbson library: ${BSON_LIBRARY}")
ELSE()
    MESSAGE(FATAL_ERROR "Cannot find libbson library")
ENDIF()

include_directories(${MONGOC_INCLUDE_DIR})
include_directories(${BSON_INCLUDE_DIR})

# executable

add_executable(external-auth external-auth.c)

target_link_libraries(external-auth ${MONGOC_LIBRARY})

target_link_libraries(external-auth ${BSON_LIBRARY})

