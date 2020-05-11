macro(SetupCoin3D)
# -------------------------------- Coin3D --------------------------------
    # at least since Coin 4.0 it provides an exported target, it is also
    # provided in the libpack, we try to find it first, if it does not
    # exist we fallback to the old FindCoin script
    find_package(coin QUIET)

    if (NOT TARGET Coin::Coin)
        find_package(Coin3D REQUIRED)
        if(NOT COIN3D_FOUND)
            message(FATAL_ERROR "=================\n"
                                "Coin3D not found.\n"
                                "=================\n")
        else()
            add_library(Coin::Coin UNKNOWN IMPORTED)
            target_link_libraries(Coin::Coin INTERFACE "${COIN3D_LIBRARIES}")
            set_target_properties(Coin::Coin
                PROPERTIES
                    INTERFACE_INCLUDE_DIRECTORIES "${COIN3D_INCLUDE_DIRS}"
            )
        endif(NOT COIN3D_FOUND)
    endif()
endmacro(SetupCoin3D)
