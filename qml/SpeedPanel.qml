import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

BorderRectangle {
    id: root

    property bool manualActive: false

    property int titleSize: 15
    property int fontSize: 13
    property int titleVAlignment: Qt.AlignBottom
    property int titleHAlignment: Qt.AlignLeft

    property int controlHeight: 27

    /** Output Alias **/
    property alias speedXControl: speedXControl
    property alias speedYControl: speedYControl
    property alias submitButton: submitButton

    title: "Speed"
    level: 0

    height: layout.height + 50 // 50 means Spacer

    Column {
        id: layout
        x: 10
        width: parent.width - x * 2
        spacing: 0

        ShineLine {
            width: parent.width
            color: "orange"
        }

        // Spacer
        Item {
            width: 1
            height: 15
        }

        // Servo X
        WeaQuick.Label {
            width: parent.width
            height: controlHeight
            font.pixelSize: root.titleSize
            horizontalAlignment: root.titleHAlignment
            verticalAlignment: root.titleVAlignment
            text: "X-Axis Servo"
        }

        SpeedControl {
            id: speedXControl

            x: 10
            width: parent.width - x * 2
            height: controlHeight
            value: servoXDevice.jogSpeed
        }

        // Spacer
        Item {
            width: 1
            height: 25
        }

        // Servo Y
        WeaQuick.Label {
            width: parent.width
            height: controlHeight
            font.pixelSize: root.titleSize
            horizontalAlignment: root.titleHAlignment
            verticalAlignment: root.titleVAlignment
            text: "Y-Axis Servo"
        }

        SpeedControl {
            id: speedYControl

            x: 10
            width: parent.width - x * 2
            height: controlHeight
            value: servoYDevice.jogSpeed
        }

        // Spacer
        Item {
            width: 1
            height: 25
        }

        // Perform Button
        WeaQuick.Button {
            id: submitButton
            x: parent.width - width - 10
            height: controlHeight

            enabled: manualActive

            level: 2
            text: "Submit"
            border.width: 1
            onClicked: {
                pushJogSpeed(speedXControl.value, 0);
                pushJogSpeed(speedYControl.value, 1);
            }
        }
    }

    /** Object & Resources **/
    Repeater {
        id: repeaterShortcuts
        model: 20 // Fixed shortcut Keys for two servo jog speeds
        delegate: SpdShortcutObject {

            keySequence: getKeyItem(index).keySequence
            speedValue: getKeyItem(index).analogValue
            servoAxis: index >= 10 ? 1 : 0 // 0 === XAxis , 1 Axis
            objectName: getKeyItem(index).name

            /** Functions **/
            function getKeyItem(index) {
                return shortcutKeysManager.shortcuts.getByName(getName(index));
            }

            function getName(index) {
                // Getting by index (10 for X and 10 speeds for Y)
                const BASE_NAME = "SHORTCUT";
                return "%1_%2_SERVO_SPEED_%3".arg(BASE_NAME).arg(getAxisStr(index)).arg((index % 10) + 1);
            }

            function getAxisStr(index) {
                return index >= 10 ? "Y" : "X";
            }
        }
    }

    /** Declaring 10 differents Speeds Shortcuts **/
    Connections {
        target: manualPage
        enabled: root.enabled && manualActive

        function onKeyPressed(key, modifiers) {
            for (let i = 0; i < repeaterShortcuts.count; ++i) {
                const item = repeaterShortcuts.itemAt(i);

                if ((key | modifiers) === item.keySequence) {
                    pushJogSpeed(item.speedValue, item.servoAxis);
                    break;
                }
            }
        }
    }

    /** Functions **/
    function pushJogSpeed(speed, axis) {
        // axis === 0 -> XAxis, axis === 1 -> YAxis
        switch (axis) {
        case 0:
            servoXDevice.pushJogSpeed(speed);
            break;
        case 1:
            servoYDevice.pushJogSpeed(speed);
            break;
        default:
            console.warn("Invalid Axis value for pushJogSpeed JS", speed, axis);
            break;
        }
    }

    /** Inline Components & Object **/
    component SpdShortcutObject: Item {
        property int keySequence: Qt.NoButton
        property int speedValue: 0
        property int servoAxis: 0 // 0 === XAxis, 1 === YAxis
    }
}
