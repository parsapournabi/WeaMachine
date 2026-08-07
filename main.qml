import QtQuick 2.12
import QtQuick.Window 2.12

import "qml"

Window {
	id: appWindow
	width: 640
	height: 480
	visible: true
	visibility: Window.FullScreen
	title: qsTr("Injection Molding")
	color: "black"

	// qrc:/
	property string splashSource: "qml/SplashScreen.qml"
	property string projectVersion: "2.3.0"

	Component {
		id: compSplashScreen

		SplashScreen {
			mainFormSource: "qrc:/qml/MainForm.qml"
			bottomLeftText: "VERSION %1".arg(projectVersion)
		}
	}

	Loader {
		id: appLoader
		anchors.fill: parent
		sourceComponent: compSplashScreen
		onLoaded: {
			item.start();
		}
	}

	function doReload() {
		appLoader.sourceComponent = undefined;
		appLoader.source = "";
		_engine.clearCache();
		appLoader.setSource(splashSource, {
								mainFormSource: "MainForm.qml",
								noSplashAnimation: true,
								bottomLeftText: "VERSION %1".arg(projectVersion)
							});
	}

	Shortcut {
		sequence: "`"
		onActivated: doReload()
	}
}
