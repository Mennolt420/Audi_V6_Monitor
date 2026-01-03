#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _qt_qml_Audi_V6_Monitor_Main_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_Audi_V6_Monitor_AudiGauge_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_Audi_V6_Monitor_InfoBackground_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_Audi_V6_Monitor_TopBar_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_Audi_V6_Monitor_TabCar_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_Audi_V6_Monitor_TabMedia_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _qt_qml_Audi_V6_Monitor_TabNavigation_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/Audi_V6_Monitor/Main.qml"), &QmlCacheGeneratedCode::_qt_qml_Audi_V6_Monitor_Main_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/Audi_V6_Monitor/AudiGauge.qml"), &QmlCacheGeneratedCode::_qt_qml_Audi_V6_Monitor_AudiGauge_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/Audi_V6_Monitor/InfoBackground.qml"), &QmlCacheGeneratedCode::_qt_qml_Audi_V6_Monitor_InfoBackground_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/Audi_V6_Monitor/TopBar.qml"), &QmlCacheGeneratedCode::_qt_qml_Audi_V6_Monitor_TopBar_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/Audi_V6_Monitor/TabCar.qml"), &QmlCacheGeneratedCode::_qt_qml_Audi_V6_Monitor_TabCar_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/Audi_V6_Monitor/TabMedia.qml"), &QmlCacheGeneratedCode::_qt_qml_Audi_V6_Monitor_TabMedia_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/qt/qml/Audi_V6_Monitor/TabNavigation.qml"), &QmlCacheGeneratedCode::_qt_qml_Audi_V6_Monitor_TabNavigation_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appAudi_V6_Monitor)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appAudi_V6_Monitor))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_appAudi_V6_Monitor)() {
    return 1;
}
