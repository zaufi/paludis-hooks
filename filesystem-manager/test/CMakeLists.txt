set(FILESYSTEM_MANAGER_DTD "${PROJECT_SOURCE_DIR}/filesystem-manager/filesystem-manager.dtd")
set(FILESYSTEM_MANAGER_XSL "${PROJECT_SOURCE_DIR}/filesystem-manager/filesystem-manager.xsl")

macro(add_fsm_test directory)
    # Preset some variables expected by tests
    set(REPOSITORY "gentoo")
    set(CATEGORY "dev-util")
    set(PN "cmake")
    set(PV "3.4.3")
    set(PR "r1")
    set(PVR "${PV}-${PR}")
    set(P "${PN}-${PV}")
    set(PF "${PN}-${PVR}")
    set(SLOT "0")
    set(D "${CMAKE_CURRENT_BINARY_DIR}/${directory}")
    set(T "${CMAKE_CURRENT_BINARY_DIR}/${directory}")

    # We expect some partucular file in there
    if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${directory}/input.xml.in")
        message(FATAL_ERROR "${CMAKE_CURRENT_SOURCE_DIR}/${directory}/input.xml.in not found")
    endif()

    # Set test specific variables
    set(_aft_input_test_conf "input.xml")
    set(_aft_working_directory "${CMAKE_CURRENT_BINARY_DIR}/${directory}")
    set(_aft_output_test_conf "${_aft_working_directory}/${directory}.output")

    configure_file("${directory}/input.xml.in" "${directory}/input.xml")
    configure_file("exec-transform.cmake.in" "${directory}/exec-transform.cmake")
    configure_file("run-test.cmake.in" "${directory}/run-test.cmake")

    list(
        APPEND ADDITIONAL_MAKE_CLEAN_FILES
        "${CMAKE_CURRENT_BINARY_DIR}/${directory}/${_aft_output_test_conf}"
      )

    add_test(
        NAME ${directory}
        COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${directory}/run-test.cmake"
      )

endmacro()

add_fsm_test(matching)
