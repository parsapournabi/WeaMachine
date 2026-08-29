import QtQuick 2.12
import QtQuick.Layouts 1.12

import CustomItems 1.0
import com.wearily.WeaQuick 1.0 as WeaQuick

// TODO: Make Styling better

Item {
    id: root

    // REQUIRED
    property StepConfig targetStepConfig

    property int controlHeight: 33
    property real spliterScale: 1.0
    property int titleSize: 22

    property alias title: lblTitle.text

    property alias labelTitle: lblTitle
    property alias spliterVisible: spliter.visible

    implicitHeight: 600

    // Saving options into the SettingFile
    signal writeRequest

    ColumnLayout {
        id: layout
        anchors.fill: parent
        spacing: 10

        Item {
            Layout.preferredWidth: parent.width * spliterScale
            Layout.preferredHeight: 20

            Rectangle {
                id: spliter
                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 1
                color: "orange"
            }
        }

        WeaQuick.GradientText {
            id: lblTitle
            Layout.fillWidth: true
            font {
                pixelSize: titleSize
                bold: true
            }
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "white"
                }
                GradientStop {
                    position: 1
                    color: "#FFA4A4A4"
                }
            }
        }

        Item {
            id: contentItem
            Layout.fillHeight: true
            Layout.fillWidth: true
            Layout.topMargin: 10
            Layout.leftMargin: 20
            Layout.rightMargin: 20

            GridLayout {
                anchors.fill: parent
                columns: 2
                rowSpacing: 10

                Item {
                    id: leftSide
                    // FIXME: Currently is out of service
                    visible: false
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors {
                            fill: parent
                        }
                        spacing: 10

                        WeaQuick.Label {
                            id: lblLeftSideTitle
                            font {
                                pixelSize: 20
                                bold: true
                            }
                            text: "Safety"
                        }

                        SpliterLine {
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 2
                        }

                        // Step action after Emergency
                        RowCompact {
                            title: "Step Restart Method:"

                            CusComboBox {
                                id: cmbBoxStepRestart
                                anchors {
                                    right: parent.right
                                    rightMargin: parent.rightPadding
                                }
                                width: 270
                                height: parent.height
                                labelSize: parent.fontSize
                                model: ["Restart at the Begining", "Continue the Steps"]
                            }
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }

                Item {
                    id: rightSide
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors {
                            fill: parent
                        }
                        spacing: 10

                        WeaQuick.Label {
                            id: lblRightSideTitle
                            font {
                                pixelSize: 20
                                bold: true
                            }
                            text: "Rules"
                        }

                        SpliterLine {
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 2
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                        }

                        // Step Name
                        RowCompact {
                            title: "Display Coils by Tag: "
                            WeaQuick.Switch {
                                id: swDisplayByTag
                                anchors {
                                    right: parent.right
                                    rightMargin: parent.rightPadding
                                }

                                indicatorWidth: 45
                                indicatorHeight: 22
                                handleShape: WeaQuick.Handle.HandleShape.Circular
                                handleSize: 16
                                checked: true
                            }
                        }

                        // Default Active Outputs
                        Title {
                            title: "Default Active Outputs"
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                        }

                        WeaQuick.Pane {
                            Layout.fillWidth: true

                            level: 1
                            flat: false

                            IOsCheckBox {
                                id: gridOutputs
                                anchors {
                                    left: parent.left
                                    right: parent.right
                                    top: parent.top
                                    margins: 25
                                    topMargin: 10
                                    bottomMargin: 0
                                }
                                fontSize: 14

                                model: {
                                    var result = [];

                                    const plcOuts = _plcIOModel.outputs;
                                    const len = plcOuts.length;
                                    const displayByTag = swDisplayByTag.checked;
                                    const activeCoils = targetStepConfig.defaultActiveCoils;
                                    for (var i = 0; i < len; ++i) {
                                        const item = plcOuts[i];
                                        const itemName = displayByTag ? item.displayName : item.name;
                                        /// FIXME: better condition fo isChecked
                                        const isChecked = activeCoils.indexOf(i) !== -1 || activeCoils.indexOf(String(
                                                                                                                   i)) !== -1;
                                        result.push({
                                                        name: itemName,
                                                        checked: isChecked && enabled,
                                                        enabled: enabled
                                                    });
                                    }
                                    return result;
                                }

                                onModelChanged: {
                                    refreshSize();
                                }
                            }
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                        }
                    }
                }

                // Footer
                Item {
                    id: footer
                    Layout.fillWidth: true
                    Layout.columnSpan: 2
                    Layout.preferredHeight: 90

                    CusDelayButton {
                        id: btnDlyWriteSetting
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                            rightMargin: 20
                            bottomMargin: 10
                        }
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
                }
            }
        }
    }

    // Slots
    onWriteRequest: {
        writeConfigs(targetStepConfig);
    }

    Component.onCompleted: {
        const targetName = targetStepConfig.objectName;
        if (targetName === undefined || targetName === null || targetName === "") {
            console.warn("targetStepConfigObjectName cannot be empty!", targetName);
            Qt.quit();
        }

        readConfigs(targetStepConfig);
    }

    /** functions **/
    function writeConfigs(otherStepConfig) {
        otherStepConfig.synchronize(gridOutputs.resultModel, cmbBoxStepRestart.currentIndex);
    }

    function readConfigs(otherStepConfig) {
        cmbBoxStepRestart.currentIndex = otherStepConfig.stepRestartMethod;
        // Repeater update
    }

    /** Inline Components **/
    component RowCompact: Item {

        property int fontSize: 16
        property int leftPadding: 0
        property int rightPadding: 20

        property alias title: titleLabelRow.text
        property alias titleVAlignment: titleLabelRow.verticalAlignment
        property alias titleHAlignment: titleLabelRow.horizontalAlignment
        property alias titleLabel: titleLabelRow

        Layout.fillWidth: true
        Layout.preferredHeight: controlHeight

        WeaQuick.Label {
            id: titleLabelRow
            anchors {
                left: parent.left
                leftMargin: parent.leftPadding
            }

            width: parent.width
            height: parent.height
            font.pixelSize: parent.fontSize
            horizontalAlignment: Qt.AlignLeft
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

    component Title: Column {

        property alias title: titleLabel.text
        property alias titleVAlignment: titleLabel.verticalAlignment
        property alias titleHAlignment: titleLabel.horizontalAlignment
        property alias titleLabel: titleLabel

        property alias shineColor: shineLine.color
        property alias shineWidth: shineLine.width
        property alias shineLine: shineLine

        Layout.fillWidth: true
        Layout.preferredHeight: controlHeight
        spacing: 7

        WeaQuick.Label {
            id: titleLabel
            width: parent.width
            height: parent.height
            font.pixelSize: 18
            horizontalAlignment: Qt.AlignHCenter
        }

        ShineLine {
            id: shineLine
            width: parent.width
            color: "orange"
        }
    }
}
