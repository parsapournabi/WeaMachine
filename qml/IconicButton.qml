import QtQuick 2.12
import QtQuick.Controls 2.12 as Q
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Button {
    id: root

    property string toolTipText: ""

    width: 27
    height: 27

    iconColor: "orange"
    flat: false

    arrayBorderColor: arrayBackgroundColor
    arraySelectedBorderColor: ["orange", "orange", "orange"]

    Q.ToolTip {
        delay: 500
        visible: mouseArea.containsMouse && toolTipText.length > 0
        text: toolTipText
    }
}
