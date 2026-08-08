#ifndef SERIALCONNECTION_H
#define SERIALCONNECTION_H

#include <QSerialPort>
#include <WeaCore/utils.h>

#include "SerialGlobal.h"

class SerialConnection : public QObject
{
        Q_OBJECT
        W_PROP_HDEF(QString, portName, PortName, "");
        W_PROP_HDEF(int, baudRate, BaudRate, QSerialPort::Baud115200);
        W_PROP_HDEF(int, stopBits, StopBits, QSerialPort::OneStop);
        W_PROP_HDEF(int, parity, Parity, QSerialPort::OddParity);
        W_PROP_HDEF(int, dataBits, DataBits, QSerialPort::Data8);
        W_PROP_HDEF(bool, connected, Connected, false);
    public:
        explicit SerialConnection(QObject* parent = nullptr)
            : QObject{parent}
        {

        }

        /*!
         * \brief applyTargetPortNumber : It will set the portName into the serialConn->portName if exists
         * \param portName : the target portName for example: "COM3"
         * \param serialConn : Specific target object
         * \return true if portName == serialConn->portName and portName is exists in Available ports.
         */
        inline static bool applyTargetPortNumber(const QString& portName, SerialConnection* serialConn)
        {
            if (!serialConn || !SerialGlobal::isPortNameValid(portName))
            {
                return false;
            }

            const auto availablePorts = QSerialPortInfo::availablePorts();
            const auto contains = std::any_of(availablePorts.cbegin(),
                                              availablePorts.cend(),
                                              [portName](const auto & l)
            {
                return l.portName() == portName;
            });

            if (!contains)
            {
                return false;
            }
            serialConn->setPortName(portName);

            return true;
        }

};

#endif // SERIALCONNECTION_H
