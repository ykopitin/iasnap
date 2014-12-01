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
        $type="text";
        if($this->value!==null)
            $value=$this->evaluateExpression($this->value,array('data'=>$data,'row'=>$row));
        elseif($this->name!==null) {
//			$value=CHtml::value($data,$this->name);
            $value=$data->getFieldValue($this->name);
            switch($data->getType($this->name)->id) {
                case '3':
                    $type="date"; 
                    break;
                case '7':
                case '17': 
                    $type="datetime"; 
                    break;
                case '10':
                case '14':  
                    $type="raw";
                    break;
            }
        }
        if ($value===null) {
            echo $this->grid->nullDisplay;
        } else {
            $formatter=$this->grid->getFormatter();
            $formatter->datetimeFormat='d/m/Y H:i:s';
            $formatter->dateFormat='d/m/Y';
            echo $formatter->format($value,$type);
        }
    }


}
