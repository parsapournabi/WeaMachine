import QtQuick 2.12
import QtQuick.Controls 1.4 as Q

BorderRectangle {
    id: root

    property int padding: 10
    property alias recordModel: recordModel

    level: 0
    title: "Records"

    ShineLine {
        id: shineLine
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            margins: padding
            topMargin: 0
        }
        color: "orange"
    }

    CusTableView {
        id: tableView
        anchors {
            top: shineLine.bottom
            left: parent.left
            right: parent.right
            bottom: recordFooter.top
            margins: padding
        }

        backgroundVisible: false

        Q.TableViewColumn {
            role: "no"
            title: "No"
            width: 45
        }
        Q.TableViewColumn {
            role: "xpos"
            title: "X-Axis Position (%1)".arg(globalConfig.xAxisConfig.unitName)
            width: 190
        }
        Q.TableViewColumn {
            role: "xspeed"
            title: "X-Axis Speed"
            width: 130
        }
        Q.TableViewColumn {
            role: "ypos"
            title: "Y-Axis Position (%1)".arg(globalConfig.yAxisConfig.unitName)
            width: 190
        }
        Q.TableViewColumn {
            role: "yspeed"
            title: "Y-Axis Speed"
            width: 130
        }
        model: recordModel
    }

    RecordFooter {
        id: recordFooter

        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: padding
        }
        width: parent.width
        height: 27

        removeButton.enabled: tableView.currentRow > -1
        cleanButton.enabled: tableView.rowCount > 0
        saveButton.enabled: tableView.rowCount > 0

        /** Slots **/
        shotButton.onPressed: {
            var x = servoXDevice.encoderPUU;
            var y = servoYDevice.encoderPUU;
            var item = {
                no: recordModel.count,
                xposPUU: x,
                xpos: globalConfig.xAxisConfig.toUnit(x),
                xspeed: servoXDevice.jogSpeed,
                yposPUU: y,
                ypos: globalConfig.yAxisConfig.toUnit(y),
                yspeed: servoYDevice.jogSpeed
            };
            recordModel.append(item);
        }

        saveButton.onClicked: {
            addSteps();
        }

        removeButton.onClicked: {
            tableView.removeCurrent();
            syncModel();
        }

        cleanButton.onClicked: {
            tableView.removeAll();
        }
    }

    ListModel {
        id: recordModel
    }

    /** Slots **/
    Connections {
        target: globalConfig.xAxisConfig
        function onGearRatioChanged() {
            syncModel();
        }
    }

    Connections {
        target: globalConfig.yAxisConfig
        function onGearRatioChanged() {
            syncModel();
        }
    }

    /** Functions **/
    function syncModel() {
        for (var i = 0; i < recordModel.count; ++i) {
            var item = recordModel.get(i);
            recordModel.setProperty(i, "no", i);
            recordModel.setProperty(i, "xpos", globalConfig.xAxisConfig.toUnit(item.xposPUU));
            recordModel.setProperty(i, "ypos", globalConfig.yAxisConfig.toUnit(item.yposPUU));
        }
    }

    function addSteps() {
        for (var i = 0; i < recordModel.count; ++i) {
            const modelItem = recordModel.get(i);
            var item = {
                "id": stepModel.count,
                "name": "Recorded #%1".arg(modelItem.no),
                "bitwiseenable": false,
                "bitwisemethod": 0,
                "xposactive": true,
                "xservoon": true,
                "xservohome": false,
                "xservopos": modelItem.xposPUU,
                "xservospd": modelItem.xspeed * 10,
                "xservoacc": 200,
                "xservodec": 200,
                "yposactive": true,
                "yservoon": true,
                "yservohome": false,
                "yservopos": modelItem.yposPUU,
                "yservospd": modelItem.yspeed * 10,
                "yservoacc": 200,
                "yservodec": 200,
                "plcoutputtargets": globalConfig.stepConfig.defaultActiveCoils,
                "conditionbits": [],
                "delay": 0
            };

            stepModel.addItem(item);
        }
    }
}
