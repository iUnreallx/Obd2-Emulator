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
    Q_INVOKABLE bool isPortOpen() const;

    Q_INVOKABLE void changeSpeedToOBD(int speed);

signals:
    void dataReceived(const QByteArray &data);

private:
    QThread *workerThread;
    SerialPortWorker *worker;
};

#endif // SERIALPORTCONNECTOR_H
