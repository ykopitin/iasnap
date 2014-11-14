function SubmitPetition(name) {  
    
    if ($('#FFModel_file_petition').val().length<2) 
    {
         alert('Завантажте файл у форматі PDF!');
    } 
    else 
    {
        var filepath=$('#FFModelfile_petition_fileedspath').val().toLocaleString().match(/\.pdf$/);
        if (filepath!=null) {
            var formname="#" + name + "_form";
            $(formname).submit();
        }
        else 
        {
            alert('Файл повинен бути у форматі PDF!');
        }        
    }
}