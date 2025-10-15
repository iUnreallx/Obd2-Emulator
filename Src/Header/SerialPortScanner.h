#ifndef SERIALPORTSCANNER_H
#define SERIALPORTSCANNER_H

#include <QObject>
#include <QStringList>
#include <QtConcurrent/QtConcurrent>

class SerialPortScanner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList availablePorts READ availablePorts NOTIFY availablePortsChanged)

public:
    explicit SerialPortScanner(QObject *parent = nullptr);

    QStringList availablePorts() const;
    Q_INVOKABLE void scanPorts();
    Q_INVOKABLE void clearPorts();

signals:
    void availablePortsChanged();
    void noPortsAvailable();

private:
    void scanPortsInBackground();
    QStringList m_availablePorts;
};

#endif // SERIALPORTSCANNER_H
