#include "Src/Header/SerialPortScanner.h"
#include <QSerialPortInfo>
#include <QDebug>

SerialPortScanner::SerialPortScanner(QObject *parent)
    : QObject(parent)
{
    m_availablePorts.clear();

    scanPortsInBackground();
}

QStringList SerialPortScanner::availablePorts() const
{
    return m_availablePorts;
}

void SerialPortScanner::scanPorts()
{
    QtConcurrent::run([this]() { scanPortsInBackground(); });
}

void SerialPortScanner::scanPortsInBackground()
{
    QStringList newPorts;
    QList<QSerialPortInfo> ports = QSerialPortInfo::availablePorts();

    for (const QSerialPortInfo &port : ports) {
        newPorts.append(port.portName());
    }

    if (newPorts != m_availablePorts) {
        m_availablePorts = newPorts;

        QMetaObject::invokeMethod(this, [this]() {
            emit availablePortsChanged();
        }, Qt::QueuedConnection);
    }
}
