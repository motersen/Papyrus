import QtQuick 2.2

Item {
    id: insert_image_dialog
    width: 100
    height: 62

    Image {
        id: back_img
        anchors.fill: parent
        anchors.topMargin: -statusBarHeight
        anchors.bottomMargin: -navigationBarHeight
        source: "files/menu_background.jpg"
        fillMode: Image.PreserveAspectCrop
    }

    property variant nextPage

    signal selected( string repID )

    onNextPageChanged: {
        if( nextPage ){
            back_img.visible = false
            darkBackground = true
        } else {
            back_img.visible = true
            darkBackground = false
        }
    }

    Header {
        id: title
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        light: true
    }

    ListView {
        id: image_types_list
        anchors.top: title.bottom
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 20*physicalPlatformScale
        highlightMoveDuration: 250
        clip: true

        model: ListModel {}
        delegate: Rectangle {
            id: item
            width: image_types_list.width
            height: 60*physicalPlatformScale
            color: press? "#3B97EC" : "#00000000"

            property string fileName: file
            property string command: cmd
            property string text: name
            property bool press: false

            Connections{
                target: image_types_list
                onMovementStarted: press = false
                onFlickStarted: press = false
            }

            Text{
                id: txt
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.margins: 30*physicalPlatformScale
                y: parent.height/2 - height/2
                text: parent.text
                font.pointSize: 15*fontsScale
                font.family: globalFontFamily
                color: "#ffffff"
            }

            MouseArea{
                anchors.fill: parent
                onPressed: item.press = true
                onReleased: item.press = false
                onClicked: {
                    if( item.fileName.length != 0 ) {
                        var component = Qt.createComponent(fileName);
                        var obj = component.createObject(main);
                        obj.selected.connect( insert_image_dialog.selected )
                        main.pushPreference(obj)
                        insert_image_dialog.nextPage = obj
                    } else {
                        if( item.command == "picture" ) {
                            kaqaz.getOpenPictures()
                        }
                    }
                }
            }
        }

        focus: true
        highlight: Rectangle { color: "#3B97EC"; radius: 3; smooth: true }
        currentIndex: -1

        onCurrentItemChanged: {
            if( !currentItem )
                return
        }

        Connections{
            target: kaqaz
            onLanguageChanged: image_types_list.refresh()
        }

        function refresh(){
            model.clear()
            model.append({"name": qsTr("Camera"), "file": "CameraDialog.qml", "cmd": ""})
            model.append({"name": qsTr("Document"), "file": "DocumentDialog.qml", "cmd": "" })
            model.append({"name": qsTr("Gallery"), "file": "GalleryDialog.qml", "cmd": "picture" })
            model.append({"name": qsTr("Music"), "file": "MusicDialog.qml", "cmd": "" })
            focus = true
        }

        Component.onCompleted: refresh()
    }

    ScrollBar {
        scrollArea: image_types_list; height: image_types_list.height; width: 8
        anchors.right: image_types_list.right; anchors.top: image_types_list.top;color: "#ffffff"
    }

    Connections{
        target: kaqaz
        onLanguageChanged: initTranslations()
    }

    function initTranslations(){
        title.text = qsTr("Insert Attachment")
    }

    Component.onCompleted: {
        initTranslations()
    }
}
