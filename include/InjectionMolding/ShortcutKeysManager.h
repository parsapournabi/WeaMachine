#ifndef SHORTCUTKEYSMANAGER_H
#define SHORTCUTKEYSMANAGER_H

#include "KeyboardShortcutItem.h"
#include "keyboardshortcuts.h"
#include "plciomodel.h"

#include <QGuiApplication>
#include <QSettings>

#define DECL_SETTINGS QSettings settings(QSettings::IniFormat, \
                       QSettings::UserScope, \
                       QGuiApplication::organizationName(), \
                       QString("%1-%2").arg(QGuiApplication::applicationName(), "Configs"))

#define TO_SHORTCUT_NAME(name) QString("SHORTCUT_%1").arg(name.simplified().replace(" ", "_").toUpper())

class ShortcutKeysManager : public QObject
{
        Q_OBJECT
        Q_PROPERTY(KeyboardShortcuts* shortcuts MEMBER m_shortcuts CONSTANT)
        Q_PROPERTY(PlcIOModel* plcIOModel READ plcIOModel WRITE setPlcIOModel NOTIFY plcIOModelChanged)

        using TKeyItem = KeyboardShortcutItem;
    public:
        explicit ShortcutKeysManager(QObject* parent = nullptr);
        ~ShortcutKeysManager();

        /** Properties **/
        PlcIOModel* plcIOModel() const;
        void setPlcIOModel(PlcIOModel* newPlcIOModel);

        /** QML Interface Slots **/
        Q_INVOKABLE QString keyToString(int key, Qt::KeyboardModifiers modifiers) const;
        Q_INVOKABLE void updatePlcKey(int index, const QKeySequence& keySequence, int toggleType);
        Q_INVOKABLE void writeAllToSettings() const;

    signals:
        void plcIOModelChanged();

    protected:
        /// FIXME: At this moment this function only calls once
        void synchronize();

    private:
        KeyboardShortcuts* m_shortcuts = nullptr;
        PlcIOModel* m_plcIOModel = nullptr;

        int m_constantSize; // Helps to figure PLC_OUTPUT start index
};

/** Definitions **/

inline ShortcutKeysManager::ShortcutKeysManager(QObject* parent)
    : QObject{parent},
      m_shortcuts(new KeyboardShortcuts),
      m_constantSize(0)

{
    // Declring setting instance
    DECL_SETTINGS;

    /** Adding Constants shortcuts such as Joystick and default buttons **/
    struct Key
    {
        QString displayName;
        QKeySequence sequence;
        int toggleType;
        int inputType;
        quint16 analogValue;
        bool editable;
    };

    const QVector<Key> shortcuts =
    {
        // Non-Editable Shortcuts (Only from INI file can be edit)
        { "Record Position", Qt::Key_R, TKeyItem::Momentory, TKeyItem::Digital, 0, false}, // Default Key is R
        { "Joystick Up", Qt::Key_W, TKeyItem::Momentory, TKeyItem::Digital, 0, false},     // Default Key is W
        { "Joystick Down", Qt::Key_S, TKeyItem::Momentory, TKeyItem::Digital, 0, false},   // Default Key is S
        { "Joystick Left", Qt::Key_A, TKeyItem::Momentory, TKeyItem::Digital, 0, false},   // Default Key is A
        { "Joystick Right", Qt::Key_D, TKeyItem::Momentory, TKeyItem::Digital, 0, false},  // Default Key is D

        // Analog and Editable shortcuts
        { "X Servo Speed 1", Qt::Key_1, TKeyItem::Momentory, TKeyItem::Analog, 100, true},  // Default Key is 1
        { "X Servo Speed 2", Qt::Key_2, TKeyItem::Momentory, TKeyItem::Analog, 200, true},  // Default Key is 2
        { "X Servo Speed 3", Qt::Key_3, TKeyItem::Momentory, TKeyItem::Analog, 300, true},  // Default Key is 3
        { "X Servo Speed 4", Qt::Key_4, TKeyItem::Momentory, TKeyItem::Analog, 400, true},  // Default Key is 4
        { "X Servo Speed 5", Qt::Key_5, TKeyItem::Momentory, TKeyItem::Analog, 500, true},  // Default Key is 5
        { "X Servo Speed 6", Qt::Key_6, TKeyItem::Momentory, TKeyItem::Analog, 750, true},  // Default Key is 6
        { "X Servo Speed 7", Qt::Key_7, TKeyItem::Momentory, TKeyItem::Analog, 1000, true}, // Default Key is 7
        { "X Servo Speed 8", Qt::Key_8, TKeyItem::Momentory, TKeyItem::Analog, 1250, true}, // Default Key is 8
        { "X Servo Speed 9", Qt::Key_9, TKeyItem::Momentory, TKeyItem::Analog, 1500, true}, // Default Key is 9
        { "X Servo Speed 10", Qt::Key_0, TKeyItem::Momentory, TKeyItem::Analog, 2000, true},// Default Key is 0

        { "Y Servo Speed 1", Qt::Key_F1, TKeyItem::Momentory, TKeyItem::Analog, 100, true},   // Default Key is F1
        { "Y Servo Speed 2", Qt::Key_F2, TKeyItem::Momentory, TKeyItem::Analog, 200, true},   // Default Key is F2
        { "Y Servo Speed 3", Qt::Key_F3, TKeyItem::Momentory, TKeyItem::Analog, 300, true},   // Default Key is F3
        { "Y Servo Speed 4", Qt::Key_F4, TKeyItem::Momentory, TKeyItem::Analog, 400, true},   // Default Key is F4
        { "Y Servo Speed 5", Qt::Key_F5, TKeyItem::Momentory, TKeyItem::Analog, 500, true},   // Default Key is F5
        { "Y Servo Speed 6", Qt::Key_F6, TKeyItem::Momentory, TKeyItem::Analog, 750, true},   // Default Key is F6
        { "Y Servo Speed 7", Qt::Key_F7, TKeyItem::Momentory, TKeyItem::Analog, 1000, true},  // Default Key is F7
        { "Y Servo Speed 8", Qt::Key_F8, TKeyItem::Momentory, TKeyItem::Analog, 1250, true},  // Default Key is F8
        { "Y Servo Speed 9", Qt::Key_F9, TKeyItem::Momentory, TKeyItem::Analog, 1500, true},  // Default Key is F9
        { "Y Servo Speed 10", Qt::Key_F10, TKeyItem::Momentory, TKeyItem::Analog, 2000, true},// Default Key is F10
    };
    m_constantSize = shortcuts.size();

    for (const auto& shortcut : qAsConst(shortcuts))
    {
        m_shortcuts->add(new TKeyItem(TO_SHORTCUT_NAME(shortcut.displayName),
                                      shortcut.displayName,
                                      QKeySequence(settings.value(TO_SHORTCUT_NAME(shortcut.displayName),
                                              shortcut.sequence).toString()),
                                      settings.value(TO_SHORTCUT_NAME(shortcut.displayName) + "TOGGLE_TYPE",  shortcut.toggleType).toInt(),
                                      shortcut.inputType,
                                      settings.value(TO_SHORTCUT_NAME(shortcut.displayName) + "ANALOG_VALUE", shortcut.analogValue).toUInt(),
                                      shortcut.editable,
                                      this));
    }
}

inline ShortcutKeysManager::~ShortcutKeysManager()
{
    delete m_shortcuts;
}

inline PlcIOModel* ShortcutKeysManager::plcIOModel() const
{
    return m_plcIOModel;
}

inline void ShortcutKeysManager::setPlcIOModel(PlcIOModel* newPlcIOModel)
{
    if (m_plcIOModel == newPlcIOModel)
    {
        return;
    }
    m_plcIOModel = newPlcIOModel;
    emit plcIOModelChanged();

    /** Make Connections **/
    // connect(m_plcIOModel, &PlcIOModel::outputsChanged, this, &ShortcutKeysManager::synchronize);
    synchronize();
}

inline QString ShortcutKeysManager::keyToString(int key, Qt::KeyboardModifiers modifiers) const
{
    return TKeyItem::keyToString(key, modifiers);
}

inline void ShortcutKeysManager::updatePlcKey(int index, const QKeySequence& keySequence, int toggleType)
{
    int realIdx = index + m_constantSize;
    if (realIdx < 0 || realIdx >= m_shortcuts->size())
    {
        qWarning() << __FUNCTION__ << "Invalid Index value: " << index << realIdx << m_constantSize << m_shortcuts->size();
        return;
    }

    m_shortcuts->edit(index, keySequence, toggleType, 0);
}

inline void ShortcutKeysManager::writeAllToSettings() const
{
    DECL_SETTINGS;

    for (int i(0); i < m_shortcuts->size(); ++i)
    {
        const auto& key = m_shortcuts->get(i);
        // Setting the KeySequence
        settings.setValue(key->name(), key->keySequence());

        switch (key->inputType())
        {
            case TKeyItem::Digital:
                // Setting the ToggleType
                settings.setValue(key->name() + "TOGGLE_TYPE", key->toggleType());
                break;
            case TKeyItem::Analog:
                // Setting the AnalogValue
                settings.setValue(key->name() + "ANALOG_VALUE", key->analogValue());
                break;
        }
    }
}

inline void ShortcutKeysManager::synchronize()
{
    // Safety
    if (!m_plcIOModel)
    {
        qCritical() << __FUNCTION__ << "plcIOModel is NULL";
        return;
    }
    // Settings
    DECL_SETTINGS;

    // Adding each plc output into the shortcut buffer
    const auto& outputs = m_plcIOModel->outputs();
    for (int i(0); i < outputs.size(); ++i)
    {
        const auto& output = outputs[i];
        const auto& sequence = TO_SHORTCUT_NAME(output->name());
        const auto& toggleType = TO_SHORTCUT_NAME(output->name() + QString("TOGGLE_TYPE"));
        auto key = new TKeyItem(sequence,
                                output->displayName(),
                                QKeySequence(settings.value(sequence, "").toString()),
                                settings.value(toggleType, TKeyItem::Momentory).toInt(),
                                TKeyItem::InputType::Digital,
                                0,
                                true,
                                this);
        m_shortcuts->add(key);

        /** Connection **/
        int outputIndex = i + m_constantSize;
        connect(output, &PlcIOItem::displayNameChanged, [ = ]()
        {
            // Binding displayName with key displayName
            auto* key = m_shortcuts->get(outputIndex);
            key->setDisplayName(output->displayName());
        });
    }
}

#endif // SHORTCUTKEYSMANAGER_H
