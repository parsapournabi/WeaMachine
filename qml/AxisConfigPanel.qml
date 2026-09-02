import QtQuick 2.12
import QtQuick.Layouts 1.12

import CustomItems 1.0
import com.wearily.WeaQuick 1.0 as WeaQuick

Item {
    id: root

    // REQUIRED
    property AxisConfig targetAxisConfig

    property int controlHeight: 33
    property real spliterScale: 1.0
    property int titleSize: 22

    property alias title: lblTitle.text

    property alias labelTitle: lblTitle
    property alias spliterVisible: spliter.visible

    // implicitHeight: 900
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

                // Encoder Setting
                Item {
                    id: topSide
                    // FIXME: Currently is out of service
                    visible: false
                    Layout.fillWidth: true
                    Layout.preferredHeight: 300
                    Layout.columnSpan: 2

                    ColumnLayout {
                        id: layoutC
                        anchors {
                            fill: parent
                        }
                        spacing: 20

                        WeaQuick.Label {
                            font {
                                pixelSize: 20
                                bold: true
                            }
                            text: "Positioning Configuration"
                        }

                        SpliterLine {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 2
                        }

                        // Action Mode
                        RowCompact {
                            title: "Action Mode at Position Freezing:"
                            fontSize: 17

                            CusComboBox {
                                id: cmbActionModeError
                                anchors {
                                    right: parent.right
                                    rightMargin: parent.rightPadding
                                }
                                width: 300
                                height: parent.height
                                labelSize: parent.fontSize
                                model: ["Emergency and Stop", "Retry and Continue"]
                                onCurrentIndexChanged: {
                                    helper.axisConfig.actionMode = currentIndex;
                                }
                            }
                        }

                        // Encoder Tolerance
                        RowCompact {
                            title: "Encoder Tolerance:"
                            fontSize: 17

                            ConfigEditBox {
                                id: editBoxEncTolerance
                                width: 300
                                suffix: " PUU"
                                onValueChanged: {
                                    helper.axisConfig.encoderTolerance = value;
                                }
                            }
                        }

                        // Position Retries
                        RowCompact {
                            title: "Position Failure Retries:"
                            fontSize: 17

                            ConfigEditBox {
                                id: editBoxPosRetries
                                width: 300
                                from: 0
                                onValueChanged: {
                                    helper.axisConfig.positionRetries = value;
                                }
                            }
                        }

                        // Position Error Timeout
                        RowCompact {
                            title: "Position Error Timeout:"
                            fontSize: 17

                            ConfigEditBox {
                                id: editBoxPosTimeout
                                width: 300
                                stepSize: 50
                                suffix: " ms"
                                onValueChanged: {
                                    helper.axisConfig.positionErrorCheckDelay = value;
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

                Item {
                    id: leftSide
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
                            text: "Unit Scaling"
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

                        // Formula
                        WeaQuick.Label {
                            Layout.alignment: Qt.AlignHCenter
                            font.pixelSize: 17
                            text: "Position = (EncoderPUU - Zero Offset) x D / N"
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 5
                        }

                        // Numerator
                        RowCompact {
                            title: "N (Numerator):"

                            ConfigEditBox {
                                id: editBoxN
                                value: helper.axisConfig.numerator
                                onValueChanged: {
                                    helper.axisConfig.setScale(editBoxN.value, editBoxD.value);
                                }
                            }
                        }

                        // Denominator
                        RowCompact {
                            title: "D (Denominator):"

                            ConfigEditBox {
                                id: editBoxD
                                value: helper.axisConfig.denominator
                                onValueChanged: {
                                    helper.axisConfig.setScale(editBoxN.value, editBoxD.value);
                                }
                            }
                        }

                        // Zero Offset
                        RowCompact {
                            title: "Zero Offset (PUU):"

                            ConfigEditBox {
                                id: editBoxZeroOffset
                                from: -Math.pow(2, 32) / 2
                                value: helper.axisConfig.zeroPUU
                                onValueChanged: {
                                    helper.axisConfig.setZeroPUU(value);
                                }
                            }
                        }

                        // Decimal Count
                        RowCompact {
                            title: "Display Decimal Count:"

                            ConfigEditBox {
                                id: editBoxDecimalCnt
                                from: 0
                                value: helper.axisConfig.decimals
                                to: helper.maxDecimals
                            }
                        }

                        // Unit
                        RowCompact {
                            title: "Display Unit:"

                            WeaQuick.LineEdit {
                                id: lineEditUnit
                                anchors {
                                    right: parent.right
                                    rightMargin: parent.rightPadding
                                }

                                width: 200
                                height: parent.height

                                level: 2
                                font.pixelSize: 15
                                placeholderText: "mm, cm, inch, ..."
                                text: helper.axisConfig.unitName
                                horizontalAlignment: Qt.AlignHCenter
                                selectByMouse: true
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
                        anchors.fill: parent
                        WeaQuick.Label {
                            id: lblRightSideTitle
                            font {
                                pixelSize: 19
                                bold: true
                            }
                            text: "Preview"
                        }

                        SpliterLine {
                            Layout.preferredWidth: parent.width
                            Layout.preferredHeight: 2
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 25
                        }

                        Repeater {
                            id: repeaterPuuUnit
                            model: 6
                            delegate: PuuUnit {
                                leftValue: Math.pow(10, index)
                                rightSuffix: " " + helper.axisConfig.unitName
                            }
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 10
                        }

                        Repeater {
                            id: repeaterUnitPuu
                            model: 6
                            delegate: PuuUnit {
                                leftValue: Math.pow(10, index)
                                leftSuffix: " " + helper.axisConfig.unitName
                                rightSuffix: " PUU"
                            }
                        }

                        // Spacer
                        Item {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 10
                        }

                        RowLayout {
                            Layout.fillWidth: true
                            Layout.preferredHeight: controlHeight

                            spacing: 10

                            WeaQuick.Label {
                                font.pixelSize: 17
                                horizontalAlignment: Qt.AlignLeft
                                text: "Try it: "
                            }

                            PosEditBox {
                                id: posEditBoxSample
                                Layout.preferredWidth: 250
                                Layout.preferredHeight: controlHeight

                                level: 2
                                font.pixelSize: 15
                                axisConfig: helper.axisConfig
                                stepSize: 1 / Math.pow(10, decimals)
                            }

                            WeaQuick.Label {
                                font.pixelSize: 20
                                horizontalAlignment: Qt.AlignLeft
                                text: "--->"
                            }

                            NumLabel {
                                font.pixelSize: 17
                                value: helper.axisConfig.toPUU(posEditBoxSample.value)
                                suffix: " PUU"
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

                    WriteButton {
                        id: btnDlyWriteSetting
                        anchors {
                            right: parent.right
                            bottom: parent.bottom
                            rightMargin: 20
                            bottomMargin: 10
                        }

                        onWriteRequest: root.writeRequest()
                    }
                }
            }
        }
    }

    // Slots
    onWriteRequest: {
        writeConfigs(targetAxisConfig);
    }

    Component.onCompleted: {
        const targetName = targetAxisConfig.objectName;
        if (targetName === undefined || targetName === null || targetName === "") {
            console.warn("targetAxisConfigObjectName cannot be empty!", targetName);
            Qt.quit();
        }

        readConfigs(targetAxisConfig);
    }

    // Helper
    QtObject {
        id: helper

        property int maxDecimals: 0

        property AxisConfig axisConfig: AxisConfig {
            objectName: targetAxisConfig.objectName
            unitName: lineEditUnit.text
            decimals: editBoxDecimalCnt.value
            onGearRatioChanged: {
                helper.maxDecimals = maxDecimals;

                helper.applyConfigs();
            }
        }

        function applyConfigs() {
            // PuuUnit
            var puuUnit = repeaterPuuUnit;
            for (let i = 0; i < puuUnit.count; ++i) {
                var unitItem = puuUnit.itemAt(i);
                unitItem.rightValue = axisConfig.toUnit(unitItem.leftValue);
            }

            // UnitPuu
            var unitPuu = repeaterUnitPuu;
            for (let j = 0; j < unitPuu.count; ++j) {
                var puuItem = unitPuu.itemAt(j);
                puuItem.rightValue = axisConfig.toPUU(puuItem.leftValue);
            }
        }
    }

    /** functions **/
    function writeConfigs(otherAxisConfig) {
        otherAxisConfig.synchronize(helper.axisConfig);
    }

    function readConfigs(otherAxisConfig) {
        // Unit Scaling
        editBoxN.value = otherAxisConfig.numerator;
        editBoxD.value = otherAxisConfig.denominator;
        editBoxZeroOffset.value = otherAxisConfig.zeroPUU;
        helper.maxDecimals = otherAxisConfig.maxDecimals;
        editBoxDecimalCnt.value = otherAxisConfig.decimals;
        lineEditUnit.text = otherAxisConfig.unitName;
        // Positioning Config
        cmbActionModeError.currentIndex = otherAxisConfig.actionMode;
        editBoxEncTolerance.value = otherAxisConfig.encoderTolerance;
        editBoxPosRetries.value = otherAxisConfig.positionRetries;
        editBoxPosTimeout.value = otherAxisConfig.positionErrorCheckDelay;
    }

    /** inline **/
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

    component ConfigEditBox: WeaQuick.EditBox {
        anchors {
            right: parent.right
            rightMargin: parent.rightPadding
        }
        width: 200
        height: parent.height
        level: 2

        font.pixelSize: parent.fontSize - 1
        from: 1
        value: 1
        to: Math.pow(2, 32) / 2 - 1
        decimals: 0
        stepSize: 1
    }

    component PuuUnit: Row {
        property int fontSize: 16

        property alias leftValue: lblLeft.value
        property alias leftDecimals: lblLeft.decimals
        property alias leftSuffix: lblLeft.suffix

        property alias rightValue: lblRight.value
        property alias rightDecimals: lblRight.decimals
        property alias rightSuffix: lblRight.suffix

        NumLabel {
            id: lblLeft
            font.pixelSize: parent.fontSize
            suffix: " PUU"
        }

        WeaQuick.Label {
            font.pixelSize: parent.fontSize
            text: " = "
        }

        NumLabel {
            id: lblRight
            font.pixelSize: parent.fontSize
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
