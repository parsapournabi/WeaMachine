import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property bool dependentEnabled: false

    property color currentStateColor: "orange"
    property alias currentStateText: statusLabel.text

    property alias statusBox: statusRect
    property alias insertButton: insertButton
    property alias moveUpButton: moveUpButton
    property alias moveDownButton: moveDownButton
    property alias editButton: editButton
    property alias deleteButton: deleteButton
    property alias openButton: openFileButton
    property alias saveButton: saveFileButton

    Row {
        anchors.fill: parent
        spacing: 5

        Rectangle {
            id: statusRect
            width: root.width - 8 * (insertButton.width + 1.5)
            height: root.height
            color: "transparent"
            border.color: currentStateColor
            radius: 4

            WeaQuick.Label {
                id: statusLabel
                anchors.centerIn: parent
                font.pixelSize: 13
                color: currentStateColor
                verticalAlignment: Qt.AlignVCenter
                horizontalAlignment: Qt.AlignHCenter
            }
        }

        IconicButton {
            id: insertButton
            icon: "plus-large"
        }

        IconicButton {
            id: moveUpButton
            enabled: dependentEnabled
            icon: "angles-up"
        }

        IconicButton {
            id: moveDownButton
            enabled: dependentEnabled
            icon: "angles-down"
        }

        IconicButton {
            id: editButton
            enabled: dependentEnabled
            icon: "pencil-mechanical"
        }

        IconicButton {
            id: deleteButton
            enabled: dependentEnabled
            icon: "trash-can"
        }

        IconicButton {
            id: openFileButton
            icon: "folder-open"
        }

        IconicButton {
            id: saveFileButton
            icon: "clipboard"
        }
    }
}
