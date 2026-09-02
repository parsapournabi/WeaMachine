import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

CusDelayButton {
    id: btnDlyWriteSetting

    signal writeRequest

    width: 220
    button.border.width: 2
    button.width: 220
    height: 48
    label.font.pixelSize: 16

    level: 2
    text: "Write"
    delay: 700
    onActivated: {
        writeRequest();
    }

    WeaQuick.IconFont {
        anchors {
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 60
        }
        name: "clipboard"
        pixelSize: 14
    }
}
