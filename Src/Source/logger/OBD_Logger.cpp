#include "Src/Header/logger/OBD_Logger.h"
#include <QDateTime>

OBD_Logger::OBD_Logger(QObject *parent)
    : QObject(parent)
{
}

QStringList OBD_Logger::logs() const
{
    return m_logs;
}

void OBD_Logger::addLog(const QString &message)
{
    QString timestamped = QString("[%1] %2")
    .arg(QDateTime::currentDateTime().toString("hh:mm:ss"))
        .arg(message);
    m_logs.append(timestamped);
    emit logUpdated(timestamped);
}

void OBD_Logger::clearLogs()
{
    m_logs.clear();
    emit logsCleared();
}
