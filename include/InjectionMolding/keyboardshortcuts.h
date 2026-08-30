#ifndef KEYBOARDSHORTCUTS_H
#define KEYBOARDSHORTCUTS_H

#include <QObject>

class KeyboardShortcuts : public QObject
{
    Q_OBJECT
public:
    explicit KeyboardShortcuts(QObject *parent = nullptr);

signals:
};

#endif // KEYBOARDSHORTCUTS_H
