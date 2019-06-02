import QtQuick 2.12
import QtQuick.Controls 2.12

Button {
    font.pointSize: 24

    contentItem: Text {
        text: parent.text
        font: parent.font
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignTop
        topPadding: parent.down ? 10 : 5
    }

    background: Image {
        source: parent.down ? "qrc:/Texture/button_pressed.png" : "qrc:/Texture/button.png"
    }
}
