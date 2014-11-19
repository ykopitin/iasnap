<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
Yii::import('zii.widgets.grid.CDataColumn');

/**
 * Description of mffDataColumn
 *
 * @author prk
 */
class mffDataColumn extends CDataColumn{
    
    protected function renderDataCellContent($row, $data) {
        
		if($this->value!==null)
			$value=$this->evaluateExpression($this->value,array('data'=>$data,'row'=>$row));
		elseif($this->name!==null)
//			$value=CHtml::value($data,$this->name);
			$value=$data->getFieldValue($this->name);
		echo $value===null ? $this->grid->nullDisplay : $this->grid->getFormatter()->format($value,$this->type);
    }


}
