#ifndef STEPCONFIG_H
#define STEPCONFIG_H

#include <WeaCore/utils.h>
#include <QQmlParserStatus>

class StepConfig : public QObject, public QQmlParserStatus
{
        Q_OBJECT
        Q_INTERFACES(QQmlParserStatus)
        Q_PROPERTY(QVariantList defaultActiveCoils MEMBER m_defaultActiveCoils CONSTANT) // Stores Coils index starts at 0
        Q_PROPERTY(int stepRestartMethod MEMBER m_stepRestartMethod CONSTANT)
    public:
        enum RestartMethod
        {
            RestartAtBegining = 0,
            ContinueSteps
        };

        explicit StepConfig(QObject* parent = nullptr);
        StepConfig(QVariantList activeCoils, int restartMethod);

        void classBegin() override;
        void componentComplete() override;

        Q_INVOKABLE void synchronize(QVariantList activeCoils, int restartMethod);
        Q_INVOKABLE void synchronize(StepConfig* other);

    signals:

    protected:
        /** Settings Storage **/
        void readFromSettings();
        void writeToSettings() const;

    private:
        QVariantList m_defaultActiveCoils;
        int m_stepRestartMethod;

};

#endif // STEPCONFIG_H
