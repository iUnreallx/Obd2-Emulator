#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QLocale>
#include <Src/Header/SerialPortScanner.h>
#include <Src/Header/SerialPortConnector.h>


int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;

    QCoreApplication::setOrganizationName("Unreallx.foundation");
    QCoreApplication::setOrganizationDomain("github-iUnreallx.com");
    QCoreApplication::setApplicationName("Obd2-Emulator");

    SerialPortScanner comPort;
    engine.rootContext()->setContextProperty("comPort", &comPort);

    SerialPortConnector comConnector;
    engine.rootContext()->setContextProperty("comConnector", &comConnector);

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Obd2-Emulator", "Main");



    return app.exec();
}
