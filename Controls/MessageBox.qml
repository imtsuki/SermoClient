import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

Popup {
    id: root
    property var message: "消息"
    property var button: "确定"
    padding: 0

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
                root.close()
            }
        }
    }
}
