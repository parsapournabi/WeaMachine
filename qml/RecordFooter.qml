import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property alias recordButton: record
    property alias shotButton: shot
    property alias saveButton: save
    property alias removeButton: remove
    property alias cleanButton: clean

    Row {
        anchors.fill: parent
        layoutDirection: Qt.RightToLeft
        spacing: 5

        IconicButton {
            id: clean
            icon: "broom-wide"
        }

        IconicButton {
            id: remove
            icon: "trash-can"
        }

        IconicButton {
            id: save
            icon: "clipboard"
        }

        IconicButton {
            id: shot
            enabled: record.checked
            icon: "aperture"
            keyboardKey: Qt.Key_R
        }

        IconicButton {
            id: record
            checkable: true
            locked: true
            icon: checked ? "circle-pause" : "circle-play"
        }
    }

    /** Slots **/

    // Binding keyboard for Record snap-shot
    Connections {
        target: manualPage

        function onKeyPressed(key) {
            shot.applyKeyboardPress(key);
        }

        function onKeyReleased(key) {
            shot.applyKeyboardRelease(key);
        }
    }
}
