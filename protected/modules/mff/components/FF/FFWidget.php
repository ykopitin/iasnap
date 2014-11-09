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
    public $fieldOptions=null;
    public $fieldcount=100;
    public $cssOptions=null;
    public $jsOptions=null;
    public $profile="default";


    public function init() {    
        static $genid=0;       
        Yii::import("mff.models.*");
        $genid++;
        if (!isset($this->name) || $this->name==NULL || $this->name=="") $this->name="FFIND".$genid;
        if (!isset($this->backurl) || $this->backurl==NULL || $this->backurl=="") $this->backurl=Yii::app()->getRequest()->getUrl();
        $this->applyHtmlOptions();
        $this->applyCSSOptions();
        $this->applyScriptOptions();
        if (isset($this->profile) && $this->profile!=NULL && $this->profile!="" && $this->profile!="default") {
            $this->applyHtmlOptions($this->profile);
            $this->applyCSSOptions($this->profile);
            $this->applyScriptOptions($this->profile);
        }
    }

    public function run() {      
        $this->render("ff",array("idregistry"=>$this->idregistry, "idstorage"=>$this->idstorage, "scenario"=>$this->scenario, "idform"=>$this->idform));
    }    
    
    protected function applyHtmlOptions($profile="default") {
       if (empty($this->fieldOptions) || $this->fieldOptions==NULL) {
            $this->fieldOptions=array();
            $path="mff.components.FF.style.htmloptions.".$profile;
            $file=Yii::getPathOfAlias($path).".php";
            if (file_exists($file)) {
                $_data=array();
                include $file;
                $this->fieldOptions=  array_merge($this->fieldOptions,$_data);
            }
            $path="mff.components.FF.style.htmloptions.".$this->idregistry.".".$profile;
            $file=Yii::getPathOfAlias($path).".php";
            if (file_exists($file)) {
                $_data=array();
                include $file;
                $this->fieldOptions=  array_merge($this->fieldOptions,$_data);
            }
            $path="mff.components.FF.style.htmloptions.".$this->idregistry.".".$this->scenario.".".$profile;
            $file=Yii::getPathOfAlias($path).".php";
            if (file_exists($file)) {
                $_data=array();
                include $file;
                $this->fieldOptions=  array_merge($this->fieldOptions,$_data);
            }
            // Добавить в зависимости от узла
        }           
    }
        
    protected function applyCSSOptions($profile="default") {
        if (empty($this->cssOptions) || $this->cssOptions==NULL) {
            $path="mff.components.FF.style.css.".$profile;
            $file=Yii::getPathOfAlias($path).".css";
            if (file_exists($file)) {
                 Yii::app()->clientScript->registerCSSFile(Yii::app()->createUrl("mff/default/getcss",array("css"=>  $path, "fullAlias"=>true)));
            }
            $path="mff.components.FF.style.css.".$this->idregistry.".".$profile;
            $file=Yii::getPathOfAlias($path).".css";
            if (file_exists($file)) {
                 Yii::app()->clientScript->registerCSSFile(Yii::app()->createUrl("mff/default/getcss",array("css"=>  $path, "fullAlias"=>true)));
            }
            $path="mff.components.FF.style.css.".$this->idregistry.".".$this->scenario.".".$profile;
            $file=Yii::getPathOfAlias($path).".css";          
            if (file_exists($file)) {
                Yii::app()->clientScript->registerCSSFile(Yii::app()->createUrl("mff/default/getcss",array("css"=>$path, "fullAlias"=>true)));
            }
            
       }        
    }
    
    protected function applyScriptOptions($profile="default") {
        if (empty($this->jsOptions) || $this->jsOptions==NULL) {
            $path="mff.components.FF.style.js.".$profile;
            $file=Yii::getPathOfAlias($path).".js";
            if (file_exists($file)) {
                 Yii::app()->clientScript->registerScriptFile(Yii::app()->createUrl("mff/default/getscript",array("script"=>$path, "fullAlias"=>true)));
            }
            $path="mff.components.FF.style.js.".$this->idregistry.".".$profile;
            $file=Yii::getPathOfAlias($path).".js";
            if (file_exists($file)) {
                 Yii::app()->clientScript->registerScriptFile(Yii::app()->createUrl("mff/default/getscript",array("script"=>$path, "fullAlias"=>true)));
            }
            $path="mff.components.FF.style.js.".$this->idregistry.".".$this->scenario.".".$profile;
            $file=Yii::getPathOfAlias($path).".js";
            if (file_exists($file)) {
                Yii::app()->clientScript->registerScriptFile(Yii::app()->createUrl("mff/default/getscript",array("script"=>$path, "fullAlias"=>true)));
            }
            // Добавить в зависимости от узла
       }                
    }
}
