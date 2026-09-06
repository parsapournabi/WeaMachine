#ifndef SECURITYMANAGER_H
#define SECURITYMANAGER_H

#include <QObject>

class SecurityManager : public QObject
{
        Q_OBJECT
    public:
        explicit SecurityManager(QObject* parent = nullptr);

        /** QML Interface Slots **/
        Q_INVOKABLE bool checkUserPass(const QString& username, const QString& password) const;

    protected:
        virtual bool checkDatabase(const QString& username, const QString& password) const;
        virtual bool checkHardcode(const QString& username, const QString& password) const;

    signals:
};

#endif // SECURITYMANAGER_H
