import QtQuick 2.12
import QtQuick.Layouts 1.12
import "GlobalUtils.js" as GlobalUtils
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    property int indicatorSize: 25
    property bool toggleOutput: false

    property alias digitalInputsModel: digitalInput.model
    property alias digitalOutputModel: digitalOutput.model

    property alias gridInputs: gridInputs
    property alias gridOutputs: gridOutputs

    property bool manualActive: false

    // FIXME: fix togglable with checkable unmatching
    property var shortcuts: [
        {
            key: Qt.Key_Y,
            togglable: false
        },
        {
            key: Qt.Key_U,
            togglable: false
        },
        {
            key: Qt.Key_I,
            togglable: false
        },
        {
            key: Qt.Key_O,
            togglable: false
        },
        {
            key: Qt.Key_P,
            togglable: false
        },
        {
            key: Qt.Key_H,
            togglable: false
        },
        {
            key: Qt.Key_J,
            togglable: false
        },
        {
            key: Qt.Key_K,
            togglable: false
        },
        {
            key: Qt.Key_L,
            togglable: false
        },
    ]

    ColumnLayout {
        id: columnLayout
        anchors.fill: parent
        spacing: 15

        Compact {
            Layout.fillHeight: true
            Layout.fillWidth: true

            title: "PLC Digital Inputs"
            titleSize: 15
            spacing: 20

            Grid {
                id: gridInputs
                x: titleLabel.paintedHeight // margin

                columns: 8
                spacing: 10
                columnSpacing: 30
                Repeater {
                    id: digitalInput

                    delegate: Compact {
                        title: modelData.displayName
                        titleHAlignment: Qt.AlignHCenter
                        spacing: 3
                        WeaQuick.StatusIndicator {
                            width: root.indicatorSize
                            height: width

                            // levelActive: modelData.activeFeedback ? modelData.active ? 3 : 4 : 4
                            levelActive: GlobalUtils.getInputActiveLevel(modelData.active, modelData.activeFeedback)

                            borderWidth: 1
                            outerMargin: 2

                            // active: plcDevice.inputs[index]
                            active: modelData.activeFeedback || modelData.active
                        }
                    }
                }
            }
        }

        ShineLine {
            // Layout.preferredWidth: parent.width - parent.width / 3
            Layout.fillWidth: true
            color: "orange"
        }

        Compact {
            Layout.fillHeight: true
            Layout.fillWidth: true

            title: "PLC Digital Outputs"
            titleSize: 15
            spacing: 20

            Grid {
                id: gridOutputs
                x: titleLabel.paintedHeight // margin
                columns: 8
                spacing: 10
                columnSpacing: 30
                Repeater {
                    id: digitalOutput

                    delegate: Compact {
                        title: modelData.displayName
                        titleHAlignment: Qt.AlignHCenter
                        spacing: 3
                        Loader {
                            property int modelIndex: index
                            property var modeldata: modelData

                            width: root.indicatorSize
                            height: width

                            sourceComponent: toggleOutput ? compOutputButton : compOutputIndicator
                        }
                    }
                }
            }

            Component {
                id: compOutputIndicator
                WeaQuick.StatusIndicator {
                    borderWidth: 1
                    outerMargin: 3

                    levelActive: modeldata.coilActive ? modeldata.activeFeedback ? 1 : 2 : 2
                    active: modeldata.activeFeedback || modeldata.coilActive
                }
            }
            Component {
                id: compOutputButton
                SunkenButton {
                    id: btn
                    enabled: manualActive && modeldata.outputEnabled
                    checkable: false
                    checked: modeldata.activeFeedback
                    keyboardKey: modelIndex >= 9 ? Qt.NoButton : shortcuts[modelIndex].key
                    togglableKeyboardKey: modelIndex >= 9 ? false : shortcuts[modelIndex].togglable
                    onPressed: {
                        _plcIOModel.setCoilActive(modelIndex, !modeldata.coilActive);
                    }

                    // Binding Keyboard key
                    Connections {
                        target: manualPage

                        function onKeyPressed(key) {
                            btn.applyKeyboardPress(key);
                        }

                        function onKeyReleased(key) {
                            btn.applyKeyboardRelease(key);
                        }
                    }
                }
            }
        }
    }

    // Object & inline-components
    component Compact: Column {
        property alias title: titleLabel.text
        property alias titleSize: titleLabel.font.pixelSize
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleVAlignment: titleLabel.verticalAlignment
        property alias tittlePaintedHeight: titleLabel.paintedHeight
        property alias tittlePaintedWidth: titleLabel.paintedWidth
        property alias titleLabel: titleLabel

        spacing: 10

        WeaQuick.Label {
            id: titleLabel
        }
    }
}
