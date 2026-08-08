import QtQuick 2.12
import QtQuick.Controls 2.12
import Qt.labs.settings 1.1
import Qt.labs.platform 1.1
import com.wearily.WeaQuick 1.0 as WeaQuick
import CustomItems 1.0

Item {
	id: root

	property var pageComponents: [compHomePage, compManualPage, compSettingsPage]
	property var pageItems: [homePage, manualPage, settingsPage]
	property var popUps: [comPopup]

	property real elapsed: 0.0

	// Top Header
	AppHeader {
		id: appHeader
		anchors {
			top: parent.top
			right: parent.right
			left: parent.left
			topMargin: 5
		}

		onPageChanged: {
			if (swipeView.currentIndex !== index) {
				swipeView.currentIndex = index;
			}
		}

		// onPageChanged: {
		//     elapsed = Date.now();
		// }

		onOpenPopUp: {
			comPopup.open();
		}

		ShineLine {
			id: headerLine
			x: 20
			y: parent.height + 4
			width: parent.width - x * 2
			color: "orange"
		}
	}

	// Pages View
	Component {
		id: compHomePage
		// id: homePage
		HomePage {}
	}

	Component {
		id: compManualPage

		// id: manualPage
		ManualPage {}
	}

	Component {
		id: compSettingsPage

		// id: settingsPage
		SettingsPage {}
	}

	// Loader {
	//     id: pageLoader

	//     anchors {
	//         top: appHeader.bottom
	//         right: parent.right
	//         left: parent.left
	//         bottom: parent.bottom
	//         topMargin: headerLine.height + 5
	//     }
	//     sourceComponent: pageComponents[appHeader.pageButtonsItem.currentIndex]
	//     onLoaded: {
	//         console.log("PageLoaded: ", Date.now() - elapsed);
	//     }
	// }

	SwipeView {
		id: swipeView
		anchors {
			top: appHeader.bottom
			right: parent.right
			left: parent.left
			bottom: parent.bottom
			topMargin: headerLine.height + 5
		}

		onCurrentIndexChanged: {
			if (currentIndex !== appHeader.pageButtonsItem.currentIndex) {
				appHeader.pageButtonsItem.currentIndex = currentIndex;
			}
		}

		HomePage {
			id: homePage
		}

		ManualPage {
			id: manualPage
		}
		SettingsPage {
			id: settingsPage
		}
	}

	// Models
	StepModel {
		id: stepModel

		enabled: true // plcDevice.enabled && servoXDevice.enabled && servoYDevice.enabled
		plcModel: _plcIOModel
		xServoDevice: servoXDevice
		yServoDevice: servoYDevice
	}

	// Communications
	ModbusCom {
		id: plcModbusCom
		objectID: 400
		objectName: "PLCCOM"
		serialConn: comPopup.plcSerialConnection
		autoConnect: true
		threaded: false
		devices: [plcDevice]
	}

	ModbusCom {
		id: servoModbusCom
		objectID: 300
		objectName: "SCOM"
		serialConn: comPopup.servoSerialConnection
		autoConnect: true
		threaded: false
		devices: [servoXDevice, servoYDevice]
		refreshInterval: 300
	}

	ModbusTcp {
		id: plcModbusTcp
		objectID: 400
		objectName: "PLCTCP"
		tcpConn: comPopup.plcTcpConnection
		threaded: false
		devices: [plcDevice]
		refreshInterval: 100
	}

	ModbusTcp {
		id: servoXModbusTcp
		objectID: 400
		objectName: "STCPX"
		tcpConn: comPopup.servoTcpConnectionX
		threaded: false
		devices: [servoXDevice]
		refreshInterval: 300
	}

	ModbusTcp {
		id: servoYModbusTcp
		objectID: 400
		objectName: "STCPY"
		tcpConn: comPopup.servoTcpConnectionY
		threaded: false
		devices: [servoYDevice]
		refreshInterval: 300
	}

	/** Modbus Devices **/
	PlcModbusDevice {
		id: plcDevice
		objectName: "DVP28SA2"
		slaveAddress: 2
		onEnabledChanged: {
			if (comPopup.plcSerialConnection.connected || comPopup.plcTcpConnection.connected) {
				plcDevice.syncCoils();
			}
		}
	}

	ServoModbusDevice {
		id: servoYDevice
		objectName: "Servo-Y"
		slaveAddress: 3
	}

	ServoModbusDevice {
		id: servoXDevice
		objectName: "Servo-X"
		slaveAddress: 2
	}

	// Popups
	LoginPopup {
		id: loginPopup
	}

	// Config Popup
	StepPopup {
		id: stepPopup
	}

	InterruptPopup {
		id: interruptPopup
	}

	ComPopup {
		id: comPopup

		/** Slots **/
		onOpened: {
			serialGlobal.refreshPorts();
		}

		/** Tcp **/
		servoTcpConfigX.onOpenConnection: {
			servoXModbusTcp.openPort();
		}
		servoTcpConfigX.onCloseConnection: {
			servoXModbusTcp.closePort();
		}
		servoTcpConfigY.onOpenConnection: {
			servoYModbusTcp.openPort();
		}
		servoTcpConfigY.onCloseConnection: {
			servoYModbusTcp.closePort();
		}

		plcTcpConfig.onOpenConnection: {
			plcModbusTcp.openPort();
		}
		plcTcpConfig.onCloseConnection: {
			plcModbusTcp.closePort();
		}

		/** Serial **/
		servoSerialConfig.onOpenConnection: {
			servoModbusCom.openPort();
			servoModbusCom.autoConnect = true;
		}
		servoSerialConfig.onCloseConnection: {
			servoModbusCom.closePort();
			servoModbusCom.autoConnect = false;
		}

		plcSerialConfig.onOpenConnection: {
			plcModbusCom.openPort();
			plcModbusCom.autoConnect = true;
		}
		plcSerialConfig.onCloseConnection: {
			plcModbusCom.closePort();
			plcModbusCom.autoConnect = false;
		}
	}

	FileDialog {
		id: saveFileDialog
		fileMode: FileDialog.SaveFile
		defaultSuffix: "json"
	}

	FileDialog {
		id: openFileDialog
		fileMode: FileDialog.OpenFile
		defaultSuffix: "json"
	}

	// Overlay (Pop-up will enable this)
	BackgroundOverlay {
		id: overlay
		anchors.fill: parent
	}

	// Objects
	SerialGlobal {
		id: serialGlobal
	}

	WeaQuick.GlobalContext {
		id: wQuick
	}

	GlobalConfig {
		id: globalConfig
	}

	// AppSetting
	Settings {
		id: settings

		property alias currentPageIndex: swipeView.currentIndex
		property alias plcName: appHeader.title
	}
}
