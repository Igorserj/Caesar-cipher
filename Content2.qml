import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQml.WorkerScript 2.15

Item {
    id: content2
    property string newText: ""

    Rectangle {
        id: textRect
        color: "transparent"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.margins: parent.height*0.05
        width: 0.48*parent.width
        ScrollView {
            anchors.fill: parent
            TextArea {
                id: textField
                text: content.textField.text
                placeholderText: qsTr("Напишіть щось")
                onTextChanged: {content.textChanged = true
                    content.textField.text = text
                    text = Qt.binding(function() {return content.textField.text})
                }
            }
        }
    }
    Rectangle {
        id: resultRect
        color: "transparent"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: textRect.right
        anchors.margins: parent.height*0.05
        width: 0.48*parent.width
        Row {
            anchors.fill: parent
            spacing: 5
            Button {
                id: acceptButton
                text: "Дешифрувати"
                onClicked: {
                    myScript.source = "rot2.js"
                    for (let i = 0; i<resultRepeater.model; i++) {
                        var message = {'n': i, 'oldText' : content.textField.text, 'language0' : content.language[0], 'language1' : content.language[1], 'index' : i}
                        myScript.sendMessage(message);
                    }
                }
            }
            Column {
                ScrollView {
                    height: resultRect.height
                    clip: true
                    Column {
                        Repeater {
                            id: resultRepeater
                            model: content.encryptLang === "ukr"?content.ukr1.length:content.eng1.length
                            Button {
                                width: text!==""?implicitWidth:0
                                anchors.right: parent.right
                                onClicked: content.n = index
                            }
                        }
                    }
                }
            }
        }
    }
    WorkerScript {
        id: myScript
        onMessage: resultRepeater.itemAt(messageObject.index).text = [messageObject.index + " " + messageObject.newText].toString()
    }
}
