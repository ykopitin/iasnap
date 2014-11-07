<p style="font-weight: bold; font-size: 14pt">Тестирование СФ</p>
<?php
if ($this->action->id=="save") {
    $ff=$this->widget('mff.components.FF.FFWidget',
            array(
                "idregistry"=>14,
                "idstorage"=>8,      
                "backurl"=>$this->createUrl("/mff/formview/index",array("id"=>8)),
                )
            );
    echo CHtml::button("Сохранить",array("onclick"=>$ff->name."_form.submit()"));
} else {
    $url=$this->createUrl(
                    "/mff/formview/save", 
                    array(
                        "idregistry"=>14,
                        "idstorage"=>8,
                        "thisrender"=>base64_encode("mff.views.default.testff"),));
    echo "Для проверки регистрации документа нажмите ".CHtml::link("Зарегистрировать",$url);
}
?>
<p>Тестовый пример для регистрации документа через свободные формы.
На странице где мы хотим разместить ссылку для регистрации/редактирования/просмотра документа необходимо 
разместить следующий код:
</p>
<pre style="font-style: italic; font-family: monospace; font-size: 9pt">
    $url=$this->createUrl(
                    "/mff/formview/save", 
                    array(
                        "idregistry"=><ИД регистрации свободной формы>, - Обязательно только для операции добавления документа
                        "idstorage"=><ИД хранилища куда нужно сохранить свободную форму>, - Обязательно только для операции добавления документа
                        "idform"=><ИД зарегистрированного документа>, - Обязательно только для операций просмотра и редактирования документа
                        "scenario"=>"insert", - Обязательно только для операций просмотра ("view") и редактирования ("update") документа
                        "thisrender"=>base64_encode("mff.views.default.testff"), - Представление на котором расположен виджет
                        "addons"=>base64_encode("любые данные") -Прозвольные данные которые будут переданы в представление
                    )
            );
    echo CHtml::link("Зарегистрировать",$url);
</pre>
<p>
На странице где мы хотим разместить окно для регистрации/редактирования/просмотра документа необходимо 
разместить следующий код:</p>
<pre style="font-style: italic; font-family: monospace; font-size: 9pt">
        $ff=$this->widget('mff.components.FF.FFWidget',
                    array(
                        "idregistry"=><ИД регистрации свободной формы>, - Обязательно только для операции добавления документа
                        "idstorage"=><ИД хранилища куда нужно сохранить свободную форму>, - Обязательно только для операции добавления документа
                        "idform"=><ИД зарегистрированного документа>, - Обязательно только для операций просмотра и редактирования документа
                        "scenario"=>"insert", - Обязательно только для операций просмотра ("view") и редактирования ("update") документа
                        "name"=>null,  - Необязательный параметр. Формирует имина тэгов на основе "name". Если не указан создасться автоматически. "name" формы будет выглядить как name_form
                        "fieldcount"=>100, - Необязательный параметр. Кол-во полей на странице.                      
                        "backurl"=>$this->createUrl("/mff/formview/index",array("id"=>8)), - URL страницы куда передать управление после регистрации документа 
                )
            );
    echo CHtml::button("Сохранить",array("onclick"=>$ff->name."_form.submit()"));
</pre>
Исходный код страницы:
<pre style="font-style: italic; font-family: monospace; font-size: 9pt">
if ($this->action->id=="save") {
    $ff=$this->widget('mff.components.FF.FFWidget',
            array(
                "idregistry"=>14,
                "idstorage"=>8,      
                "backurl"=>$this->createUrl("/mff/formview/index",array("id"=>8)),
                )
            );
    echo CHtml::button("Сохранить",array("onclick"=>$ff->name."_form.submit()"));
} else {
    $url=$this->createUrl(
                    "/mff/formview/save", 
                    array(
                        "idregistry"=>14,
                        "idstorage"=>8,
                        "thisrender"=>base64_encode("mff.views.default.testff"),));
    echo "Для проверки регистрации документа нажмите ".CHtml::link("Зарегистрировать",$url);
}    
</pre>