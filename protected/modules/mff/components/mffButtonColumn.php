<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of ButtonColumn_folder
 *
 * @author prk
 */
Yii::import("system.zii.widgets.grid.CButtonColumn");
class mffButtonColumn extends CButtonColumn  {
    public $htmlImageOptions = "";
    
    protected function renderButton($id, $button, $row, $data) {
       	if (isset($button['visible']) && !$this->evaluateExpression($button['visible'],array('row'=>$row,'data'=>$data)))
        return;
        $label=isset($button['label']) ? $button['label'] : $id;
        $url=isset($button['url']) ? $this->evaluateExpression($button['url'],array('data'=>$data,'row'=>$row)) : '#';
        $options=isset($button['options']) ? $button['options'] : array();
        if(!isset($options['title']))
            $options['title']=$label;
        if(isset($button['imageUrl']) && is_string($button['imageUrl']))
            echo CHtml::link(CHtml::image($button['imageUrl'],$label,$this->htmlImageOptions),$url,$options);
        else
            echo CHtml::link($label,$url,$options);
    }

}
