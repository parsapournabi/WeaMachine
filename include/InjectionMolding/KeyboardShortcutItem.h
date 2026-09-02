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
        Q_PROPERTY(QString keySequenceStr READ keySequenceStr NOTIFY keySequenceChanged)
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

        /** Properties **/
        QString keySequenceStr() const
        {
            return m_keySequence.toString();
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

        inline static QString keyToString(int key, Qt::KeyboardModifiers modifiers = Qt::NoModifier)
        {
            return isModifier(key) ? QString() : QKeySequence(modifiers | Qt::Key(key)).toString();
        }

        inline static bool isModifier(int key)
        {
            switch (key)
            {
                case Qt::Key_Control:
                case Qt::Key_Shift:
                case Qt::Key_Alt:
                case Qt::Key_Meta:
                    return true;
                default:
                    return false;
            }
        }
};

#endif // KEYBOARDSHORTCUTITEM_H
