#ifndef KEYBOARDSHORTCUTITEM_H
#define KEYBOARDSHORTCUTITEM_H

#include <WeaCore/utils.h>
#include <QKeySequence>

class KeyboardShortcutItem : public QObject
{
        Q_OBJECT
        W_PROP_HDEF(QString, name, Name, "")
        W_PROP_HDEF(QString, displayName, DisplayName, "")
        W_PROP_HDEF(QKeySequence, keySequence, KeySequence, {})
        W_PROP_HDEF(int, toggleType, ToggleType, ToggleType::Momentory)
        W_PROP_HDEF(bool, editable, Editable, true)
    public:
        enum ToggleType
        {
            Momentory = 0,
            Maintained
        };

        explicit KeyboardShortcutItem(QObject* parent = nullptr)
            :
            QObject{parent}
        {
        }

        KeyboardShortcutItem(const QString& name,
                             const QString& displayName,
                             const QKeySequence& sequence,
                             int toggleType,
                             bool editable,
                             QObject* parent = nullptr)
            :
            QObject{parent},
            m_name(name),
            m_displayName(displayName),
            m_keySequence(sequence),
            m_toggleType(toggleType),
            m_editable(editable)
        {

        }

        KeyboardShortcutItem(const QKeySequence& sequence)
            : m_keySequence(sequence)
        {

        }

        /** Methods **/

        inline bool isValid() const
        {
            return isValid(this);
        }

        /** Statics **/
        inline static bool isValid(const KeyboardShortcutItem* item)
        {
            const auto& sequence = item->keySequence();
            return isValid(sequence);
        }

        inline static bool isValid(const QKeySequence& sequence)
        {
            return !(sequence.isEmpty() || sequence.count() != 1 || sequence.toString().isEmpty());
        }
};

#endif // KEYBOARDSHORTCUTITEM_H
