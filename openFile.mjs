WorkerScript.onMessage = function(message) {
    let textField = "";
    let textChanged = true;
    let request = new XMLHttpRequest();
    request.open("GET", message.fileUrl, false);
    request.onreadystatechange = function () {
        if(request.readyState === XMLHttpRequest.DONE){
            var response = request.responseText;
            textField = response;
            textChanged = false
        }
    }
    request.send();

    let encryptLang = "";
    let n = 0;
    let message2;
    console.log(message.fileUrl.toString().replace('.txt', '.key'));
    request = new XMLHttpRequest();
    request.open("GET", message.fileUrl.toString().replace('.txt', '.key'), false);
    request.onreadystatechange = function () {
        if(request.readyState === XMLHttpRequest.DONE){
            var response = request.responseText;
            if (response.toString().length<5) encryptLang = response.slice(0, -1).toString()
            else encryptLang = response.slice(0, -2).toString();
            console.log(response);
            response.slice(3) == 0?n = 0 :n = message.language0.length - response.slice(3);
            message.myScript = "rot.mjs"
            message2 = {'n': n, 'oldText' : textField, 'language0' : message.language0, 'language1' : message.language1};
        }
    }
    request.send();
    WorkerScript.sendMessage({ 'textField': textField, 'n' : n , "encryptLang" : encryptLang, 'textChanged' : textChanged, 'message2' : message2 })

}
