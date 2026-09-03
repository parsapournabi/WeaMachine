#ifndef KEYBOARDSHORTCUTS_H
#define KEYBOARDSHORTCUTS_H

#include <QObject>

class KeyboardShortcutItem;
class KeyboardShortcuts : public QObject
{
        Q_OBJECT
        Q_PROPERTY(int count READ count NOTIFY countChanged)
    public:
        explicit KeyboardShortcuts(QObject* parent = nullptr);

        const KeyboardShortcutItem* get(int index) const;

        /** QML Interface SLOTS **/
        Q_INVOKABLE bool add(KeyboardShortcutItem* item);
        Q_INVOKABLE bool remove(int index);
        Q_INVOKABLE bool edit(int index, const QKeySequence& keySequence, int toggleType);
        Q_INVOKABLE KeyboardShortcutItem* get(int index);

        Q_INVOKABLE bool exists(KeyboardShortcutItem* item) const;
        Q_INVOKABLE bool exists(KeyboardShortcutItem* item, int count) const;
        Q_INVOKABLE bool exists(const QKeySequence& sequence) const;
        Q_INVOKABLE bool exists(const QKeySequence& sequence, int count) const;
        Q_INVOKABLE bool isValid(KeyboardShortcutItem* item) const;
        Q_INVOKABLE bool isValid(const QKeySequence& item) const;
        Q_INVOKABLE bool isAllValid() const;

        Q_INVOKABLE bool empty() const;
        Q_INVOKABLE bool isEmpty() const;
        Q_INVOKABLE int count() const;
        Q_INVOKABLE int size() const;
        Q_INVOKABLE int length() const;

    signals:
        void countChanged();
        void dataChanged(int index);

    private:
        QVector<KeyboardShortcutItem*> m_buffer;
};

#endif // KEYBOARDSHORTCUTS_H
