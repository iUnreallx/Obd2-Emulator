#ifndef SERIALPORTWORKER_H
#define SERIALPORTWORKER_H

#include <QObject>
#include <QSerialPort>

class SerialPortWorker : public QObject
{
    Q_OBJECT
public:
    explicit SerialPortWorker(QObject *parent = nullptr);
    ~SerialPortWorker();

public slots:
    void openPort(const QString &portName);
    void closePort();

    void changeSpeedToOBD(int speed);
    void changeRpmToOBD(int rpm);
    void changeTempToOBD(int temp);
    void changeVoltageToOBD(double voltage);

signals:
    void portOpened(bool success);
    void errorOccurred(const QString &error);
    void dataReceived(const QByteArray &data);

private slots:
    void handleReadyRead();

private:
    QSerialPort *serial;

    int m_speed = 0;
    int m_rpm = 0;
    int m_temp = 90;
    double m_voltage = 14.2;
};

#endif // SERIALPORTWORKER_H
