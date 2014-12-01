function CabinetLoadFile($url) {
    try {
        var euSign = document.getElementById("euSign");
        euSign.SetCharset("UTF-16LE");
        euSign.SetUIMode(false);
        euSign.Initialize();
        euSign.width = "1px";
        euSign.SetUIMode(false);
        data = euSign.ReadFile($url);
        var returndata=euSign.VerifyInternal(data,false);
        var saveFilePath = euSign.SelectFile(true, filename);
        euSign.WriteFile(saveFilePath,returndata);
    } catch (e) {
        alert("Помилка при перевірці підпису" + e);
    } finally {
        euSign.Finalize();
    }
}
