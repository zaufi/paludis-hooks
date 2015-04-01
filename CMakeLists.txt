# "Build" script for my paludis-hooks package
# Copyright 2012-2013 by Alex Turbov <i.zaufi@gmail.com>
#

cmake_minimum_required(VERSION 2.6)
project(paludis-hooks NONE)

set(PH_VERSION "1.1")

# seek for xmllint to validate our XML files
find_program(XMLLINT_EXECUTABLE xmllint)
# check if xsltproc is even installed
find_program(XSLTPROC_EXECUTABLE xsltproc)
if(NOT XSLTPROC_EXECUTABLE)
  message(FATAL_ERROR "xsltproc executable required for this package")
endif()
if(NOT XMLLINT_EXECUTABLE)
  message(FATAL_ERROR "xmllint executable required for this package")
endif()
find_package(PythonInterp)
if(NOT PYTHONINTERP_FOUND)
    message(STATUS "Python scripts will not be installed")
endif()

# Define install destination dirs
# ATTENTION Define CMAKE_SIZEOF_VOID_P to some not important value
# to suppress a warning from GNUInstallDirs...
set(CMAKE_SIZEOF_VOID_P 8)
include(GNUInstallDirs)

# Setup package paths
set(PH_PREFIX         "${CMAKE_INSTALL_PREFIX}")
set(PH_BINDIR         "${CMAKE_INSTALL_FULL_BINDIR}")
set(PH_LIBEXECDIR     "${CMAKE_INSTALL_FULL_LIBEXECDIR}/paludis-hooks")
set(PH_DATAROOTDIR    "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks")
set(PH_DOCSDIR        "${CMAKE_INSTALL_FULL_DOCDIR}")
if(${PH_PREFIX} MATCHES "/usr")
    set(PH_SYSCONFDIR    "/etc")
    set(PH_LOCALSTATEDIR "/var")
else()
    set(PH_SYSCONFDIR    "${CMAKE_INSTALL_FULL_SYSCONFDIR}")
    set(PH_LOCALSTATEDIR "${CMAKE_INSTALL_FULL_LOCALSTATEDIR}")
endif()
set(PH_PALUDISCONFDIR "${PH_SYSCONFDIR}/paludis")
set(PH_HOOKSCONFDIR   "${PH_PALUDISCONFDIR}/hooks/configs")
set(PH_PROFILEDIR     "${PH_SYSCONFDIR}/profile.d")
set(PH_ENVDIR         "${PH_SYSCONFDIR}/env.d")
# NOTE Hardcoded nowadays! Dunno is there any reason to detect it...
set(PH_COMMANDSDIR    "/usr/libexec/cave/commands")

# Autopatch hook
configure_file(auto-patch/auto-patch.bash.in auto-patch/auto-patch.bash @ONLY)
configure_file(auto-patch/auto-patch.conf.in auto-patch/auto-patch.conf @ONLY)
install(
    PROGRAMS ${CMAKE_BINARY_DIR}/auto-patch/auto-patch.bash
    DESTINATION ${PH_DATAROOTDIR}
  )
install(
    FILES ${CMAKE_BINARY_DIR}/auto-patch/auto-patch.conf
    DESTINATION ${PH_HOOKSCONFDIR}
  )

# Filesystem manager hook
set(FILESYSTEM_MANAGER_DTD "${PH_DATAROOTDIR}/filesystem-manager/filesystem-manager.dtd")
set(FILESYSTEM_MANAGER_XSL "${PH_DATAROOTDIR}/filesystem-manager/filesystem-manager.xsl")
configure_file(filesystem-manager/filesystem-manager.conf.in filesystem-manager/filesystem-manager.conf @ONLY)
configure_file(filesystem-manager/filesystem-manager.bash.in filesystem-manager/filesystem-manager.bash @ONLY)
install(
    PROGRAMS ${CMAKE_BINARY_DIR}/filesystem-manager/filesystem-manager.bash
    DESTINATION ${PH_DATAROOTDIR}
  )
install(
    FILES ${CMAKE_BINARY_DIR}/filesystem-manager/filesystem-manager.conf
    DESTINATION ${PH_HOOKSCONFDIR}
  )
install(
    FILES filesystem-manager/filesystem-manager.xsl
    DESTINATION ${PH_DATAROOTDIR}/filesystem-manager
  )
install(
    FILES filesystem-manager/filesystem-manager.dtd
    DESTINATION ${PH_DATAROOTDIR}/filesystem-manager
  )
install(
    DIRECTORY filesystem-manager/commands
    DESTINATION ${PH_DATAROOTDIR}/filesystem-manager
  )

# Package environment configurator
configure_file(package.env/setup_pkg_env.bash.in package.env/setup_pkg_env.bash @ONLY)
install(
    FILES ${CMAKE_BINARY_DIR}/package.env/setup_pkg_env.bash
    DESTINATION ${PH_LIBEXECDIR}
  )
install(
    FILES
        package.env/no-debug.conf
        package.env/no-lto.conf
        package.env/extra-optimize.conf
        package.env/use-bfd-linker.conf
    DESTINATION ${PH_PALUDISCONFDIR}/env.conf.d
  )

# In Memory Build hook
configure_file(workdir-tmpfs/workdir-tmpfs.bash.in workdir-tmpfs/workdir-tmpfs.bash @ONLY)
configure_file(workdir-tmpfs/workdir-tmpfs.conf.in workdir-tmpfs/workdir-tmpfs.conf @ONLY)

install(
    PROGRAMS ${CMAKE_BINARY_DIR}/workdir-tmpfs/workdir-tmpfs.bash
    DESTINATION ${PH_DATAROOTDIR}
  )
install(
    FILES ${CMAKE_BINARY_DIR}/workdir-tmpfs/workdir-tmpfs.conf
    DESTINATION ${PH_HOOKSCONFDIR}
  )

# Some other helpers...
install(
    FILES profile.d/00-make-completion-wrapper.sh profile.d/cave-aliases.sh
    DESTINATION ${PH_PROFILEDIR}
  )
install(
    FILES env.d/90cave
    DESTINATION ${PH_ENVDIR}
  )

if(PYTHONINTERP_FOUND)
    install(
        PROGRAMS print-ebuild-path
        DESTINATION ${PH_COMMANDSDIR}
      )
    install(
        FILES profile.d/cave-addons.sh
        DESTINATION ${PH_PROFILEDIR}
      )
endif()

# Docs (not much)
install(
    FILES README.md
    DESTINATION ${PH_DOCSDIR}
  )
