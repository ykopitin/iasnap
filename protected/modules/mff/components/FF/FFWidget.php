<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of FFWidget
 *
 * @author prk
 */
class FFWidget extends CWidget {
    public $backurl=null;
    public $idregistry=null;
    public $idstorage=null;
    public $idform=null;
    public $scenario="insert";
    public $name=null;
    public $fieldOptions=array();
    public $fieldcount=100;
    public $cssOptions=null;
    public $lsOptions=null;
    
    public function init() {    
        static $genid=0;       
        Yii::import("mff.models.*");
        if (isset($this->cssOptions) && $this->cssOptions!=null) Yii::app()->clientScript->registerCSSFile($this->cssOptions);
        if (isset($this->jsOptions) && $this->jsOptions!=null) Yii::app()->clientScript->registerScriptFile($this->jsOptions);
        $genid++;
        if (!isset($this->name) || $this->name==NULL || $this->name=="") $this->name="FFIND".$genid;
        if (!isset($this->backurl) || $this->backurl==NULL || $this->backurl=="") $this->backurl=Yii::app()->getRequest()->getUrl();
        
    }

    public function run() {      
        $this->render("ff",array("idregistry"=>$this->idregistry, "idstorage"=>$this->idstorage, "scenario"=>$this->scenario, "idform"=>$this->idform));
    }    
    
}
