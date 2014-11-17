<?php

/*
 * Базовый класс для применения действий на узлах маршрута
 */

/**
 * Description of Action
 *
 * @author prk
 */


class Action {
    public $registryAction=FFModel::route_action;
    public $registryAvailableAction=FFModel::available_actions;
    public $registryAvailableNode=FFModel::available_nodes;

    private $document;
    private $_availableActions=null;
    private $_availableNodes=null;
    
    protected function setDocument($document) {
        $this->document=$document;
        $this->document->refresh();
    }
    
    protected function getDocument() {
        return $this->document;
    }
    
    public function __construct($document) {
        Yii::import("mff.models.FFModel");
        $this->setDocument($document);
    }
    
    public function doAction($idAction, $idNode) {
        
    }
    
    protected function enableNode($idNode) {
        
    }

    protected function enableAction($idAction) {
        
    }

    /// Сброс
    public function refresh() {
        $this->_availableNodes=NULL;
        $this->_availableActions=NULL;
        $this->document->refresh();
    }
        
    /// Разрешеные узлы
    protected function availableNodes() {
        if (empty($this->_availableNodes) || $this->_availableNodes==NULL) {
            $this->_availableNodes=$this->document->getItems("available_nodes");
        }
        return $this->_availableNodes;        
    }
    
    /// Разрешенные действия
    protected function availableActions() {
        if (empty($this->_availableActions) || $this->_availableActions==NULL) {
            $this->_availableActions=$this->document->getItems("available_actions");
        }
        return $this->_availableActions;        
    }
    
    protected function getAction($idAction) {
        $result=new FFModel;
        $result->registry=$this->registryAction;
        $result->refreshMetaData();
        $result=$result->findByPk($idAction);
        $result->refresh();
        return $result;
    }
}
