#include "Src/Header/SerialPortConnector.h"
#include "Src/Header/SerialPortWorker.h"
#include <QDebug>
#include <QThread>

SerialPortConnector::SerialPortConnector(QObject *parent)
    : QObject(parent), workerThread(new QThread(this)), worker(new SerialPortWorker())
{
    worker->moveToThread(workerThread);

    connect(worker, &SerialPortWorker::errorOccurred, this, [] (const QString &error) {
        qDebug() << "Error:" << error;
    });

    workerThread->start();
}

SerialPortConnector::~SerialPortConnector()
{
    closePort();
    workerThread->quit();
    workerThread->wait();
    delete worker;
}

void SerialPortConnector::openPort(const QString &portName)
{
    QMetaObject::invokeMethod(worker, "openPort", Qt::QueuedConnection, Q_ARG(QString, portName));

    connect(worker, &SerialPortWorker::portOpened, this, [this](bool success) {
        if (success) {
            qDebug() << "Port opened successfully.";
        } else {
            qDebug() << "Failed to open port.";
        }
        emit connectionResult(success);
        disconnect(worker, &SerialPortWorker::portOpened, this, nullptr);
    });
}

void SerialPortConnector::closePort()
{
    QMetaObject::invokeMethod(worker, "closePort", Qt::QueuedConnection);
}

// --- БЕЗОПАСНАЯ ПЕРЕДАЧА ДАННЫХ В ПОТОК ---

void SerialPortConnector::changeSpeedToOBD(int speed)
{
    QMetaObject::invokeMethod(worker, "changeSpeedToOBD", Qt::QueuedConnection, Q_ARG(int, speed));
}

void SerialPortConnector::changeRpmToOBD(int rpm)
{
    QMetaObject::invokeMethod(worker, "changeRpmToOBD", Qt::QueuedConnection, Q_ARG(int, rpm));
}

void SerialPortConnector::changeTempToOBD(int temp)
{
    QMetaObject::invokeMethod(worker, "changeTempToOBD", Qt::QueuedConnection, Q_ARG(int, temp));
}

void SerialPortConnector::changeVoltageToOBD(double voltage)
{
    QMetaObject::invokeMethod(worker, "changeVoltageToOBD", Qt::QueuedConnection, Q_ARG(double, voltage));
}
