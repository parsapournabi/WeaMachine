#pragma once

#include <QDateTime>
#include <QThread>
#include <QTextStream>
#include <QGuiApplication>
#include <QElapsedTimer>
#include <stdlib.h>

#define ELPS_ST QElapsedTimer ep; ep.start()
#define ELPS_ED qDebug() << "Elapsed Timer: " << ep.elapsed()

void logMessageHandler(QtMsgType type, const QMessageLogContext& context, const QString& msg)
{
    Q_UNUSED(context)

    QString currentStrTime = QDateTime::currentDateTime().toString("hh:mm:ss.zzz");
    auto threadid = reinterpret_cast<quintptr>(QThread::currentThreadId());
    QString prefix;

    switch (type)
    {
        case QtDebugMsg:
            prefix += 'D';
            break;
        case QtInfoMsg:
            prefix += 'I';
            break;
        case QtWarningMsg:
            prefix += 'W';
            break;
        case QtCriticalMsg:
            prefix += 'C';
            break;
        case QtFatalMsg:
            prefix += 'F';
            break;
    }

    QString message = QString("[%1][%2][0x%3] %4")
                      .arg(prefix, currentStrTime)
                      .arg(threadid, 0, 16)
                      .arg(msg);

    FILE* stream = (type == QtDebugMsg || type == QtInfoMsg) ? stdout : stderr;
    QTextStream ts(stream);

    ts << message << '\n';
    ts.flush();

    if (type == QtFatalMsg)
    {
        abort();
    }
}
