import QtQuick 2.2

Item {
    id: move_wait

    property string path

    Text {
        id: status_text
        y: move_wait.height/2 - height/2
        anchors.left: move_wait.left
        anchors.right: move_wait.right
        anchors.margins: 20*physicalPlatformScale
        font.pointSize: 15*fontsScale
        font.family: globalFontFamily
        horizontalAlignment: Text.AlignHCenter
        color: "#333333"
    }

    Timer{
        id: move_start
        interval: 1000
        repeat: false
        onTriggered: {
            kaqaz.setProfilePath( move_wait.path )
            success()
        }
    }

    Timer{
        id: close_timer
        interval: 1000
        repeat: false
        onTriggered: {
            main.popPreference()
        }
    }

    function back(){
        return true
    }

    function success(){
        status_text.text  = qsTr("Done Successfully")
        close_timer.start()
    }

    function failed(){
        status_text.text  = qsTr("Failed!")
        close_timer.start()
    }

    Connections{
        target: kaqaz
        onLanguageChanged: initTranslations()
    }

    function initTranslations(){
        status_text.text  = qsTr("Please Wait")
    }

    Component.onCompleted: {
        initTranslations()
        move_start.start()
        backHandler = move_wait
    }
}
