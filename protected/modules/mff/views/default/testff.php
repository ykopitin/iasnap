<p>Тестирование СФ</p>
<?php
$ff=$this->widget('mff.components.FF.FFWidget',
        array(
            "idregistry"=>14,
            "idstorage"=>8,           
            )
        );
echo CHtml::button("Сохранить",array("onclick"=>$ff->name."_form.submit()"));