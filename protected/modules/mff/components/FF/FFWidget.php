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
    public $CSSOptions=null;
    public $JSOptions=null;
    
    public function init() {    
        static $genid=0;       
        Yii::import("mff.models.*");
        if ($this->CSSOptions!=null) Yii::app()->clientScript->registerCSSFile($this->CSSOptions);
        if ($this->JSOptions!=null) Yii::app()->clientScript->registerScriptFile($this->JSOptions);
        $genid++;
        if (!isset($this->name) || $this->name==NULL || $this->name=="") $this->name="FFIND".$genid;
        if (!isset($this->backurl) || $this->backurl==NULL || $this->backurl=="") $this->backurl=Yii::app()->getRequest()->getUrl();
        
    }

    public function run() {      
        $this->render("ff",array("idregistry"=>$this->idregistry, "idstorage"=>$this->idstorage, "scenario"=>$this->scenario, "idform"=>$this->idform));
    }    
    
}
