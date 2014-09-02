<?php

/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

$this->beginWidget("zii.widgets.jui.CJuiDialog",
        array( 'options' => 
            array(
                'title' => 'Изменить '.$id,
                'modal' => true,
                'resizable'=> false,
            )
        )
);

$this->endWidget("zii.widgets.jui.CJuiDialog");
