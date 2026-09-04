import QtQuick 2.12
import QtQuick.Layouts 1.12
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    signal keyPressed(var key, var modifiers)
    signal keyReleased(var key, var modifiers)

    Item {
        id: mainContent
        anchors {
            top: parent.top
            bottom: parent.bottom
            left: parent.left
            right: controlPanel.left
            margins: 10
            rightMargin: controlPanel.padding + 10
        }

        ColumnLayout {
            id: vLayout
            anchors.fill: parent
            spacing: 5
            ServoGauges {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 50
            }

            // Rectangle {
            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredHeight: 50
                spacing: 5

                RecordTable {
                    id: recordTable
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 50
                }

                StatusPane {
                    id: statusPane
                    Layout.fillHeight: true
                    Layout.fillWidth: true
                    Layout.preferredWidth: 50

                    toggleStatusOutput: true
                    manualActive: controlPanel.axisControlPanel.manualActive
                }
            }
        }
    }

    // Control Panel
    ControlPanel {
        id: controlPanel
        anchors {
            top: parent.top
            bottom: parent.bottom
            right: parent.right
        }
        width: 380
    }

    /** Slots **/
    Keys.onPressed: event => {
                        if (event.isAutoRepeat) {
                            return;
                        }

                        console.log("Pressed: ", event.key);
                        keyPressed(event.key, event.modifiers);
                        event.accepted = true;
                    }
    Keys.onReleased: event => {
                         if (event.isAutoRepeat) {
                             return;
                         }

                         console.log("Released: ", event.key);
                         keyReleased(event.key, event.modifiers);
                         event.accepted = true;
                     }
}
