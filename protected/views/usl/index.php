<?php


          echo '<div id="navigbg" class="container"><div id="navig">';
          echo CHtml::link('Головна', array('..'));
          echo '&nbsp;<img src='.Yii::app()->baseUrl.'/images/dot.png>&nbsp;Замовлення послуги on-line';
          echo	'</div></div>';
 


        $ff=$this->widget('mff.components.FF.FFWidget',
                    array(
                        "idregistry"=>38,
                        "idstorage"=>16,
                        "backurl"=>$this->createUrl("/mff/formview/index",array("id"=>8)), 
			   "profile"=>"usl",	
                )
            );
    echo CHtml::button("Сохранить",array("onclick"=>$ff->name."_form.submit()"));
?> 