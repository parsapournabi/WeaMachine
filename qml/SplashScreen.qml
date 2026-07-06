import QtQuick 2.12
import QtQuick.Controls 2.12

/*
* By Default settings, This component has some dependencies:
*  - logoImage (.png)
*  - splash-intro.frag (fragment shader)
*  - Orbitron font (orbitron-bold.otf)
*  - Rajdhani font (Rajdhani-Bold.ttf)
*
* These dependencies can be change by changing the properties values.
*/

Item {
    id: root

    /** Splash Properties **/
    // Read Only
    readonly property bool isMainLoaded: _private.isMainLoaded

    // REQUIRED
    property string mainFormSource: "" // Use this property when hot-reload process is active
    property Component mainFormSourceComponent // Target component after splash finished (Use it Release mode)

    property bool noSplashAnimation: false // Splash Animation (if false: mainFormComponent will be load implicitly)
    property real minimumDurationSec: 6.0 // second
    property int fadeInDelay: 500 // ms
    property int fadeOutDelay: 500 // ms

    property string titleText: "WEARILY"
    property string topLeftText: "WeaMachine Framework - Create Machines. Not Code."
    property string bottomLeftText: "VERSION 2.1.0"
    property string bottomRightText: "Copyright © 2026 P. Pournabi"

    property color baseColor: "white"
    property string fragmentShader: "qrc:/shaders/splash-intro.frag"
    property vector2d logoSize: Qt.vector2d(200, 200)
    property Image logoImage: Image {
        source: "qrc:/share/images/Wearily-Logo-Steel.png"
    }

    // First Intro
    property alias labelTopLeft: lblTopLeft
    property alias labelBottomLeft: lblBottomLeft
    property alias labelBottomRight: lblBottomRight
    property alias shaderEffectSplash: shaderEffect

    // Second Intro
    property alias titleUnderline: titleUnderline
    property alias labelTitle: lblTitle

    // Other
    property alias fontLoaderTitle: fontLoaderTitle
    property alias fontLoaderInfo: fontLoaderInfo
    property alias mainFormLoader: mainLoader

    /** Signals **/
    signal splashStarted
    signal splashFinished

    signal loadingStarted
    signal loadingCompleted

    opacity: 0.0

    /** First Intro **/

    // Splash Effect
    ShaderEffect {
        id: shaderEffect
        anchors.fill: parent
        visible: !_private.isMainLoaded && opacity > 0.0
        opacity: root.opacity

        property color u_baseColor: root.baseColor
        property vector2d u_resolution: Qt.vector2d(width, height)
        property vector2d u_logoSize: root.logoSize
        property real u_minimumDuration: root.minimumDurationSec
        property real u_time: _private.elapsed
        property variant u_source: logoImage

        fragmentShader: root.fragmentShader
    }

    // BottomRight Label (Version No)
    Label {
        id: lblBottomLeft
        anchors {
            left: parent.left
            bottom: parent.bottom
            margins: 10
        }
        visible: !_private.isMainLoaded && opacity > 0.0
        opacity: _private.firstIntroOpacity

        font {
            family: fontLoaderInfo.name
            pixelSize: 15
            bold: true
            letterSpacing: 2
        }
        color: "white"
        text: root.bottomLeftText
    }

    // BottomRight Label (Policy & Info)
    Label {
        id: lblBottomRight
        anchors {
            right: parent.right
            bottom: parent.bottom
            margins: 10
        }
        visible: !_private.isMainLoaded && opacity > 0.0
        opacity: _private.firstIntroOpacity
        font {
            family: fontLoaderInfo.name
            pixelSize: 15
            bold: true
            letterSpacing: 1
        }
        color: "white"
        text: root.bottomRightText
    }

    // TopLeft Label (Studio name)
    Label {
        id: lblTopLeft
        anchors {
            left: parent.left
            top: parent.top
            margins: 10
        }

        visible: !_private.isMainLoaded && opacity > 0.0
        opacity: _private.firstIntroOpacity
        font {
            family: fontLoaderInfo.name
            pixelSize: 15
            bold: true
            letterSpacing: 2
        }
        color: "white"
        text: root.topLeftText
    }

    /** Second Intro **/

    // Title
    Label {
        id: lblTitle
        x: parent.width / 2 - paintedWidth / 2 + 10
        y: parent.height / 2 - parent.height / 9
        visible: !_private.isMainLoaded && opacity > 0.0
        opacity: _private.secondIntroOpacity
        font {
            family: fontLoaderTitle.name
            pixelSize: 32
            bold: false
            letterSpacing: 10
        }
        color: "white"
        text: root.titleText
    }

    // Title Under Line
    ShineLine {
        id: titleUnderline
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: lblTitle.bottom
            topMargin: 10
        }
        visible: !_private.isMainLoaded && opacity > 0.0
        opacity: _private.secondIntroOpacity
        color: root.baseColor
        width: lblTitle.paintedWidth * 1.25
    }

    /** Main Screen (After Splash finished) **/
    Loader {
        id: mainLoader
        anchors.fill: parent
        onLoaded: {
            root.loadingCompleted(); // Emitting

            _private.showMainForm();
        }
    }

    /** Objects & Resources **/

    // Fonts
    FontLoader {
        id: fontLoaderTitle
        source: "qrc:/share/fonts/Orbitron/orbitron-bold.otf"
    }

    FontLoader {
        id: fontLoaderInfo
        source: "qrc:/share/fonts/Rajdhani/Rajdhani-Bold.ttf"
    }

    // Animations
    NumberAnimation {
        id: fadeInAnimation
        target: root
        property: "opacity"
        duration: root.fadeInDelay
        from: 0.0
        to: 1.0
        onStarted: {
            _private.firstIntroOpacity = 0.7;
        }

        onFinished: {
            _private.tmrFrame.start();
        }
    }

    NumberAnimation {
        id: fadeOutAnimation
        target: mainLoader.item
        property: "opacity"
        duration: root.fadeOutDelay
        from: 0.0
        to: 1.0
        onFinished: {
            _private.isMainLoaded = true;
            root.splashFinished(); // Emitting
        }
    }

    // Private
    QtObject {
        id: _private
        property bool isMainLoaded: false
        property real elapsed: 0.0 // Elapsed Timer (unit second)
        property real firstIntroOpacity: 0.0
        property real secondIntroOpacity: 0.0

        property Timer tmrFrame: Timer {
            property real _startTime: Date.now()

            running: false
            repeat: true
            interval: 16
            onTriggered: {
                _private.elapsed = (Date.now() - _startTime) * 0.001;
                if (_private.elapsed > (minimumDurationSec - 1.0) && _private.firstIntroOpacity !== 0.0) {
                    _private.firstIntroOpacity = 0.0;
                }

                if (_private.elapsed > (minimumDurationSec + 1.0) && _private.secondIntroOpacity !== 1.0) {
                    _private.secondIntroOpacity = 1.0;
                }

                if (_private.elapsed >= minimumDurationSec + 2.0) {
                    _private.loadMain();
                    stop();
                }
            }
            onRunningChanged: {
                _startTime = Date.now();
            }
        }

        Behavior on firstIntroOpacity {
            NumberAnimation {
                duration: 1000
            }
        }

        Behavior on secondIntroOpacity {
            NumberAnimation {
                duration: 1000
            }
        }

        function restoreMemories() {
            if (mainLoader.item) {
                mainLoader.item.visible = false;
                mainLoader.item.opacity = 0.0;
            }
            mainLoader.sourceComponent = undefined;

            root.opacity = 0.0;
            isMainLoaded = false;
            elapsed = 0.0;
            firstIntroOpacity = 0.0;
            secondIntroOpacity = 0.0;
        }

        function startFadeInAnimation() {
            fadeInAnimation.start();
        }

        function startFadeOutAnimation() {
            mainLoader.item.opacity = 0.0;
            mainLoader.item.visible = true;

            fadeOutAnimation.start();
        }

        function loadMain() {
            root.loadingStarted(); // Emitting

            root.opacity = 1.0;
            if (mainFormSource.length > 0) {
                // hot-reload enabled
                mainLoader.sourceComponent = Qt.createComponent(mainFormSource);
            } else {
                // Load from component
                mainLoader.sourceComponent = mainFormSourceComponent;
            }
        }

        function showMainForm() {
            if (noSplashAnimation) {
                isMainLoaded = true;

                mainLoader.item.opacity = 1.0;
                mainLoader.item.visible = true;

                root.splashFinished(); // Emitting
            } else {
                startFadeOutAnimation();
            }

            firstIntroOpacity = 0.0;
            secondIntroOpacity = 0.0;
        }
    }

    /** Functions **/
    function start() {
        if (!mainFormSourceComponent && !mainFormSource) {
            console.warn("mainSourceComponent/mainFormSource cannot be empty for SplashScreen!");
            Qt.quit();
        }

        root.splashStarted(); // Emitting

        _private.restoreMemories();

        if (noSplashAnimation) {
            // Directly Loading Main
            _private.loadMain();
        } else {
            _private.startFadeInAnimation();
        }
    }
}
