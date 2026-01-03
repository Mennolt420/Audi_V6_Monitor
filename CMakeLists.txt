cmake_minimum_required(VERSION 3.16)

project(Audi_V6_Monitor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Location Positioning)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appAudi_V6_Monitor
    main.cpp
)

qt_add_qml_module(appAudi_V6_Monitor
    URI Audi_V6_Monitor
    VERSION 1.0
    QML_FILES
        Main.qml
        AudiGauge.qml
        InfoBackground.qml
        TopBar.qml
        TabCar.qml
        TabMedia.qml
        TabNavigation.qml
    RESOURCES
        # --- AUDI FONTS (Normal & Bold) ---
        "assets/Audi_Type_Digital_20210706/Audi Type Digital/AudiType v4.03 TrueType OpenType/AudiType-Normal_4.03.ttf"
        "assets/Audi_Type_Digital_20210706/Audi Type Digital/AudiType v4.03 TrueType OpenType/AudiType-Bold_4.03.ttf"

        # --- AUDI RINGS (White) ---
        "assets/Audi-Rings-Digital_RGB/Web_RGB/Audi_Rings_Standard/Audi_Rings_wh-RGB.png"
    DEPENDENCIES
        QtQuick
        QtQuick.Controls
        QtQuick.Layouts
        QtQuick.Shapes
        QtQuick.Effects
        QtLocation
        QtPositioning
)

set_target_properties(appAudi_V6_Monitor PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appAudi_V6_Monitor
    PRIVATE
    Qt6::Quick
    Qt6::Location
    Qt6::Positioning
)

include(GNUInstallDirs)
install(TARGETS appAudi_V6_Monitor
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
