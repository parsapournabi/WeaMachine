import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    Column {
        id: layout
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: 10
            leftMargin: 20
            rightMargin: 20
        }
        spacing: 10

        WeaQuick.Label {
            id: lblLeftSideTitle
            font {
                pixelSize: 20
                bold: true
            }
            text: "Keybind Configuration"
        }

        SpliterLine {
            width: parent.width
            height: 2
        }
    }

    ColumnLayout {
        anchors {
            top: layout.bottom
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            topMargin: 20
            leftMargin: 20
            rightMargin: 20
        }
        spacing: 20

        KeybindView {
            id: keybindView
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        WriteButton {
            id: btnDlyWriteSetting
            Layout.preferredWidth: width
            Layout.preferredHeight: height
            Layout.alignment: Qt.AlignVCenter | Qt.AlignRight
        }
    }

    component SpliterLine: Item {
        property alias size: rect.height

        Rectangle {
            id: rect
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width
            height: 1
            color: "orange"
            gradient: Gradient {
                orientation: Qt.Horizontal
                GradientStop {
                    color: rect.color
                    position: 0.0
                }
                GradientStop {
                    color: "transparent"
                    position: 1.0
                }
            }
        }
    }
}
