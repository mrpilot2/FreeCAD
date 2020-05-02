macro(SetupEigen)
# -------------------------------- Eigen --------------------------------

    # necessary for Sketcher module
    # necessary for Robot module

    find_package(Eigen3)
    if(NOT EIGEN3_FOUND)
        message("=================\n"
                "Eigen3 not found.\n"
                "=================\n")
    endif(NOT EIGEN3_FOUND)

    # on Xenial Eigen provides it's own CMake config files, but no
    # target. For unified usage it's created here
    if (NOT TARGET Eigen3::Eigen)
        add_library(Eigen3::Eigen INTERFACE IMPORTED)

        set_target_properties(Eigen3::Eigen PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${EIGEN3_INCLUDE_DIRS}"
        )
    endif()

    if (${EIGEN3_VERSION_STRING} VERSION_LESS "3.3.1")
        message(WARNING "Disable module flatmesh because it requires "
                        "minimum Eigen3 version 3.3.1 but version ${EIGEN3_VERSION_STRING} was found")
        set (BUILD_FLAT_MESH OFF)
    endif()

endmacro(SetupEigen)
