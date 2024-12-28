include_directories(
    ${CMAKE_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${OCC_INCLUDE_DIR}
    ${ZLIB_INCLUDE_DIR}
    ${PYTHON_INCLUDE_DIRS}
    ${XercesC_INCLUDE_DIRS}
)
link_directories(${OCC_LIBRARY_DIR})

set(Drawing_LIBS
    Part
    Spreadsheet
    FreeCADApp
)

SET(Features_SRCS
    FeaturePage.cpp
    FeaturePage.h
    FeatureProjection.cpp
    FeatureProjection.h
    FeatureView.cpp
    FeatureView.h
    FeatureViewPart.cpp
    FeatureViewPart.h
    FeatureViewAnnotation.cpp
    FeatureViewAnnotation.h
    FeatureViewSymbol.cpp
    FeatureViewSymbol.h
    FeatureClip.cpp
    FeatureClip.h
    PageGroup.cpp
    PageGroup.h
    FeatureViewSpreadsheet.cpp
    FeatureViewSpreadsheet.h
)

SET(Drawing_SRCS
    AppDrawing.cpp
    AppDrawingPy.cpp
    PreCompiled.h
)

SET(DrawingAlgos_SRCS
    DrawingExport.cpp
    DrawingExport.h
    ProjectionAlgos.cpp
    ProjectionAlgos.h
)

SOURCE_GROUP("Mod" FILES ${Drawing_SRCS})
SOURCE_GROUP("Features" FILES ${Features_SRCS})
SOURCE_GROUP("Algorithms" FILES ${DrawingAlgos_SRCS})

SET(DrawingComplete_SRCS
    ${Drawing_SRCS}
    ${DrawingAlgos_SRCS}
    ${Features_SRCS}
)

add_library(Drawing SHARED ${Drawing_SRCS} ${Features_SRCS} ${DrawingAlgos_SRCS})

if(FREECAD_USE_PCH)
    target_precompile_headers(Drawing PRIVATE
            $<$<COMPILE_LANGUAGE:CXX>:"PreCompiled.h">
    )
endif(FREECAD_USE_PCH)

target_link_libraries(Drawing ${Drawing_LIBS})
if (FREECAD_WARN_ERROR)
    target_compile_warn_error(Drawing)
endif()

SET_BIN_DIR(Drawing Drawing /Mod/Drawing)
SET_PYTHON_PREFIX_SUFFIX(Drawing)

INSTALL(TARGETS Drawing DESTINATION ${CMAKE_INSTALL_LIBDIR})
