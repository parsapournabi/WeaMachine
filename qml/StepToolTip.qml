import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

CusToolTip {
    id: root

    delegateItems: [
        DelegateItem {
            iconName: "play"
            text: "Run"
        },
        DelegateItem {
            iconName: "forward"
            text: "Run From Here"
            enabled: false
        },
        DelegateItem {
            iconName: "angles-up"
            text: "Move Up"
        },
        DelegateItem {
            iconName: "angles-down"
            text: "Move Down"
        },
        DelegateItem {
            iconName: "pencil-mechanical"
            text: "Edit"
        },
        DelegateItem {
            iconName: "trash-can"
            text: "Remove"
        }
    ]

    /** Inline Components **/
    component DelegateItem: Item {
        anchors.fill: parent

        property int bottomPadding: 0
        property int topPadding: 0
        property int rightPadding: 15

        property int fontSize: 14
        property alias iconSize: icon.pixelSize

        property alias text: label.text
        property alias iconName: icon.name

        property alias labelItem: label
        property alias iconItem: icon

        // Text
        WeaQuick.Label {
            id: label

            anchors {
                left: parent.left
                verticalCenter: parent.verticalCenter
                leftMargin: 15
            }

            verticalAlignment: Qt.AlignVCenter
            font.pixelSize: parent.fontSize
        }

        // Icon
        WeaQuick.IconFont {
            id: icon

            anchors {
                top: parent.top
                bottom: parent.bottom
                right: parent.right
                rightMargin: parent.rightPadding
                bottomMargin: parent.bottomPadding
                topMargin: parent.topPadding
            }

            pixelSize: 13
            verticalAlignment: Qt.AlignVCenter
            horizontalAlignment: Qt.AlignHCenter
        }
    }
}
