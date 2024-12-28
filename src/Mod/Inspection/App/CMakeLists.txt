include_directories(
    ${CMAKE_BINARY_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${OCC_INCLUDE_DIR}
    ${PYTHON_INCLUDE_DIRS}
    ${ZLIB_INCLUDE_DIR}
    ${XercesC_INCLUDE_DIRS}
)

link_directories(${OCC_LIBRARY_DIR})

set(Inspection_LIBS
    FreeCADApp
    Mesh
    Points
    Part
)

SET(Inspection_SRCS
    AppInspection.cpp
    InspectionFeature.cpp
    InspectionFeature.h
    PreCompiled.h
)

set(Inspection_Scripts
    ../Init.py
)

add_library(Inspection SHARED ${Inspection_SRCS} ${Inspection_Scripts})

if(FREECAD_USE_PCH)
    target_precompile_headers(Inspection PRIVATE
            $<$<COMPILE_LANGUAGE:CXX>:"PreCompiled.h">
    )
endif(FREECAD_USE_PCH)

target_link_libraries(Inspection ${Inspection_LIBS})
if (FREECAD_WARN_ERROR)
    target_compile_warn_error(Inspection)
endif()

fc_target_copy_resource_flat(Inspection
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_BINARY_DIR}/Mod/Inspection
    ${Inspection_Scripts}
)

SET_BIN_DIR(Inspection Inspection /Mod/Inspection)
SET_PYTHON_PREFIX_SUFFIX(Inspection)

INSTALL(TARGETS Inspection DESTINATION ${CMAKE_INSTALL_LIBDIR})
