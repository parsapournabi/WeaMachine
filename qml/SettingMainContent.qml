import QtQuick 2.12
import com.wearily.WeaQuick 1.0 as WeaQuick

WeaQuick.Pane {
    id: root

    property int currentIndex: 0
    property var settingPages: [plcInputSettingPage, plcOutputSettingPage, generalSettingPage, accessibilityPage]

    Component {
        id: plcInputSettingPage
        SettingPLCInputPage {}
    }

    Component {
        id: plcOutputSettingPage
        SettingPLCOuputPage {}
    }

    Component {
        id: generalSettingPage
        SettingGeneralPage {}
    }

    Component {
        id: accessibilityPage
        SettingAccessibilityPage {}
    }

    Loader {
        anchors.fill: parent
        sourceComponent: settingPages[currentIndex]
    }
}
