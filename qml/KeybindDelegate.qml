import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick
import CustomItems 1.0

Item {
    id: root

    property KeyboardShortcutItem modelItem

    RowLayout {
        id: layout
        anchors.fill: parent
        spacing: 15

        // Name of the Object
        WeaQuick.Label {
            id: lblName
            Layout.preferredWidth: 170
            font {
                pixelSize: 18
                bold: true
            }
            text: modelItem.displayName
        }

        // Spacer
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        WeaQuick.LineEdit {
            id: lineEditShortcutKey
            Layout.preferredWidth: 180
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            level: 2
            border.width: 1
            font.pixelSize: 16
            arrayBackgroundColor: ["black", "black", "black"]
            enabled: modelItem.editable
            placeholderText: "???"
            horizontalAlignment: Qt.AlignHCenter
            text: modelItem.keySequenceStr
        }

        // Spacer
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Contact Type
        CusComboBox {
            id: cmbBoxToggleType
            Layout.preferredWidth: 170
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignVCenter
            level: 2

            enabled: modelItem.editable
            model: ["Momentory", "Maintained"]
        }
    }
}
