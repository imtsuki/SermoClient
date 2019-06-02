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

    Text {
        text: "玩家列表"
        font.pointSize: 48
        anchors.left: columnLayout.right
        anchors.leftMargin: 20
        anchors.top: columnLayout.top
        anchors.topMargin: 8
    }

    ListModel {
        id: listModel
    }

    Component.onCompleted: {
        game.getPlayerList()
    }

    ListView {
        width: 800
        height: 300
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        cacheBuffer: 305

        model: listModel
        delegate: listDelegate

        header: Row {
            Sermo.Button {
                text: "昵称"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortPlayerListBy("username")
                }
            }

            Sermo.Button {
                text: "等级"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortPlayerListBy("level")
                }
            }

            Sermo.Button {
                text: "经验值"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortPlayerListBy("experience")
                }
            }

            Sermo.Button {
                text: "闯关数"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortPlayerListBy("achievement")
                }
            }

            Sermo.Button {
                text: "在线"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortPlayerListBy("online")
                }
            }
        }
        headerPositioning: ListView.PullBackHeader
    }

    Component {
        id: listDelegate
        Row {

            Text {
                text: username
                font.pointSize: 24
                width: 150
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                text: level
                font.pointSize: 24
                width: 150
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: experience
                font.pointSize: 24
                width: 150
                horizontalAlignment: Text.AlignHCenter
            }
            Text {
                text: achievement
                font.pointSize: 24
                width: 150
                horizontalAlignment: Text.AlignHCenter
            }
            Button {
                text: "挑战"
                width: 150
                visible: online
                onClicked: {
                    game.startPVP(username)
                }
            }

            Text {
                visible: !online
                text: "离线"
                font.pointSize: 24
                width: 150
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    Connections {
        id: cppConnection
        target: game
        ignoreUnknownSignals: true
        onAppendPlayer: {
            listModel.append({
                                 "username": username,
                                 "level": level,
                                 "achievement": achievement,
                                 "experience": experience,
                                 "online": online
                             })
        }
    }
}
