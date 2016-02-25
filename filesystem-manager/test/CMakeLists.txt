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
    set(_aft_expected_output "${CMAKE_CURRENT_SOURCE_DIR}/${directory}/expected.output")

    configure_file("${directory}/input.xml.in" "${directory}/input.xml")
    configure_file("exec-transform.cmake.in" "${directory}/exec-transform.cmake")
    configure_file("run-test.cmake.in" "${directory}/run-test.cmake")
    configure_file("update-expected-output.cmake.in" "${directory}/update-expected-output.cmake")

    list(
        APPEND ADDITIONAL_MAKE_CLEAN_FILES
        "${_aft_output_test_conf}"
      )

    add_test(
        NAME ${directory}
        COMMAND "${CMAKE_COMMAND}" -P "${CMAKE_CURRENT_BINARY_DIR}/${directory}/run-test.cmake"
      )

    add_custom_target(
        update-${directory}-expectations
        COMMAND "${CMAKE_COMMAND}" -P "${_aft_working_directory}/update-expected-output.cmake"
        COMMENT "Update test output expectations at test directory: ${CMAKE_CURRENT_SOURCE_DIR}/${directory}"
      )
endmacro()

if(DIFF_EXECUTABLE)
    add_fsm_test(matching)
    add_fsm_test(matching-partial)
    add_fsm_test(commands-renderer)
else()
    message(STATUS "WARNING: `diff` was not found. Do not add FSM unit tests...")
endif()
