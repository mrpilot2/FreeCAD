
include_directories(
    ${CMAKE_CURRENT_BINARY_DIR}
    ${OCC_INCLUDE_DIR}
)

set(Web_MOC_HDRS
    Server.h
)
fc_wrap_cpp(Web_MOC_SRCS ${Web_MOC_HDRS})
SOURCE_GROUP("Moc" FILES ${Web_MOC_SRCS})

SET(Web_SRCS
    AppWeb.cpp
    PreCompiled.cpp
    PreCompiled.h
    Server.cpp
    Server.h
)

add_library(Web SHARED ${Web_SRCS})
target_link_libraries(Web PUBLIC FreeCADApp)

if(BUILD_QT5)
    target_link_libraries(Web
        PUBLIC
            Qt5::Core
            Qt5::Network
    )
else()
    target_link_libraries(Web
        PUBLIC
            Qt4::QtCore
            Qt4::QtNetwork
    )
endif()

SET_BIN_DIR(Web Web /Mod/Web)
SET_PYTHON_PREFIX_SUFFIX(Web)

install(TARGETS Web DESTINATION ${CMAKE_INSTALL_LIBDIR})
