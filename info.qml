import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "./Controls" as Sermo

Item {
    id: root
    visible: true
    anchors.fill: parent

    MouseArea {
        anchors.fill: parent
    }

    Image {
        width: parent.width
        height: parent.height
        source: "Texture/background.png"
    }

    Sermo.MessageBox {
        id: messageBox
        width: parent.width
        height: parent.height
    }

    ColumnLayout {
        id: columnLayout
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        Button {
            id: back
            background: Image {
                source: "Texture/back.png"
            }
            onClicked: {
                root.destroy()
            }
        }
    }

    Image {
        id: portrait
        anchors.verticalCenterOffset: 60
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        source: "Texture/info_portrait@2x.png"
        MouseArea {
            anchors.fill: parent
            onPressed: {
                portrait.source = "Texture/info_portrait_blink@2x.png"
            }
            onReleased: {
                portrait.source = "Texture/info_portrait@2x.png"
            }
        }
    }

    Text {
        text: "我的信息"
        font.pointSize: 48
        anchors.left: columnLayout.right
        anchors.leftMargin: 20
        anchors.top: columnLayout.top
        anchors.topMargin: 8
    }

    Text {
        id: infoText
        anchors.left: portrait.right
        anchors.top: portrait.top
        anchors.leftMargin: 20
        text: "昵称：null\n等级：null\n经验值：null\n已闯关卡数：null"
        font.pointSize: 40
    }

    Component.onCompleted: {
        infoText.text = game.getMyInfo()
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

