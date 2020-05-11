if(MSVC)
    add_definitions(-DHAVE_PART -DHAVE_ACOSH -DHAVE_ATANH -DHAVE_ASINH)
else(MSVC)
    add_definitions(-DHAVE_PART -DHAVE_LIMITS_H -DHAVE_CONFIG_H)
endif(MSVC)

include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${CMAKE_SOURCE_DIR}/src/Gui
    ${OCC_INCLUDE_DIR}
)

link_directories(${OCC_LIBRARY_DIR})

set(SandboxGui_LIBS
    Sandbox
    Part
    FreeCADGui
)

set(SandboxGui_MOC_HDRS
    GLGraphicsView.h
)

fc_wrap_cpp(SandboxGui_MOC_SRCS ${SandboxGui_MOC_HDRS})
SOURCE_GROUP("Moc" FILES ${SandboxGui_MOC_SRCS})

if(BUILD_QT5)
    qt5_add_resources(Resource_SRCS Resources/Sandbox.qrc)
else()
    qt4_add_resources(Resource_SRCS Resources/Sandbox.qrc)
endif()
SET(Resource_SRCS
    ${Resource_SRCS}
    Resources/Sandbox.qrc
)
SOURCE_GROUP("Resource" FILES ${Resource_SRCS})

SET(SandboxGui_SRCS
    AppSandboxGui.cpp
    Command.cpp
    GLGraphicsView.cpp
    GLGraphicsView.h
    Overlay.cpp
    Overlay.h
    PreCompiled.cpp
    PreCompiled.h
    TaskPanelView.cpp
    TaskPanelView.h
    Workbench.cpp
    Workbench.h
)

set (SandboxGui_Scripts
    ../InitGui.py
)

add_library(SandboxGui SHARED ${SandboxGui_SRCS} ${SandboxGui_Scripts})
target_link_libraries(SandboxGui
    PUBLIC
        ${SandboxGui_LIBS}
    PRIVATE
        Boost::boost
        Boost::thread
        Coin::Coin
)

if(BUILD_QT5)
    target_link_libraries(SandboxGui
        PRIVATE
            Qt5::Concurrent
            Qt5::Core
            Qt5::Widgets
    )
else()
    target_link_libraries(SandboxGui
        PRIVATE
            Qt4::QtCore
            Qt4::QtGui
    )
endif()

fc_target_copy_resource_flat(SandboxGui
    ${CMAKE_CURRENT_SOURCE_DIR}
    ${CMAKE_BINARY_DIR}/Mod/Sandbox
    ${SandboxGui_Scripts})

SET_BIN_DIR(SandboxGui SandboxGui /Mod/Sandbox)
SET_PYTHON_PREFIX_SUFFIX(SandboxGui)

INSTALL(TARGETS SandboxGui DESTINATION ${CMAKE_INSTALL_LIBDIR})
