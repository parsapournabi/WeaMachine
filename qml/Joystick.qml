import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int level: 5
    property real spacing: 10

    property real joystickHeight: 45
    property real subOffset: spacing / 2
    readonly property real size: 130
    readonly property real subSize: joystickHeight - 5

    property alias joystickTop: btnTop
    property alias joystickDown: btnDown
    property alias joystickLeft: btnLeft
    property alias joystickRight: btnRight
    property alias joystickTopLeft: btnTopLeft
    property alias joystickTopRight: btnTopRight
    property alias joystickDownLeft: btnDownLeft
    property alias joystickDownRight: btnDownRight

    /** Readonly properties **/
    readonly property var singleDirectionButtons: [btnTop, btnDown, btnLeft, btnRight]
    readonly property var multiDirectionButtons: [btnTopLeft, btnTopRight, btnDownLeft, btnDownRight]

    // Properties helper for interlocks
    // JS TIP: some == any, every == all
    readonly property bool anySinglePressed: singleDirectionButtons.some(btn => btn.containsPress)
    readonly property bool anyMultiPressed: multiDirectionButtons.some(btn => btn.containsPress)

    implicitWidth: 100
    implicitHeight: 100

    JoystickButton {
        id: btnTop
        anchors {
            bottom: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            bottomMargin: spacing + joystickHeight / 2
        }

        direction: JoystickButton.Direction.Top
        keyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_UP").keySequence
        togglableKeyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_UP").toggleType
        interlockActive: btnDown.containsPress || anyMultiPressed
        width: root.size
        height: joystickHeight
    }

    JoystickButton {
        id: btnDown
        anchors {
            top: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
            topMargin: spacing + joystickHeight / 2
        }

        direction: JoystickButton.Direction.Bottom
        keyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_DOWN").keySequence
        togglableKeyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_DOWN").toggleType
        interlockActive: btnTop.containsPress || anyMultiPressed
        width: root.size
        height: joystickHeight
    }

    JoystickButton {
        id: btnLeft
        anchors {
            right: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            rightMargin: spacing + joystickHeight / 2
        }

        direction: JoystickButton.Direction.Left
        keyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_LEFT").keySequence
        togglableKeyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_LEFT").toggleType
        interlockActive: btnRight.containsPress || anyMultiPressed
        width: root.size
        height: joystickHeight
    }

    JoystickButton {
        id: btnRight
        anchors {
            left: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
            leftMargin: spacing + joystickHeight / 2
        }

        direction: JoystickButton.Direction.Right
        keyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_RIGHT").keySequence
        togglableKeyboardKey: shortcutKeysManager.shortcuts.getByName("SHORTCUT_JOYSTICK_RIGHT").toggleType
        interlockActive: btnLeft.containsPress || anyMultiPressed
        width: root.size
        height: joystickHeight
    }

    JoystickButton {
        id: btnTopLeft
        anchors {
            bottom: btnLeft.top
            right: btnTop.left
            bottomMargin: subOffset
            rightMargin: subOffset
        }

        direction: JoystickButton.Direction.TopLeft
        interlockActive: anySinglePressed
        width: subSize
        height: subSize
    }

    JoystickButton {
        id: btnTopRight
        anchors {
            bottom: btnRight.top
            left: btnTop.right
            bottomMargin: subOffset
            leftMargin: subOffset
        }

        direction: JoystickButton.Direction.TopRight
        interlockActive: anySinglePressed
        width: subSize
        height: subSize
    }

    JoystickButton {
        id: btnDownLeft
        anchors {
            top: btnLeft.bottom
            right: btnDown.left
            topMargin: subOffset
            rightMargin: subOffset
        }

        direction: JoystickButton.Direction.BottomLeft
        interlockActive: anySinglePressed
        width: subSize
        height: subSize
    }

    JoystickButton {
        id: btnDownRight
        anchors {
            top: btnRight.bottom
            left: btnDown.right
            topMargin: subOffset
            leftMargin: subOffset
        }

        direction: JoystickButton.Direction.BottomRight
        interlockActive: anySinglePressed
        width: subSize
        height: subSize
    }

    Connections {
        target: manualPage
        function onKeyPressed(key) {
            singleDirectionButtons.forEach(function (button, index) {
                button.applyKeyboardPress(key);
            });
        }

        function onKeyReleased(key) {
            singleDirectionButtons.forEach(function (button, index) {
                button.applyKeyboardRelease(key);
            });
        }
    }
}
