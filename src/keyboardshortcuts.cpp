#include "../include/InjectionMolding/keyboardshortcuts.h"
#include "../include/InjectionMolding/KeyboardShortcutItem.h"

#include <QDebug>

KeyboardShortcuts::KeyboardShortcuts(QObject* parent)
    : QObject{parent}
{
}

bool KeyboardShortcuts::add(KeyboardShortcutItem item)
{
    if (!item.isValid())
    {
        qWarning() << __FUNCTION__ << "Item isn't valid: " << item.name() << item.keySequence();
        return false;
    }

    if (exists(item))
    {
        qWarning() << __FUNCTION__ << "Item is alread exists: " << item.name() << item.keySequence();
        return false;
    }

    m_buffer.append(item);

    emit countChanged();
    return true;
}

bool KeyboardShortcuts::remove(int index)
{
    if (index < 0 || index >= m_buffer.size())
    {
        qWarning() << __FUNCTION__ << "Invalid Index value: " << index;
        return false;
    }

    m_buffer.remove(index);
    emit countChanged();
    return true;
}

KeyboardShortcutItem* KeyboardShortcuts::get(int index)
{
    if (index < 0 || index >= m_buffer.size())
    {
        qWarning() << __FUNCTION__ << "Invalid Index value: " << index;
        return nullptr;
    }

    return &m_buffer[index];
}

const KeyboardShortcutItem* KeyboardShortcuts::get(int index) const
{
    if (index < 0 || index >= m_buffer.size())
    {
        qWarning() << __FUNCTION__ << "Invalid Index value: " << index;
        return nullptr;
    }

    return &m_buffer.at(index);
}

bool KeyboardShortcuts::exists(const KeyboardShortcutItem& item) const
{
    return exists(item.keySequence());
}

bool KeyboardShortcuts::exists(const QKeySequence& sequence) const
{
    return std::any_of(m_buffer.cbegin(),
                       m_buffer.cend(),
                       [&](const auto & keyboardShortcutItem)
    {
        return sequence == keyboardShortcutItem.keySequence();
    });
}

bool KeyboardShortcuts::isValid(const KeyboardShortcutItem& item) const
{
    return KeyboardShortcutItem::isValid(item);
}

bool KeyboardShortcuts::isValid(const QKeySequence& item) const
{
    return KeyboardShortcutItem::isValid(item);
}

bool KeyboardShortcuts::isAllValid() const
{
    return std::all_of(m_buffer.cbegin(),
                       m_buffer.cend(),
                       [](const auto & item)
    {
        return item.isValid();
    });
}

bool KeyboardShortcuts::empty() const
{
    return m_buffer.empty();
}

bool KeyboardShortcuts::isEmpty() const
{
    return m_buffer.isEmpty();
}

int KeyboardShortcuts::count() const
{
    return m_buffer.count();
}

int KeyboardShortcuts::size() const
{
    return m_buffer.size();
}

int KeyboardShortcuts::length() const
{
    return m_buffer.length();
}
