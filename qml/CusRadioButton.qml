import QtQuick 2.12
import QtQuick.Controls 2.12 as Q
import com.wearily.WeaQuick 1.0 as WeaQuick

Q.RadioButton {
    id: control
    checked: true
    text: qsTr("Radio Button")

    property color indicatorBgColor: "#55000000"
    property color color: "orange"
    property color textColor: "white"

    readonly property color darkerTextColor: Qt.darker(textColor, 1.25)
    readonly property color darkerColor: Qt.darker(color, 1.5)

    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 12
        color: control.indicatorBgColor
        border.color: control.down ? control.darkerColor : control.color

        Rectangle {
            anchors.centerIn: parent
            width: parent.width / 2
            height: parent.height / 2
            radius: width / 2
            color: control.down ? control.darkerColor : control.color
            visible: control.checked
        }
    }

    contentItem: WeaQuick.Label {
        text: control.text
        font.pixelSize: control.font.pixelSize
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? control.darkerTextColor : control.textColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
