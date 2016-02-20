set(FILESYSTEM_MANAGER_DTD "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks/filesystem-manager/filesystem-manager.dtd")
set(FILESYSTEM_MANAGER_XSL "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks/filesystem-manager/filesystem-manager.xsl")

configure_file(filesystem-manager.conf.in filesystem-manager.conf @ONLY)
configure_file(filesystem-manager.bash.in filesystem-manager.bash @ONLY)

install(
    PROGRAMS "${CMAKE_CURRENT_BINARY_DIR}/filesystem-manager.bash"
    DESTINATION "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks"
    )
install(
    FILES "${CMAKE_CURRENT_BINARY_DIR}/filesystem-manager.conf"
    DESTINATION "${CMAKE_INSTALL_FULL_SYSCONFDIR}/paludis/hooks/configs"
    )
install(
    FILES
        filesystem-manager.xsl
        filesystem-manager.dtd
    DESTINATION "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks/filesystem-manager"
    )
install(
    DIRECTORY commands
    DESTINATION "${CMAKE_INSTALL_FULL_DATAROOTDIR}/paludis-hooks/filesystem-manager"
    )
