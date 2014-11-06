<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of CabinetWidget
 *
 * @author prk
 */

class CabinetWidget extends CWidget {
    
    public $cabinetId;
    public $folderId=null;
    
    public function init() {       
        Yii::import("mff.models.*");
        parent::init();
    }

    public function run() {
        $this->render("mff.views.cabinet.cabinet",array("cabinetid"=>  $this->cabinetId, "folderid"=>  $this->folderId));
    }

}
