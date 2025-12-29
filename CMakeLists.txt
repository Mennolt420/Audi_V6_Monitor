cmake_minimum_required(VERSION 3.16)

project(Audi_V6_Monitor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appAudi_V6_Monitor
    main.cpp
)

qt_add_qml_module(appAudi_V6_Monitor
    URI Audi_V6_Monitor
    QML_FILES
        Main.qml
        DEPENDENCIES QtQuick.Controls
        DEPENDENCIES QtQuick.Layouts
        DEPENDENCIES QtQuick.Shapes
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appAudi_V6_Monitor PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appAudi_V6_Monitor
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appAudi_V6_Monitor
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appAudi_V6_Monitor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
