import QtQuick 2.12
import QtQuick.Controls 2.12

/// TODO: Make clean
/// TODO: Remove hardcode things
/// TODO: add FontLoader
/// TODO: add logical functions (start)
/// TODO: shader cleanup
/// TODO: QC/QA and add Lazy loading
/// TODO: add minimumDuration properties, enable/disable and ...

Item {
    id: root

    property var logoPic: Image {
        source: "file:///C:/Users/PARSA/Desktop/Logo1.png"
    }
    property color baseColor: "white"

    signal splashFinished

    opacity: 0.0
    Component.onCompleted: {
        opacity = 1.0;
        lblWeaMachine.opacity = 0.5;
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 1000
        }
    }

    ShaderEffect {
        id: shEffect
        anchors.fill: parent

        property color uBaseColor: root.baseColor
        property vector2d uResolution: Qt.vector2d(width, height)
        property real iTime: 0.0
        property variant source: logoPic

        fragmentShader: "qrc:/shaders/splash-intro.frag"
        Timer {
            id: tmrFrame
            property real _st: root.visible ? Date.now() : 0.0 // Start Time
            property bool hasDone: false
            running: root.visible
            repeat: true
            interval: 16
            onTriggered: {
                parent.iTime = (Date.now() - _st) * 0.001;
                if (parent.iTime > 6.0) {
                    lblWeaMachine.opacity = 0.0;
                }

                if (parent.iTime > 7.0) {
                    lblWearily.opacity = 1.0;
                }

                if (parent.iTime >= 8.5 && !hasDone) {
                    hasDone = true;
                    root.splashFinished();
                }
            }
        }
    }

    // Shine Line
    ShineLine {
        id: shineLine
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: lblWearily.bottom
            topMargin: 10
        }
        color: root.baseColor
        width: lblWearily.paintedWidth * 1.25
        opacity: lblWearily.opacity
    }

    // VERSION
    Label {
        id: lblVersion
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 10
        }

        opacity: lblWeaMachine.opacity
        font {
            family: "Rajdhani"
            pixelSize: 15
            bold: true
            letterSpacing: 2
        }
        color: "white"
        text: "VERSION 2.1.0"
    }

    // WEARILY STUDIO
    Label {
        id: lblWeaStudio
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 10
        }

        opacity: lblWeaMachine.opacity
        font {
            family: "Rajdhani"
            pixelSize: 15
            bold: true
            letterSpacing: 1
        }
        color: "white"
        text: "Copyright © 2026 P. Pournabi"
    }

    // WEA MACHINE
    Label {
        id: lblWeaMachine
        anchors {
            left: parent.left
            top: parent.top
            margins: 10
        }

        opacity: 0.0
        font {
            family: "Rajdhani"
            pixelSize: 15
            bold: true
            letterSpacing: 2
        }
        color: "white"
        text: "WeaMachine Framework - Create Machines. Not Code."
        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }
        }
    }

    // WEARILY Title
    Label {
        id: lblWearily
        x: parent.width / 2 - paintedWidth / 2 + 10
        y: parent.height / 2 - parent.height / 9
        opacity: 0.0
        font {
            family: "Orbitron"
            pixelSize: 32
            bold: true
            letterSpacing: 10
        }
        color: "white"
        text: "WEARILY"

        Behavior on opacity {
            NumberAnimation {
                duration: 1000
            }
        }
    }
}
