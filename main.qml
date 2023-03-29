import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import io.qt.examples.backend 1.0

ApplicationWindow {
    id: window
    width: 1280
    height: 720
    visible: true
    title: qsTr("Caesar2.0")
    menuBar: MenuBar {
        Menu {
            title: qsTr("&Файл")
            Action { text: qsTr("&Новий..."); onTriggered: newFile() }
            Action { text: qsTr("&Відкрити..."); onTriggered: opening()}
            Action { text: qsTr("Зберегти &як..."); enabled: content.result.text!==""; onTriggered: saveAsFile() }
            Action { text: qsTr("&Зберегти"); enabled: (content.fileDialog.fileUrl.toString()!=="" && content.textChanged==true)?true:(content.fileDialog2.fileUrl.toString()!=="" && content.textChanged==true)?true:false ; onTriggered: saveFile()}
            MenuSeparator { }
            Action { text: qsTr("Ви&хід"); onTriggered: content.textChanged?content.exitDialog.open():Qt.quit()}
        }
        Menu {
            title: "Шифр"
            Action { text: qsTr("&Шифрування/Розшифрування"); onTriggered: cipher() }
            Action { text: qsTr("&Дешифрування"); onTriggered: decipher()}
        }
        Menu {
            title: "?"
            Action {text: qsTr("&Про програму"); onTriggered: content.msg.open()}
        }
    }
    function newFile() {return (content.textChanged && content.textField.text!=="")?[content.newDialog.open()]:[content.n=0, content.result.text="", content.textField.text="", content.textChanged = false]}
    function opening() {return content.textChanged?[content.openDialog.open()]:content.fileDialog.open()}
    function saveFile() {var url; var url2; return content.fileDialog.fileUrl.toString()!==""?[url = content.fileDialog.fileUrl.toString().slice(8), url2 = content.fileDialog.fileUrl.toString().slice(8).replace('.txt', '.key'), backend.writing(url, url2, content.result.text, content.encryptLang, content.n), content.textChanged = false]:content.fileDialog2.fileUrl.toString()!==""?[url = content.fileDialog2.fileUrl.toString().slice(8), url2 = content.fileDialog2.fileUrl.toString().slice(8).replace('.txt', '.key'), backend.writing(url, url2, content.result.text, content.encryptLang, content.n), content.textChanged = false]:content.fileDialog2.open()}
    function saveAsFile() {content.fileDialog2.open()}
    function cipher() {content2.visible=false; content2.enabled=false; content.visible=true; content.enabled=true}
    function decipher() {content.visible=false; content.enabled=false; content2.visible=true; content2.enabled=true}

//    Button {
//        id: contentTab
//        height: contentContainer.height*0.1
//        anchors.left: parent.left
//        anchors.right: contentContainer.left
//        onClicked: {
//            content2.visible=false; content2.enabled=false
//            content.visible=true; content.enabled=true
//        }
//    }
//    Button {
//        id: contentTab2
//        height: contentContainer.height*0.1
//        anchors.top: contentTab.bottom
//        anchors.topMargin: 2
//        anchors.left: parent.left
//        anchors.right: contentContainer.left
//        onClicked: {
//            content.visible=false; content.enabled=false
//            content2.visible=true; content2.enabled=true
//        }
//    }
    Rectangle {
        id: contentContainer
        color: "transparent"
        border.width: 2
        border.color: "#22000000"
        height: window.height*0.8
        width: window.width*0.95
        anchors.horizontalCenter: parent.horizontalCenter

        Content {
            id: content
            anchors.fill: parent
        }
        Content2 {
            id: content2
            anchors.fill: parent
            visible: false
            enabled: false
        }
    }

    footer: ToolBar {
        ToolButton {
            text:  qsTr(content.encryptLang === "ukr"?("Мова шифрування Українська"):("Мова шифрування Англійська"))
            onClicked: content.encryptLang === "ukr"?[content.encryptLang = "eng", content.n = 0]:[content.encryptLang = "ukr", content.n = 0]
            anchors.horizontalCenter: parent.horizontalCenter
        }
        Label {
            text: qsTr("Кількість зміщень " + content.n)
            anchors.rightMargin: 5
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            horizontalAlignment: Qt.AlignHCenter
            verticalAlignment: Qt.AlignVCenter
        }
        ScrollView {
            width: 0.4*parent.width
            anchors.leftMargin: 5
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            TextArea {
                anchors.fill: parent
                enabled: false
                color: "white"
                text: ((content.fileDialog.fileUrl.toString()!=="")?content.fileDialog.fileUrl.toString().slice(8):content.fileDialog2.fileUrl.toString()!==""?content.fileDialog2.fileUrl.toString().slice(8):"") + (content.textChanged?"*":"")
            }
        }
    }
    BackEnd {
        id: backend
    }
}
