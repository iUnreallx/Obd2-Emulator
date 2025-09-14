// SerialPortWorker.cpp
#include "Src/Header/SerialPortWorker.h"
#include <QElapsedTimer>
#include <QDebug>


SerialPortWorker::SerialPortWorker(QObject *parent)
    : QObject(parent), serial(new QSerialPort(this))
{
    connect(serial, &QSerialPort::readyRead, this, &SerialPortWorker::handleReadyRead);
    connect(serial, &QSerialPort::errorOccurred, this, [this](QSerialPort::SerialPortError error) {
        if (error != QSerialPort::NoError) {
            emit errorOccurred(serial->errorString());
        }
    });
}

SerialPortWorker::~SerialPortWorker()
{
    closePort();
}

void SerialPortWorker::openPort(const QString &portName)
{
    QElapsedTimer timer;
    timer.start();

    if (serial->isOpen()) {
        serial->close();
    }

    serial->setPortName(portName);
    serial->setBaudRate(QSerialPort::Baud9600);
    serial->setDataBits(QSerialPort::Data8);
    serial->setParity(QSerialPort::NoParity);
    serial->setStopBits(QSerialPort::OneStop);
    serial->setFlowControl(QSerialPort::NoFlowControl);

    bool opened = serial->open(QIODevice::ReadWrite);

    qint64 elapsedTime = timer.elapsed();
    qDebug() << "порт отрктыт за: " << elapsedTime << " мс";

    emit portOpened(opened);
}

void SerialPortWorker::closePort()
{
    if (serial->isOpen()) {
        serial->close();
        qDebug() << "COM port закрыт";
    }
}

void SerialPortWorker::handleReadyRead()
{
    QByteArray data = serial->readAll();
    if (!data.isEmpty()) {
        QByteArray trimmedData = data.trimmed();
        qDebug() << "Полученные данны obd: " << trimmedData;

        if (trimmedData == "ATZ") {
            serial->write("OBD2 Emulator by Unreallx\r");
            qDebug() << "Sent: OK for ATZ";
        } else if (trimmedData == "ATE0") {
            serial->write("OK\r");
            qDebug() << "Sent: OK for ATE0";
        } else if (trimmedData == "ATL0") {
            serial->write("OK\r");
            qDebug() << "Sent: OK for ATL0";
        } else if (trimmedData == "ATH0") {
            serial->write("OK\r");
            qDebug() << "Sent: OK for ATH0";
        } else if (trimmedData == "ATSP0") {
            serial->write("OK\r");
            qDebug() << "Sent: OK for ATSP0";
        } else if (trimmedData == "010D") {
            QString response = QString("41 0D %1").arg(m_speed, 2, 16, QChar('0')).toUpper();
            serial->write(response.toLatin1() + "\r");
            qDebug() << "Отправил: " << response;
        }

        emit dataReceived(trimmedData);
    }
}

void SerialPortWorker::changeSpeedToOBD(int speed)
{
    m_speed = speed;
}
