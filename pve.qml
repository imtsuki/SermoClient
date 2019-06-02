import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "./Controls" as Sermo

Item {
    id: root
    visible: true
    anchors.fill: parent
    Keys.enabled: true
    focus: true

    MouseArea {
        anchors.fill: parent
        focus: true
        onClicked: {

        }
    }

    readonly property int startState: 1
    readonly property int preparingState: 2
    readonly property int typingState: 3
    readonly property int successState: 4
    readonly property int failedState: 5

    property var gameState: 1

    property var round: 1

    property var input: ""

    property var correctWord: "red"
    property var wordList: []
    property var index: 0

    property var exp: 0

    Binding {
        id: wordBinding
        target: wordLabel
        property: "text"
        value: input + "_"
        when: root.gameState == root.typingState
              || root.gameState == root.failedState
    }

    Image {
        width: parent.width
        height: parent.height
        source: "Texture/background.png"
    }

    Text {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        text: "第 " + round + " 关"
        anchors.leftMargin: 10
        anchors.bottomMargin: 10
        font.pointSize: 24
    }

    Text {
        id: progess
        visible: false
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        text: "第 " + (index + 1) + " 个单词，共 " + wordList.length + " 个单词"
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        font.pointSize: 24
    }

    Timer {
        id: timer
        interval: 10
        repeat: true
        property var counts: 300
        onTriggered: {
            counts = counts - 1
            var timeStr = Math.floor(
                        counts / 100) + ":" + ("" + (100 + counts % 100)).substr(
                        1)
            switch (root.gameState) {
            case root.startState:
                if (counts == 200) {
                    tip.font.pointSize = 72
                    tip.text = "准备好……"
                }

                if (counts == 100) {
                    tip.font.pointSize = 96
                    tip.text = "开始！"
                }

                if (counts == 0) {
                    root.gameState = root.preparingState
                    tip.visible = false
                    tip.font.pointSize = 60
                    remainTime.visible = true
                    wordLabel.visible = true
                    wordLabel.text = root.correctWord
                    upperTip.visible = true
                    progess.visible = true
                    ////////////////////
                    counts = Math.round((1 + 4 / round) * 100)
                }
                break
            case root.preparingState:
                upperTip.text = "睁大眼睛……"
                remainTime.text = timeStr
                if (counts == 0) {
                    ///////
                    counts = 300
                    root.gameState = root.typingState
                }
                break
            case root.typingState:
                upperTip.text = "抓紧时间！"
                remainTime.text = timeStr
                if (counts == 0) {
                    ///////
                    counts = 100
                    root.gameState = root.failedState
                }
                break
            case root.successState:
                upperTip.text = "正确！"
                wordLabel.color = "#00DD00"
                if (counts == 0) {
                    index++
                    if (index == wordList.length) {
                        timer.stop()
                        game.submitPVEResult(true, round, exp * round)
                        root.destroy()
                    } else {
                        counts = Math.round((1 + 4 / round) * 100)
                        root.correctWord = wordList[index]
                        wordLabel.color = "#000000"
                        wordLabel.text = root.correctWord
                        root.gameState = root.preparingState
                        root.input = ""
                    }
                }
                break
            case root.failedState:
                upperTip.text = "很遗憾……"
                wordLabel.color = "#FF0000"
                if (counts == 0) {
                    game.submitPVEResult(false, round, 0)
                    root.destroy()
                    //counts = 300;
                    //wordLabel.color = "#000000";
                    //wordLabel.text = root.correctWord;
                    //root.gameState = root.preparingState;
                    //root.input = "";
                }
                break
            }
        }
    }

    Text {
        id: tip
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        font.pointSize: 60
        text: "注意……"
    }

    Text {
        id: remainTime
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: 100
        font.pointSize: 60
        text: "0"
        font.family: "Courier"
    }

    Text {
        id: wordLabel
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pointSize: 120
        text: "contradict"
        font.family: "Courier"
    }

    Text {
        id: upperTip
        visible: false
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        anchors.verticalCenterOffset: -100
        font.pointSize: 48
        text: "睁大眼睛……"
    }

    Button {
        id: front
        background: null
        anchors.fill: parent
        focus: true
        Keys.enabled: true
        Keys.onPressed: {
            if (root.gameState == root.typingState) {
                if (event.key >= Qt.Key_A && event.key <= Qt.Key_Z) {
                    input = input + event.text
                } else if (event.key === Qt.Key_Backspace) {
                    input = input.substring(0, input.length - 1)
                }

                if (input === root.correctWord) {
                    console.log("right")
                    exp += Math.round(timer.counts / 10)
                    root.gameState = root.successState
                    wordLabel.text = root.correctWord + "✓"
                    timer.counts = 100
                }
            }
        }
    }

    ColumnLayout {
        id: columnLayout
        spacing: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: parent.left
        anchors.leftMargin: 20

        Button {
            id: pause
            background: Image {
                source: "Texture/pause.png"
            }
            onClicked: {
                continueLayout.visible = true
                timer.stop()
                //root.destroy();
            }
        }
    }

    ColumnLayout {
        id: continueLayout
        visible: false
        anchors.left: columnLayout.right
        anchors.top: columnLayout.top
        Sermo.Button {
            id: continueButton
            text: qsTr("继续游戏")
            onClicked: {
                timer.start()
                pause.background.source = "Texture/pause.png"
                front.forceActiveFocus()
                continueLayout.visible = false
            }
        }
    }

    Component.onCompleted: {
        front.forceActiveFocus()
        round = game.getNextRoundNumber()
        wordList = game.startPVE(round)
        correctWord = wordList[index]
        timer.start()
    }

    Connections {
        id: cppConnection
        target: game
        ignoreUnknownSignals: true
    }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/

