#ifndef REGISTERATIONS_H
#define REGISTERATIONS_H

#include <QCoreApplication>
#include <qqml.h>

#include "SerialGlobal.h"
#include "SerialConnection.h"
#include "ShortcutKeysManager.h"
#include "TcpConnection.h"
#include "modbuscom.h"
#include "modbustcp.h"
#include "plcmodbusdevice.h"
#include "plciomodel.h"
#include "plcioitem.h"
#include "servomodbusdevice.h"
#include "stepitem.h"
#include "stepmodel.h"
#include "axisconfig.h"
#include "stepconfig.h"

#define QT_REGISTER_METATYPE(type) \
    qRegisterMetaType<type>(#type)

#define QTQML_REGISTER_TYPE(uri, type) \
    qmlRegisterType<type>(uri, 1, 0, #type)

#define QTQML_UNCREATABLE_TYPE(uri, type) \
    qmlRegisterUncreatableType<type>(uri, 1, 0, #type, "Enum Only")

Q_DECLARE_METATYPE(AbstractModbusDevice*);
Q_DECLARE_METATYPE(QList<AbstractModbusDevice*>);
Q_DECLARE_METATYPE(QList<PlcIOItem*>);
Q_DECLARE_METATYPE(PlcIOModel*);
Q_DECLARE_METATYPE(PlcIOItem*);
Q_DECLARE_METATYPE(QList<StepItem*>);
Q_DECLARE_METATYPE(StepItem*);
Q_DECLARE_METATYPE(QList<StepItem>);
Q_DECLARE_METATYPE(StepItem);
Q_DECLARE_METATYPE(QVector<bool>);

static void registerTypes()
{
    QT_REGISTER_METATYPE(PlcIOModel*);
    QT_REGISTER_METATYPE(PlcIOItem*);
    QT_REGISTER_METATYPE(StepItem*);
    QT_REGISTER_METATYPE(AbstractModbusDevice*);
    QT_REGISTER_METATYPE(ServoModbusDevice*);
    QT_REGISTER_METATYPE(QList<AbstractModbusDevice*>);
    QT_REGISTER_METATYPE(QList<ServoModbusDevice*>);
    QT_REGISTER_METATYPE(QList<PlcIOItem>*);
    QT_REGISTER_METATYPE(QList<StepItem*>);
    QT_REGISTER_METATYPE(QList<StepItem>);
    QT_REGISTER_METATYPE(StepItem);
    QT_REGISTER_METATYPE(QVector<bool>);

    QTQML_REGISTER_TYPE("CustomItems", StepItem);
    QTQML_REGISTER_TYPE("CustomItems", StepModel);
    QTQML_REGISTER_TYPE("CustomItems", PlcModbusDevice);
    QTQML_REGISTER_TYPE("CustomItems", ServoModbusDevice);
    QTQML_REGISTER_TYPE("CustomItems", SerialGlobal);
    QTQML_REGISTER_TYPE("CustomItems", SerialConnection);
    QTQML_REGISTER_TYPE("CustomItems", TcpConnection);
    QTQML_REGISTER_TYPE("CustomItems", ModbusCom);
    QTQML_REGISTER_TYPE("CustomItems", ModbusTcp);
    QTQML_REGISTER_TYPE("CustomItems", KeyboardShortcuts);
    QTQML_REGISTER_TYPE("CustomItems", KeyboardShortcutItem);
    QTQML_REGISTER_TYPE("CustomItems", ShortcutKeysManager);

    // Enums
    QTQML_UNCREATABLE_TYPE("CustomItems", PlcIOItem);

    // Configurations
    QTQML_REGISTER_TYPE("CustomItems", AxisConfig);
    QTQML_REGISTER_TYPE("CustomItems", StepConfig);
}

Q_COREAPP_STARTUP_FUNCTION(registerTypes)

#endif // REGISTERATIONS_H
