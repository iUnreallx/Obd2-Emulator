#ifndef SERIALPORTCONNECTOR_H
#define SERIALPORTCONNECTOR_H

#include <QObject>
#include <QThread>

class SerialPortWorker;

class SerialPortConnector : public QObject
{
    Q_OBJECT
public:
    explicit SerialPortConnector(QObject *parent = nullptr);
    ~SerialPortConnector();

    Q_INVOKABLE void openPort(const QString &portName);
    Q_INVOKABLE void closePort();

    Q_INVOKABLE void changeSpeedToOBD(int speed);
    Q_INVOKABLE void changeRpmToOBD(int rpm);
    Q_INVOKABLE void changeTempToOBD(int temp);
    Q_INVOKABLE void changeVoltageToOBD(double voltage);

signals:
    void connectionResult(bool success);

private:
    QThread *workerThread;
    SerialPortWorker *worker;
};

#endif // SERIALPORTCONNECTOR_H
