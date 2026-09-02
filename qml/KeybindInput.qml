import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.LineEdit {
    id: root
    level: 2
    border.width: 1
    font.pixelSize: 16
    arrayBackgroundColor: ["black", "black", "black"]
    placeholderText: "???"
    horizontalAlignment: Qt.AlignHCenter
}
