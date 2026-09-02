import QtQuick 2.12
import QtQuick.Controls 2.12

ListView {
    id: root

    spacing: 20
    clip: true

    boundsBehavior: Flickable.StopAtBounds
    ScrollBar.vertical: CusScrollBar {}

    model: shortcutKeysManager.shortcuts.count
    delegate: KeybindDelegate {
        width: root.width
        height: 33
        modelItem: shortcutKeysManager.shortcuts.get(index)
    }
}
