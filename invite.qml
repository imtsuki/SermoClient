import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "./Controls" as Sermo

Item {
    id: root
    visible: true
    anchors.fill: parent
    property var message: "player 想要挑战你"
    property var button: "确定"

    MouseArea {
        anchors.fill: parent
    }

    Image {
        width: parent.width
        height: parent.height
        source: "qrc:/Texture/message.png"

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 50
            anchors.verticalCenter: parent.verticalCenter
            font.pointSize: 24
            width: 300
            wrapMode: Text.WrapAnywhere
            text: root.message
        }

        Text {
            font.pointSize: 24
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.horizontalCenterOffset: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 70
            text: root.button
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                game.acceptInvite()
                root.destroy()
            }
        }
    }

    Connections {
        id: cppConnection
        target: game
        ignoreUnknownSignals: true
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:512;width:1024}
}
 ##^##*/

