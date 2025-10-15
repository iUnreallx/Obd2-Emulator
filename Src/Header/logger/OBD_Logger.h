// Src/Header/ConnectionLogger.h
#pragma once
#include <QObject>
#include <QStringList>

class OBD_Logger : public QObject
{
    Q_OBJECT
public:
    explicit OBD_Logger(QObject *parent = nullptr);

    Q_INVOKABLE QStringList logs() const;

    void addLog(const QString &message);
    void clearLogs();

signals:
    void logUpdated(const QString &message);
    void logsCleared();

private:
    QStringList m_logs;
};
