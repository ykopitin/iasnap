<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of FFInitScan
 *
 * @author prk
 */
class FFInitScan extends CWidget {
    public $id;

    public function getId($autoGenerate = true) {
        if (empty($this->id)|| $this->id==NULL) {
            return parent::getId($autoGenerate);
        } else {
            return $this->id;
        }
    }
    
    public function setId($value) {
        if (empty($this->id)|| $this->id==NULL) {
            parent::setId($value);
        } else {
            $this->id=$value;
        }
    }


    public function init() {
        parent::init();
        Yii::app()->clientScript->registerScriptFile(
                Yii::app()->createUrl(
                        "mff/default/getscript",
                        array(
                            "script"=>base64_encode("mff.components.ffscan.jscan"), 
                            "fullAlias"=>true
                            )
                        )
                );
        
        ?>
        
        <applet 
            codebase="<?= Yii::app()->request->getHostInfo() ?>/auth"
            height="3" 
            width="3" 
            id='<?= $this->getId() ?>'
            code="com.prk.jscan.Main"           
            archive="JScan.jar"
            >
        </applet>
        <?php        
    }

}
