<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of Action
 *
 * @author prk
 */
class Action {
    private $document;
    
    protected function setDocument($document) {
        $this->document=$document;
    }
    
    protected function getDocument() {
        return $this->document;
    }
    
    public function __construct($document) {
        $this->setDocument($document);
    }
    
    public function doAction($idAction, $idNode) {
        
    }
    
    protected function getNodes() {
        
    }
}
