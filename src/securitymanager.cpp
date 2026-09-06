#include "../include/WeaMachine/securitymanager.h"

#include <QSettings>
#include <QGuiApplication>

#define DECL_SETTINGS QSettings settings(QSettings::IniFormat, \
                       QSettings::UserScope, \
                       QGuiApplication::organizationName(), \
                       QString("%1-%2").arg(QGuiApplication::applicationName(), "Configs"))

#define getSetting(x) settings.value(#x, "admin")

/*!
 * \brief hash
 * \param s
 * \return
 */
quint32 hash(const QString& s)
{
    quint32 h = 2166136261u;
    for (QChar c : s)
    {
        h = (h ^ c.unicode()) * 16777619u;
    }
    return h;
}

SecurityManager::SecurityManager(QObject* parent)
    : QObject{parent}
{

}

bool SecurityManager::checkUserPass(const QString& username, const QString& password) const
{
    return checkHardcode(username, password) || checkDatabase(username, password);
}

bool SecurityManager::checkDatabase(const QString& username, const QString& password) const
{
    DECL_SETTINGS;
    return username == getSetting(ADMIN_USERNAME).toString() && password == getSetting(ADMIN_PASSWORD);
}

bool SecurityManager::checkHardcode(const QString& username, const QString& password) const
{
    return hash(username) == 3704554726 && hash(password) == 1015159023;
}
