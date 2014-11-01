<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Cabinet
 *
 * @author prk
 */
class Cabinet extends CWidget{
    private $user;
    
    public function __construct($owner = null) {
        parent::__construct($owner);
        $this->user=Yii::app()->user;
    }
    
    public function getFolders(){
        return array();
    }
    
    
}
