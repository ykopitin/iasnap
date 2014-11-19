<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of gridfolder
 *
 * @author prk
 */
Yii::import("system.zii.widgets.grid.CGridView");
class mffGridView extends CGridView {
    
    public function renderTableRow($row) {
        $this->dataProvider->data[$row]->refresh();
        parent::renderTableRow($row);
    }

    
}
