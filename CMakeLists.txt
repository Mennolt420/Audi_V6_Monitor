cmake_minimum_required(VERSION 3.16)

project(Audi_V6_Monitor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. VOEG Location EN Positioning TOE
find_package(Qt6 REQUIRED COMPONENTS Quick Location Positioning)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appAudi_V6_Monitor
    main.cpp
)

qt_add_qml_module(appAudi_V6_Monitor
    URI Audi_V6_Monitor
    QML_FILES
        Main.qml
        AudiGauge.qml
        InfoBackground.qml
        TopBar.qml
        TabCar.qml
        TabMedia.qml
        TabNavigation.qml
        DEPENDENCIES QtQuick.Controls
        DEPENDENCIES QtQuick.Layouts
        DEPENDENCIES QtQuick.Shapes
)

# ... (rest van de macOS settings blijven hetzelfde)

target_link_libraries(appAudi_V6_Monitor
    PRIVATE Qt6::Quick
    Qt6::Location
    Qt6::Positioning
)

include(GNUInstallDirs)
install(TARGETS appAudi_V6_Monitor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
