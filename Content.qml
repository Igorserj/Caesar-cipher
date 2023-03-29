import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Dialogs 1.3
import QtQml.WorkerScript 2.15

Item {
    id: content
    property string oldText: ""
    property string newText: ""
    property int n: 0
    property bool symbolChanged: false
    property bool textChanged: false
    readonly property var ukr1: ["а", "б", "в", "г", "ґ", "д", "е", "є", "ж", "з", "и", "і", "ї", "й", "к", "л", "м", "н", "о", "п", "р", "с", "т", "у", "ф", "х", "ц", "ч", "ш", "щ", "ь", "ю", "я"]
    readonly property var ukr2: ["А", "Б", "В", "Г", "Ґ", "Д", "Е", "Є", "Ж", "З", "И", "І", "Ї", "Й", "К", "Л", "М", "Н", "О", "П", "Р", "С", "Т", "У", "Ф", "Х", "Ц", "Ч", "Ш", "Щ", "Ь", "Ю", "Я"]

    readonly property var eng1: ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    readonly property var eng2: ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]

    property string encryptLang: "ukr"
    property var language: [ukr1, ukr2]

    property alias fileDialog: fileDialog
    property alias fileDialog2: fileDialog2
    property alias newDialog: newDialog
    property alias openDialog: openDialog
    property alias exitDialog: exitDialog
    property alias msg: msg
    property alias result: result
    property alias textField: textField

    onEncryptLangChanged: encryptLang
                          === "ukr" ? [language[0] = ukr1, language[1]
                                       = ukr2] : [language[0] = eng1, language[1] = eng2]
    onNewTextChanged: {
        result.text = newText
        content.textChanged = true
    }

    Rectangle {
        id: textRect
        color: "transparent"
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: height * 0.05
        height: 0.5 * parent.height
        width: 0.48 * parent.width
        ScrollView {
            anchors.fill: parent
            TextArea {
                id: textField
                //            anchors.fill: parent
                placeholderText: qsTr("Напишіть щось")
                onTextChanged: {
                    content.textChanged = true
                }
            }
        }
    }
    Rectangle {
        id: resultRect
        color: "transparent"
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.margins: height * 0.05
        height: 0.5 * parent.height
        width: 0.48 * parent.width
        ScrollView {
            anchors.fill: parent
            TextArea {
                id: result
                placeholderText: qsTr("Результат")
                readOnly: true
                selectByMouse: true
                selectByKeyboard: true
            }
        }
    }

    Button {
        id: acceptButton
        text: "Шифрувати/Розшифрувати"
        anchors.top: resultRect.bottom
        anchors.right: resultRect.right
        anchors.margins: resultRect.height * 0.05
        onClicked: {
            myScript.source = "rot.mjs"
            var message = {
                "n": n,
                "oldText": textField.text,
                "language0": language[0],
                "language1": language[1]
            }
            myScript.sendMessage(message)
        }
    }

    Column {
        anchors.top: textRect.bottom
        anchors.left: textRect.left
        anchors.bottom: parent.bottom
        anchors.right: acceptButton.left
        clip: true
        anchors.leftMargin: textRect.height * 0.05
        Repeater {
            model: content.encryptLang === "ukr" ? Math.ceil(
                                                       ukr1.length / 10) : Math.ceil(
                                                       eng1.length / 10)
            Row {
                spacing: 2
                property int rowIndex: index
                Repeater {
                    model: content.encryptLang
                           === "ukr" ? ((ukr1.length - rowIndex * 10)
                                        > 10 ? 10 : ukr1.length - rowIndex
                                               * 10) : ((eng1.length - rowIndex * 10)
                                                        > 10 ? 10 : eng1.length - rowIndex * 10)
                    Button {
                        text: index + rowIndex * 10
                        onClicked: n = index + rowIndex * 10
                    }
                }
            }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Оберіть файл"
        folder: shortcuts.home
        nameFilters: "*.txt"
        visible: false
        onFileUrlChanged: console.log(fileUrl)
        onAccepted: {
            myScript2.source = "openFile.mjs"
            var message = {
                "fileUrl": fileUrl,
                "language0": language[0],
                "language1": language[1],
                "myScript": myScript.source
            }
            myScript2.sendMessage(message)
            content.textChanged = false
        }
    }

    FileDialog {
        id: fileDialog2
        title: "Зберегти як"
        folder: shortcuts.home
        nameFilters: "*.txt"
        visible: false
        selectExisting: false
        onAccepted: {
            console.log("You choose: " + fileUrl.toString().slice(8))
            var url = fileUrl.toString().slice(8)
            var url2 = fileUrl.toString().slice(8).replace('.txt', '.key')
            backend.writing(url, url2, result.text, encryptLang, n)
            content.textChanged = false
        }
    }

    Dialog {
        id: newDialog
        visible: false
        title: "Увага!"
        Text {
            text: "У Вас є незбережені зміни, Ви хочете продовжити без збереження?"
        }
        standardButtons: Dialog.Yes | Dialog.No
        onYes: {
            n = 0
            result.text = ""
            textField.text = ""
            content.textChanged = false
        }
    }

    Dialog {
        id: openDialog
        visible: false
        title: "Увага!"
        Text {
            text: "У Вас є незбережені зміни, Ви хочете продовжити без збереження?"
        }
        standardButtons: Dialog.Yes | Dialog.No
        onYes: {
            fileDialog.open()
            content.textChanged = false
        }
    }

    Dialog {
        id: exitDialog
        visible: false
        title: "Увага!"
        Text {
            text: "У Вас є незбережені зміни, Ви хочете вийти без збереження?"
        }
        standardButtons: Dialog.Yes | Dialog.No
        onYes: {
            Qt.quit()
        }
    }

    Dialog {
        id: msg
        Label {
            text: "Програма розроблена студентом групи ІШІ-501 Сергієнком Ігорем"
        }
    }

    WorkerScript {
        id: myScript
        onMessage: newText = messageObject.newText
    }
    WorkerScript {
        id: myScript2
        onMessage: {
            textField.text = messageObject.textField
            //            content2.textField.text = messageObject.textField
            n = messageObject.n
            encryptLang = messageObject.encryptLang
            textChanged = messageObject.textChanged
            typeof (messageObject.message2) !== 'undefined' ? myScript.sendMessage(
                                                                  messageObject.message2) : {}
        }
    }
    //    function rot() {
    //        oldText = textField.text
    //        newText = ""
    //        let i = 0;
    //        let j = 0;
    //        let n = content.n
    //        for (i = 0; i < oldText.length; i++) {
    //            symbolChanged = false
    //            for (j = 0; j<language[0].length; j++) {
    //               symbolCheck(language[0], i, j, n)
    //            }
    //            for (j = 0; j<language[1].length; j++) {
    //               symbolCheck(language[1], i, j, n)
    //            }
    //            if (symbolChanged === false) {
    //                newText += oldText.substr(i, 1)
    //            }
    //        }
    //    }

    //    function openFile(fileUrl) {
    //        var request = new XMLHttpRequest();
    //        request.open("GET", fileUrl, false);
    //        request.onreadystatechange = function () {
    //            if(request.readyState === XMLHttpRequest.DONE){
    //                var response = request.responseText;
    //                textField.text = response;
    //                content.textChanged = false
    //            }
    //        }
    //        request.send();

    //        console.log(fileUrl.toString().replace('.txt', '.key'));
    //        request = new XMLHttpRequest();
    //        request.open("GET", fileUrl.toString().replace('.txt', '.key'), false);
    //        request.onreadystatechange = function () {
    //            if(request.readyState === XMLHttpRequest.DONE){
    //                var response = request.responseText;
    //                if (response.toString().length<5) encryptLang = response.slice(0, -1).toString()
    //                else encryptLang = response.slice(0, -2).toString();
    //                console.log(response);
    //                n = language[0].length - response.slice(3);
    //                rot();
    //            }
    //        }
    //        request.send();
    //    }
}
