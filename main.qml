import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3
import "./Controls" as Sermo

Window {
    id: window
    visible: true
    width: 1024
    height: 512
    title: qsTr("Sermo")
    property bool started: false

    Image {
        width: parent.width
        height: parent.height
        source: "Texture/background.png"
    }

    Text {
        id: inputUsernameLabel
        opacity: 0
        Behavior on opacity {
            PropertyAnimation {
                duration: 300
            }
        }
        anchors.right: inputs.left
        anchors.top: inputs.top
        text: qsTr("用户名：")
        anchors.topMargin: -27
        font.pixelSize: 24
    }

    Text {
        id: inputPasswordLabel
        opacity: 0
        Behavior on opacity {
            PropertyAnimation {
                duration: 300
            }
        }
        anchors.right: inputs.left
        anchors.top: inputs.top
        text: qsTr("密码：")
        anchors.topMargin: 44
        font.pixelSize: 24
    }

    Image {
        id: logo
        Behavior on opacity {
            PropertyAnimation {
                duration: 300
            }
        }
        anchors.top: parent.top
        anchors.topMargin: 120
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        source: "Texture/logo.png"
    }

    Image {
        source: "Texture/抖叽.png"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
    }

    RowLayout {
        id: checks
        opacity: 0
        Behavior on opacity {
            PropertyAnimation {
                duration: 300
            }
        }
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 120
        spacing: 20
        Sermo.RadioButton {
            id: examinerCheck
            text: qsTr("出题")
        }
        Sermo.RadioButton {
            id: playerCheck
            text: qsTr("游玩")
            checked: true
        }
    }

    Item {
        id: inputs
        width: 300
        height: 100
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        opacity: 0
        Image {
            id: inputbg
            source: "Texture/login_inputbg@2x.png"
        }
        TextField {
            id: usernameInput
            anchors.top: parent.top
            anchors.topMargin: -38
            anchors.left: parent.left
            anchors.leftMargin: 0
            placeholderText: qsTr("请输入用户名")
            background: null
            font.pointSize: 24
        }

        TextField {
            id: passwordInput
            anchors.top: parent.top
            anchors.topMargin: 39
            anchors.left: parent.left
            anchors.leftMargin: 0
            placeholderText: qsTr("请输入密码")
            background: null
            font.pointSize: 24
            echoMode: "Password"
        }
    }

    Sermo.MessageBox {
        id: messageBox
        width: parent.width
        height: parent.height
    }

    Connections {
        id: cppConnection
        target: game
        ignoreUnknownSignals: true
        onPopupMessage: {
            messageBox.message = message
            messageBox.open()
        }
        onLoginFinished: {
            var component
            if (userType === 0) {
                component = Qt.createComponent(
                            "start.qml").createObject(window, {
                                                          "width": window.width,
                                                          "height": window.height
                                                      })
            } else {
                component = Qt.createComponent(
                            "examinerStart.qml").createObject(window, {
                                                                  "width": window.width,
                                                                  "height": window.height
                                                              })
            }
        }

        onClosePopup: {
            messageBox.close()
        }
    }

    Sermo.Button {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.horizontalCenterOffset: -110
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 90
        id: signupButton
        text: qsTr("注册")
        Behavior on anchors.bottomMargin {
            PropertyAnimation {
                duration: 300
            }
        }
        onClicked: {
            if (!started) {
                startLoginOrRegister()
            } else {
                var userType = playerCheck.checked ? 0 : 1
                game.signup(usernameInput.text, passwordInput.text, userType)
            }
        }
    }

    Sermo.Button {
        anchors.horizontalCenter: parent.horizontalCenter
        id: loginButton
        text: qsTr("登录")
        anchors.horizontalCenterOffset: 110
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 90
        Behavior on anchors.bottomMargin {
            PropertyAnimation {
                duration: 300
            }
        }
        onClicked: {
            if (!started) {
                startLoginOrRegister()
            } else {
                game.login(usernameInput.text, passwordInput.text)
            }
        }
    }

    function startLoginOrRegister() {
        logo.opacity = 0
        inputPasswordLabel.opacity = 1
        inputUsernameLabel.opacity = 1
        checks.opacity = 1
        inputs.opacity = 1
        signupButton.anchors.bottomMargin = 40
        loginButton.anchors.bottomMargin = 40
        started = true
    }
}
