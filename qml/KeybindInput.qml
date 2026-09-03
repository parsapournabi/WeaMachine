import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.LineEdit {
    id: root

    /** Style Properties **/
    arrayBackgroundColor: ["black", "black", "black"]
    level: 2
    placeholderText: "???"
    border.width: 1
    font.pixelSize: 16
    horizontalAlignment: Qt.AlignHCenter

    /** Logical Properties **/
    mouseArea.acceptedButtons: Qt.AllButtons
    checked: activeFocus

    /** Focus Properties **/
    focus: true
    activeFocusOnPress: true
    readOnly: true

    Keys.onPressed: event => {
                        if (event.isAutoRepeat) {
                            return;
                        }

                        root.text = shortcutKeysManager.keyToString(event.key, event.modifiers);
                    }

    /** Objects & Resources **/
    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        propagateComposedEvents: true
        preventStealing: true
        onPressed: {
            root.forceActiveFocus();
        }
    }
}
