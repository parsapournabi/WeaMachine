import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick
import CustomItems 1.0

FocusScope {
    id: root

    property KeyboardShortcutItem modelItem

    signal requestForEdit(string keySequence, int toggleType)

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

        Column {
            Layout.preferredWidth: 180
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            spacing: 3

            KeybindInput {
                id: lineEditShortcutKey
                width: parent.width
                objectName: modelItem.name
                enabled: modelItem.editable
                text: modelItem.keySequenceStr
                onTextChanged: {
                    if (hasChanged()) {
                        lblExists.visible = shortcutKeysManager.shortcuts.exists(lineEditShortcutKey.text);
                    } else {
                        lblExists.visible = false;
                    }

                    if (!lblExists.visible) {
                        root.requestForEdit(lineEditShortcutKey.text, cmbBoxToggleType.currentIndex);
                    }
                }
            }

            WeaQuick.Label {
                id: lblExists
                visible: false
                width: parent.width
                level: 4
                font.pixelSize: 13
                horizontalAlignment: Qt.AlignHCenter
                text: "Already Exists!"
            }
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
            currentIndex: modelItem.toggleType
            onCurrentIndexChanged: {
                if (!lblExists.visible) {
                    root.requestForEdit(modelItem.keySequenceStr, cmbBoxToggleType.currentIndex);
                }
            }
        }
    }

    /** Functions **/
    function hasChanged() {
        return modelItem.keySequenceStr !== lineEditShortcutKey.text || modelItem.toggleType
                !== cmbBoxToggleType.currentIndex;
    }

    function markInvalid() {
        lblExists.visible = true;
    }

    function update() {
        // Update appearence

        // Mark Valid
        lblExists.visible = false;
    }
}
