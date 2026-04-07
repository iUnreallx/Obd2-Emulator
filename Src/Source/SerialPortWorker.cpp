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
    qDebug() << "Порт открыт за: " << elapsedTime << " мс";

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
        qDebug() << "Получен запрос OBD: " << trimmedData;

        // Базовые команды инициализации адаптера
        if (trimmedData == "ATZ") {
            serial->write("ELM327 v1.5\r>");
        } else if (trimmedData == "ATE0" || trimmedData == "ATL0" || trimmedData == "ATH0" || trimmedData == "ATSP0") {
            serial->write("OK\r>");
        }
        // 1. СКОРОСТЬ (010D)
        else if (trimmedData == "010D") {
            QString response = QString("41 0D %1").arg(m_speed, 2, 16, QChar('0')).toUpper();
            serial->write(response.toLatin1() + "\r>");
        }
        // 2. ОБОРОТЫ (010C) - Формула: об/мин * 4
        else if (trimmedData == "010C") {
            int obdRpm = m_rpm * 4;
            QString hexRpm = QString("%1").arg(obdRpm, 4, 16, QChar('0')).toUpper();
            QString response = QString("41 0C %1 %2").arg(hexRpm.left(2), hexRpm.right(2));
            serial->write(response.toLatin1() + "\r>");
        }
        // 3. ТЕМПЕРАТУРА (0105) - Формула: Градусы + 40
        else if (trimmedData == "0105") {
            int obdTemp = m_temp + 40;
            QString response = QString("41 05 %1").arg(obdTemp, 2, 16, QChar('0')).toUpper();
            serial->write(response.toLatin1() + "\r>");
        }
        // 4. ВОЛЬТАЖ (ATRV)
        else if (trimmedData == "ATRV") {
            QString response = QString("%1V").arg(m_voltage, 0, 'f', 1);
            serial->write(response.toLatin1() + "\r>");
        }
        // Неизвестная команда
        else {
            serial->write("NO DATA\r>");
        }

        emit dataReceived(trimmedData);
    }
}

// Сеттеры от UI
void SerialPortWorker::changeSpeedToOBD(int speed) { m_speed = speed; }
void SerialPortWorker::changeRpmToOBD(int rpm) { m_rpm = rpm; }
void SerialPortWorker::changeTempToOBD(int temp) { m_temp = temp; }
void SerialPortWorker::changeVoltageToOBD(double voltage) { m_voltage = voltage; }
