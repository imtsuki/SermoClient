import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.3

RadioButton {
    indicator: RowLayout {
        width: 70
        Image {
            fillMode: Image.PreserveAspectFit
            source: parent.parent.checked ? "qrc:/Texture/toggle_checked_bg.png" : "qrc:/Texture/togglebg.png"
        }
    }
    font.pointSize: 24
}
