#!/bin/sh

basedir=$( cd $(dirname "$0");pwd)
cd "${basedir}"
rm -rf CMakeCache.txt CMakeFiles cmake_install.cmake Makefile external-auth

