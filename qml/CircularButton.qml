import QtQuick 2.12

IconicButton {
    id: root

    radius: width / 2
    colorAnimation.duration: 0

    arrayHoveredBackgroundColor: checked ? arraySelectedBackgroundColor : arrayBackgroundColor
    arrayBorderColor: ["orange"]
    arrayHoveredBorderColor: checked ? arraySelectedBorderColor : arrayBorderColor
    arraySelectedBorderColor: checked ? ["green"] : arrayBorderColor

    states: []

    // color: getColor()
    border.color: checked ? "green" : enabled ? "orange" : "darkGray"
    iconColor: checked ? "green" : enabled ? "orange" : "darkGray"

    icon: checked ? "pause" : "play"

    function getColor() {
        return checked ? "green" : "orange";
    }
}
