cmake_minimum_required(VERSION 3.16)

project(Audi_V6_Monitor VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. Modules laden
find_package(Qt6 REQUIRED COMPONENTS Quick Location Positioning)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appAudi_V6_Monitor
    main.cpp
)

# 2. QML Module definitie met alle dependencies
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
        assets/Titillium_Web/TitilliumWeb-Regular.ttf
        assets/Titillium_Web/TitilliumWeb-Bold.ttf
    DEPENDENCIES
        QtQuick
        QtQuick.Controls
        QtQuick.Layouts
        QtQuick.Shapes
        QtQuick.Effects      # Voor de Glow/Shadows
        QtLocation           # Voor de Kaart
        QtPositioning        # Voor GPS
)

# ... (macOS settings ongewijzigd)
set_target_properties(appAudi_V6_Monitor PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# 3. Libraries linken
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
