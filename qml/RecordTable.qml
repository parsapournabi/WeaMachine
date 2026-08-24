import QtQuick 2.12
import QtQuick.Controls 1.4 as Q

BorderRectangle {
	id: root

	property int padding: 10

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

		/** Slots **/
		removeButton.onClicked: {
			tableView.removeCurrent();
		}

		cleanButton.onClicked: {
			tableView.removeAll();
		}
	}

	ListModel {
		id: recordModel
		ListElement {
			no: "1"
			xpos: "6,127.000"
			ypos: "200.123"
			xspeed: "100.0"
			yspeed: "100.0"
		}
		ListElement {
			no: "2"
			xpos: "8,964.000"
			ypos: "1,542.001"
			xspeed: "800.0"
			yspeed: "700.5"
		}
		ListElement {
			no: "3"
			xpos: "10,000.71"
			ypos: "555.555"
			xspeed: "1250.0"
			yspeed: "1500.0"
		}
	}
}
