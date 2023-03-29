WorkerScript.onMessage = function(message) {
    let newText = ""
    let i = 0;
    let j = 0;
    let f = false;
    let f2 = false;
    let symbolChanged;
    for (i = 0; i < message.oldText.length; i++) {
        symbolChanged = false
        for (j = 0; j<message.language0.length; j++) {
            newText += symbolCheck(message.language0, i, j, message.n, message.oldText, symbolChanged)[0]
            j = symbolCheck(message.language0, i, j, message.n, message.oldText, symbolChanged)[1]
            symbolChanged = symbolCheck(message.language0, i, j, message.n, message.oldText, symbolChanged)[2]
            j==(message.language0.length-1)?f = true:f=false
        }
        for (j = 0; j<message.language1.length; j++) {
           newText += symbolCheck(message.language1, i, j, message.n, message.oldText, symbolChanged)[0]
            j = symbolCheck(message.language1, i, j, message.n, message.oldText, symbolChanged)[1]
            symbolChanged = symbolCheck(message.language1, i, j, message.n, message.oldText, symbolChanged)[2]
            j==(message.language1.length-1)?f2 = true:f2 = false
        }
        if (!symbolChanged && (f && f2)) {
            newText += message.oldText.substr(i, 1)
        }
    }
    WorkerScript.sendMessage({ 'newText': newText })
}

function symbolCheck(lang, i, j, n, oldText, symbolChanged) {
    var newText = ""
    if (oldText.substr(i, 1) === lang[j]) {
        if (j + n >= lang.length) newText += lang[(j+n)-lang.length]
        else newText += lang[j+n]
        j = lang.length
        symbolChanged = true
    }
    return [newText, j]
}
