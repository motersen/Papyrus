/*
    Copyright (C) 2014 Aseman
    http://aseman.co

    Papyrus is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Papyrus is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import AsemanTools 1.0


Rectangle {
    id: sync_item
    anchors.left: parent.left
    anchors.right: parent.right
    height: column.height + 20*Devices.density
    color: marea.pressed? "#880d80ec" : "#88ffffff"

    property alias image: img.source
    property alias text: txt.text

    signal clicked()

    Column {
        id: column
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: img
            anchors.horizontalCenter: parent.horizontalCenter
            width: 128*Devices.density
            height: width
            sourceSize: Qt.size(width,height)
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: txt
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 12*Devices.fontDensity
            font.family: AsemanApp.globalFontFamily
            color: "#007ee5"
        }
    }

    MouseArea {
        id: marea
        anchors.fill: parent
        onClicked: sync_item.clicked()
    }
}