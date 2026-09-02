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
    const QVector<QPair<QString, QString>> shortcuts =
    {
        { "Record Position", "R" }, // Default Key is R
        { "Joystick Up", "W" }, // Default Key is W
        { "Joystick Down", "S" }, // Default Key is S
        { "Joystick Left", "A" }, // Default Key is A
        { "Joystick Right", "D" }, // Default Key is D

    };
    m_constantSize = shortcuts.size();

    for (const auto& shortcut : qAsConst(shortcuts))
    {
        m_shortcuts->add(new TKeyItem(TO_SHORTCUT_NAME(shortcut.first),
                                      shortcut.first,
                                      QKeySequence(settings.value(TO_SHORTCUT_NAME(shortcut.first),
                                              shortcut.second).toString()),
                                      TKeyItem::ToggleType::Momentory,
                                      false,
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

    m_shortcuts->edit(index, keySequence, toggleType);
}

inline void ShortcutKeysManager::writeAllToSettings() const
{
    DECL_SETTINGS;

    for (int i(0); i < m_shortcuts->size(); ++i)
    {
        const auto& key = m_shortcuts->get(i);
        // Setting the KeySequence
        settings.setValue(key->name(), key->keySequence());

        // Setting the ToggleType
        settings.setValue(key->name() + "TOGGLE_TYPE", key->toggleType());
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
