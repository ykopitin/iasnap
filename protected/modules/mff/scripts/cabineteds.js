function CabinetLoadFile(url) {
    try {
        var data=$.ajax({
            url: url,         
            async: false
        }).responseText;
        var euSign = document.getElementById("euSign");
        euSign.SetCharset("UTF-16LE");
        euSign.SetUIMode(false);
        euSign.Initialize();
        euSign.width = "1px";
        euSign.SetUIMode(false);        
        var returndata=euSign.VerifyInternal(data,false);
        var saveFilePath = euSign.SelectFile(true, "Документ.pdf");
        euSign.WriteFile(saveFilePath,returndata);  
    } catch (e) {
        alert("Помилка при ініціалізації апплету");
    } finally {
        euSign.Finalize();
    }
}
