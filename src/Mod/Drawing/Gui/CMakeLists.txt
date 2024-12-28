include_directories(
    ${CMAKE_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}/src
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${COIN3D_INCLUDE_DIRS}
    ${PYTHON_INCLUDE_DIRS}
    ${OCC_INCLUDE_DIR}
    ${ZLIB_INCLUDE_DIR}
    ${XercesC_INCLUDE_DIRS}
)
link_directories(${OCC_LIBRARY_DIR})

set(DrawingGui_LIBS
    Drawing
    FreeCADGui
)

set(DrawingGui_UIC_SRCS
    TaskOrthoViews.ui
)

set (Drawing_TR_QRC ${CMAKE_CURRENT_BINARY_DIR}/Resources/Drawing_translation.qrc)
qt_find_and_add_translation(QM_SRCS "Resources/translations/*_*.ts"
    ${CMAKE_CURRENT_BINARY_DIR}/Resources/translations)
qt_create_resource_file(${Drawing_TR_QRC} ${QM_SRCS})
qt_add_resources(DrawingGui_SRCS Resources/Drawing.qrc ${Drawing_TR_QRC})

SET(DrawingGui_SRCS
    ${DrawingGui_SRCS}
    ${QM_SRCS}
    ${Drawing_TR_QRC}
    AppDrawingGui.cpp
    AppDrawingGuiPy.cpp
    Command.cpp
    Resources/Drawing.qrc
    PreCompiled.h
    TaskDialog.cpp
    TaskDialog.h
    TaskOrthoViews.ui
    TaskOrthoViews.cpp
    TaskOrthoViews.h
    Workbench.cpp
    Workbench.h
)
SET(DrawingGuiView_SRCS
    DrawingView.cpp
    DrawingView.h
)
SET(DrawingGuiViewProvider_SRCS
    ViewProviderPage.cpp
    ViewProviderPage.h
    ViewProviderView.cpp
    ViewProviderView.h
)

SOURCE_GROUP("Mod" FILES ${DrawingGui_SRCS})
SOURCE_GROUP("SVG-View" FILES ${DrawingGuiView_SRCS})
SOURCE_GROUP("ViewProvider" FILES ${DrawingGuiViewProvider_SRCS})

SET(DrawingGuiTaskDlgs_SRCS
    TaskOrthoViews.ui
)
SOURCE_GROUP("TaskDialogs" FILES ${DrawingGuiTaskDlgs_SRCS})

SET(DrawingGuiComplete_SRCS
    ${DrawingGui_SRCS}
    ${DrawingGuiView_SRCS}
    ${DrawingGuiViewProvider_SRCS}
)

SET(DrawingGuiIcon_SVG
    Resources/icons/DrawingWorkbench.svg
)

add_library(DrawingGui SHARED ${DrawingGui_SRCS} ${DrawingGuiView_SRCS}
                              ${DrawingGuiViewProvider_SRCS} ${DrawingGuiIcon_SVG})
if(FREECAD_USE_PCH)
    target_precompile_headers(DrawingGui PRIVATE
            $<$<COMPILE_LANGUAGE:CXX>:"PreCompiled.h">
    )
endif(FREECAD_USE_PCH)

target_link_libraries(DrawingGui ${DrawingGui_LIBS})
if (FREECAD_WARN_ERROR)
    target_compile_warn_error(DrawingGui)
endif()


SET_BIN_DIR(DrawingGui DrawingGui /Mod/Drawing)
SET_PYTHON_PREFIX_SUFFIX(DrawingGui)

fc_copy_sources(DrawingGui "${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_DATADIR}/Mod/Drawing" ${DrawingGuiIcon_SVG})

INSTALL(TARGETS DrawingGui DESTINATION ${CMAKE_INSTALL_LIBDIR})
INSTALL(FILES ${DrawingGuiIcon_SVG} DESTINATION "${CMAKE_INSTALL_DATADIR}/Mod/Drawing/Resources/icons")
