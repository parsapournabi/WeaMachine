import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import "GlobalUtils.js" as GlobalUtils

ToolTip {
    id: root

    property bool hideWhenClicked: true

    property int level: 2
    property color contentColor: GlobalUtils.toolTipContentColor[level]
    property color contentHoverColor: GlobalUtils.toolTipContentHoverColor[level]

    property int controlWidth: 200
    property int controlHeight: 45
    property int borderWidth: 1

    property list<Item> delegateItems

    property alias controlSpacing: layout.spacing

    signal clicked(int index)

    verticalPadding: root.borderWidth
    horizontalPadding: root.borderWidth

    background: Rectangle {
        id: rectBackground
        implicitWidth: root.controlWidth
        implicitHeight: repeater.count * (root.controlHeight + layout.spacing)
        color: "transparent"
        border {
            color: GlobalUtils.toolTipBorderColor[level]
            width: root.borderWidth
        }
        radius: 8
    }

    contentItem: ColumnLayout {
        id: layout
        spacing: 0

        Repeater {
            id: repeater
            model: delegateItems.length

            delegate: Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: controlHeight

                color: (mouseArea.containsMouse && !mouseArea.containsPress) ? GlobalUtils.toolTipBorderColor[level] :
                                                                               GlobalUtils.toolTipBackgroundColor[index
                                                                                                                  % 2 === 1
                                                                                                                  ? level : level
                                                                                                                    + 1]
                radius: rectBackground.radius

                // Bottom/Top Border
                Rectangle {
                    anchors {
                        fill: index > 0 && index < repeater.count - 1 ? parent : undefined
                        left: parent.left
                        right: parent.right
                        top: index === repeater.count - 1 ? parent.top : undefined
                        bottom: index === 0 ? parent.bottom : undefined
                    }

                    color: parent.color
                    height: rectBackground.radius
                }

                /** Delegate Item from Inherited Component **/
                Item {
                    id: delegateItem
                    anchors.fill: parent
                    children: root.delegateItems[index]
                }

                /** Automatic MouseArea **/
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    acceptedButtons: Qt.LeftButton
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        root.clicked(index);

                        if (root.hideWhenClicked) {
                            root.hide();
                        }
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 300
                    }
                }
            }
        }
    }
}
