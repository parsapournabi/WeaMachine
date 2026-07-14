#include "../include/InjectionMolding/stepconfig.h"

#include <QSettings>
#include <QGuiApplication>

#define GET_SETTING_NAME(x) objectName() + "_" + QString(#x)

StepConfig::StepConfig(QObject* parent)
    : QObject{parent}
{

}

StepConfig::StepConfig(QVariantList activeCoils, int restartMethod)
    :
    m_defaultActiveCoils(activeCoils),
    m_stepRestartMethod(restartMethod)
{
}

void StepConfig::classBegin()
{

}

void StepConfig::componentComplete()
{
    readFromSettings();
}

void StepConfig::synchronize(QVariantList activeCoils, int restartMethod)
{
    auto* other = new StepConfig(activeCoils, restartMethod);
    synchronize(other);
    delete other;
}

void StepConfig::synchronize(StepConfig* other)
{
    m_defaultActiveCoils = other->m_defaultActiveCoils;
    m_stepRestartMethod = other->m_stepRestartMethod;

    writeToSettings();
}

void StepConfig::readFromSettings()
{
    QSettings settings(QSettings::IniFormat,
                       QSettings::UserScope,
                       QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());

    m_defaultActiveCoils = settings.value(GET_SETTING_NAME(DEFAULT_ACTIVE_COILS),
                                          {}).toList();

    m_stepRestartMethod = settings.value(GET_SETTING_NAME(STEP_RESTART_METHOD),
                                         RestartMethod::RestartAtBegining).toInt();
}

void StepConfig::writeToSettings() const
{
    QSettings settings(QSettings::IniFormat,
                       QSettings::UserScope,
                       QGuiApplication::organizationName(),
                       QGuiApplication::applicationName());

    settings.setValue(GET_SETTING_NAME(DEFAULT_ACTIVE_COILS), m_defaultActiveCoils);
    settings.setValue(GET_SETTING_NAME(STEP_RESTART_METHOD), m_stepRestartMethod);
}
