#ifndef AXISCONFIG_H
#define AXISCONFIG_H

#include <WeaCore/utils.h>
#include <QQmlParserStatus>

class AxisConfig : public QObject, public QQmlParserStatus
{
        Q_OBJECT
        W_PROP_HDEF(QString, unitName, UnitName, "PUU")
        Q_PROPERTY(qint64 numerator MEMBER m_numerator CONSTANT)
        Q_PROPERTY(qint64 denominator MEMBER m_denominator CONSTANT)
        Q_PROPERTY(qint64 zeroPUU MEMBER m_zeroPUU CONSTANT)
        Q_PROPERTY(qint32 maxDecimals MEMBER m_maxDecimals CONSTANT)
        W_PROP_HDEF(qint32, decimals, Decimals, 0)

        // Positioning Configs
        Q_PROPERTY(int actionMode MEMBER m_actionMode)
        Q_PROPERTY(int encoderTolerance MEMBER m_encoderTolerance)
        Q_PROPERTY(int positionRetries MEMBER m_positionRetries)
        Q_PROPERTY(int positionErrorCheckDelay MEMBER m_positionErrorCheckDelay)

    public:
        // Action doing when Positioning is on freeze mode
        enum ActionMode
        {
            // Stop (the currentStep)
            EmergencyStop = 0,
            // Retry until < positionRetries --> If success next step/ else Stop currentStep
            RetryAndContinue
        };

        explicit AxisConfig(QObject* parent = nullptr);

        void classBegin() override;
        void componentComplete() override;

        /** Slots **/
        Q_INVOKABLE double toUnit(qint32 puu) const;
        Q_INVOKABLE qint32 toPUU(double unit) const;

        Q_INVOKABLE void setZeroPUU(qint32 zeroPUU);
        Q_INVOKABLE void setScale(qint64 numerator, qint64 denominator);

        Q_INVOKABLE void synchronize(AxisConfig* other);

    signals:
        void gearRatioChanged();

    protected:
        void updateAll();

        /** Settings Storage **/
        void readFromSettings();
        void writeToSettings() const;

    private:
        void applyMaxDecimals();

        qint64 m_numerator;
        qint64 m_denominator;

        qint32 m_zeroPUU; // Offset error of Encoder (Optional)
        qint32 m_maxDecimals;

        // Positioning Configs
        int m_actionMode;
        int m_encoderTolerance;
        int m_positionRetries;
        int m_positionErrorCheckDelay;
};

#endif // AXISCONFIG_H
