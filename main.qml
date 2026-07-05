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
    property string mainFormPath: "qml/MainForm.qml"

    Component {
        id: compSplashScreen

        SplashScreen {
            onSplashFinished: {
                console.log("Splash Screen is DONE", getCurrentTime());
                mainFormLoader.source = "";
                mainFormLoader.source = mainFormPath;
            }
        }
    }

    Loader {
        id: mainFormLoader
        anchors.fill: parent
        onLoaded: {
            console.log("MainForm has loaded: ", getCurrentTime());
            appLoader.item.opacity = 0.0;
            mainFormLoader.item.opacity = 1.0;
        }
    }

    Loader {
        id: appLoader
        anchors.fill: parent
        sourceComponent: compSplashScreen
        onLoaded: {
            console.log("Splash Screen has loaded: ", getCurrentTime());
        }
    }

    function getCurrentTime() {
        var dt = new Date();
        return Qt.formatTime(dt, "hh:mm:ss.zzz");
    }

    function doReload() {
        appLoader.sourceComponent = undefined;
        _engine.clearCache();
        appLoader.sourceComponent = compSplashScreen;
    }

    Shortcut {
        sequence: "`"
        onActivated: doReload()
    }
}
