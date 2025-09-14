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

signals:
    void portOpened(bool success);
    void dataReceived(const QByteArray &data);
    void errorOccurred(const QString &error);

private slots:
    void handleReadyRead();

private:
    QSerialPort *serial;
    int m_speed = 0;
};

#endif // SERIALPORTWORKER_H
