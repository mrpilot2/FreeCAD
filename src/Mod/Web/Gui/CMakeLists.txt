include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
)

if (Qt5WebEngineWidgets_FOUND)
    add_definitions(-DQTWEBENGINE)
elseif(Qt5WebKitWidgets_FOUND OR QT_QTWEBKIT_FOUND) # Qt5 and Qt4
    add_definitions(-DQTWEBKIT)
endif()

set(WebGui_LIBS
    FreeCADGui
)

if(BUILD_QT5)
    if(Qt5WebEngineWidgets_FOUND)
        list(APPEND WebGui_LIBS Qt5::WebEngineWidgets)
    else()
        list(APPEND WebGui_LIBS Qt5::WebKitWidgets)
    endif()
    qt5_add_resources(Web_QRC_SRCS Resources/Web.qrc)
else()
    qt4_add_resources(Web_QRC_SRCS Resources/Web.qrc)
endif()

SET(WebGui_SRCS
    ${Web_QRC_SRCS}
    AppWebGui.cpp
    Command.cpp
    PreCompiled.cpp
    PreCompiled.h
    Workbench.cpp
    Workbench.h
    BrowserView.h
    BrowserView.cpp
    CookieJar.cpp   # QWebkit only
    CookieJar.h     # QWebkit only
)

set(WebGui_MOC_HDRS
    BrowserView.h
    CookieJar.h
)
fc_wrap_cpp(WebGui_MOC_SRCS ${WebGui_MOC_HDRS})
SOURCE_GROUP("Moc" FILES ${SketcherGui_MOC_SRCS})

SET(WebGuiIcon_SVG
    Resources/icons/WebWorkbench.svg
)

add_library(WebGui SHARED ${WebGui_SRCS} ${WebGuiIcon_SVG})
target_link_libraries(WebGui PUBLIC ${WebGui_LIBS})

if(BUILD_QT5)
    target_link_libraries(WebGui
        PUBLIC
            Qt5::Core
            Qt5::Network
            Qt5::Widgets
        )
else()
    target_link_libraries(WebGui
        PUBLIC
            Qt4::QtCore
            Qt4::QtGui
            Qt4::QtNetwork
    )
endif()

SET_BIN_DIR(WebGui WebGui /Mod/Web)
SET_PYTHON_PREFIX_SUFFIX(WebGui)

fc_copy_sources(WebGui "${CMAKE_BINARY_DIR}/${CMAKE_INSTALL_DATADIR}/Mod/Web" ${WebGuiIcon_SVG})

INSTALL(TARGETS WebGui DESTINATION ${CMAKE_INSTALL_LIBDIR})

INSTALL(FILES ${WebGuiIcon_SVG} DESTINATION "${CMAKE_INSTALL_DATADIR}/Mod/Web/Resources/icons")
