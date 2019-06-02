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
        text: qsTr("出题者列表")
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
        game.getExaminerList()
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
                text: "出题者"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortExaminerListBy("username")
                }
            }

            Sermo.Button {
                text: "等级"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortExaminerListBy("level")
                }
            }

            Sermo.Button {
                text: "出题数"
                font.pointSize: 24
                width: 150
                onClicked: {
                    listModel.clear()
                    game.sortExaminerListBy("numberWord")
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
                text: numberWord
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
        onAppendExaminer: {
            listModel.append({
                                 "username": username,
                                 "level": level,
                                 "numberWord": numberWord
                             })
        }
    }
}
