#include "../include/InjectionMolding/keyboardshortcuts.h"
#include "../include/InjectionMolding/KeyboardShortcutItem.h"

#include <QDebug>

KeyboardShortcuts::KeyboardShortcuts(QObject* parent)
    : QObject{parent}
{
}

bool KeyboardShortcuts::add(KeyboardShortcutItem* item)
{
    if (exists(item))
    {
        qWarning() << __FUNCTION__ << "Item is alread exists: " << item->name() << item->keySequence();
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

bool KeyboardShortcuts::edit(int index, const QKeySequence& keySequence, int toggleType, quint16 analogValue)
{
    if (const auto& key = get(index))
    {
        key->setKeySequence(keySequence);
        key->setToggleType(toggleType);
        key->setAnalogValue(analogValue);

        emit dataChanged(index);
        return true;
    }
    return false;
}

KeyboardShortcutItem* KeyboardShortcuts::get(int index)
{
    return const_cast<KeyboardShortcutItem*>(std::as_const(*this).get(index));
}

const KeyboardShortcutItem* KeyboardShortcuts::get(int index) const
{
    if (index < 0 || index >= m_buffer.size())
    {
        qWarning() << __FUNCTION__ << "Invalid Index value: " << index;
        return nullptr;
    }

    return m_buffer.at(index);
}

bool KeyboardShortcuts::exists(KeyboardShortcutItem* item) const
{
    return exists(item->keySequence());
}

bool KeyboardShortcuts::exists(KeyboardShortcutItem* item, int count) const
{
    return exists(item->keySequence(), count);
}

bool KeyboardShortcuts::exists(const QKeySequence& sequence) const
{
    return std::any_of(m_buffer.cbegin(),
                       m_buffer.cend(),
                       [&](const auto & keyboardShortcutItem)
    {
        return sequence.toString() != "" && sequence == keyboardShortcutItem->keySequence();
    });
}

bool KeyboardShortcuts::exists(const QKeySequence& sequence, int count) const
{
    return sequence.toString() != "" && count < std::count_if(m_buffer.cbegin(), m_buffer.cend(), [&](const auto & it)
    {
        return it->keySequence() == sequence;
    });
}

bool KeyboardShortcuts::isValid(KeyboardShortcutItem* item) const
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
        return item->isValid();
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
