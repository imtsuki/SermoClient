import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "./Controls" as Sermo

Item {
    id: window
    visible: true
    anchors.fill: parent

    MouseArea {
        anchors.fill: parent
        onClicked: {
            friendTypeLayout.visible = false
        }
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
            id: friend
            background: Image {
                source: "Texture/friend.png"
            }
            onClicked: {
                friendTypeLayout.visible = !friendTypeLayout.visible
            }
        }

        Button {
            id: info
            background: Image {
                source: "Texture/info.png"
            }
            onClicked: {
                var component = Qt.createComponent(
                            "info.qml").createObject(window, {
                                                         "width": window.width,
                                                         "height": window.height
                                                     })
            }
        }
    }

    ColumnLayout {
        id: friendTypeLayout
        visible: false
        anchors.left: columnLayout.right
        anchors.top: columnLayout.top
        //anchors.topMargin: 20
        Sermo.Button {
            id: playerListButton
            text: qsTr("玩家列表")
            onClicked: {
                var component = Qt.createComponent(
                            "playerList.qml").createObject(window, {
                                                               "width": window.width,
                                                               "height": window.height
                                                           })
            }
        }

        Sermo.Button {
            id: examinerListButton
            text: qsTr("出题者列表")
            onClicked: {
                var component = Qt.createComponent(
                            "examinerList.qml").createObject(window, {
                                                                 "width": window.width,
                                                                 "height": window.height
                                                             })
            }
        }
    }

    Sermo.Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -110
        anchors.verticalCenter: parent.verticalCenter
        id: pveButton
        text: qsTr("开始闯关")
        onClicked: {
            var component = Qt.createComponent("pve.qml").createObject(window, {
                                                                           "width": window.width,
                                                                           "height": window.height
                                                                       })
        }
    }

    Sermo.Button {
        anchors.horizontalCenter: parent.horizontalCenter
        id: pvpButton
        text: qsTr("多人对战")
        anchors.horizontalCenterOffset: 110
        anchors.verticalCenter: parent.verticalCenter
        onClicked: {
            var component = Qt.createComponent(
                        "playerList.qml").createObject(window, {
                                                           "width": window.width,
                                                           "height": window.height
                                                       })
        }
    }

    Image {
        source: "Texture/抖叽.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    Connections {
        id: cppConnection
        target: game
        ignoreUnknownSignals: true
        onPvpBegin: {
            var component = Qt.createComponent("pvp.qml").createObject(window, {
                                                                           "width": window.width,
                                                                           "height": window.height
                                                                       })
        }
        onInviteCame: {
            var component = Qt.createComponent(
                        "invite.qml").createObject(window, {
                                                       "width": window.width,
                                                       "height": window.height
                                                   })
        }
    }
}
