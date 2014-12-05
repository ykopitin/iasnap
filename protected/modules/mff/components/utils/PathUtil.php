<?php

/*
 * для определения значения по пути
 */

/**
 * Description of PathUtil
 *
 * @author prk
 */
class PathUtil {
    private $document;
    private $action;
    private $node;
    private $folder;
    private $availableAction;
    private $availableNode;
    
    protected function getDocument() {
        return $this->document;
    }

    protected function setDocument($document) {
        $this->document = $document;       
    }

    function getAction() {
        return $this->action;
    }

    function getNode() {
        return $this->node;
    }

    function getFolder() {
        return $this->folder;
    }

    function getAvailableAction() {
        return $this->availableAction;
    }

    function getAvailableNode() {
        return $this->availableNode;
    }

    function setAction($action) {
        $this->action = $action;
    }

    function setNode($node) {
        $this->node = $node;
    }

    function setFolder($folder) {
        $this->folder = $folder;
    }

    function setAvailableAction($availableAction) {
        $this->availableAction = $availableAction;
    }

    function setAvailableNode($availableNode) {
        $this->availableNode = $availableNode;
    }

        public function __construct($document) {
        $this->setDocument($document);
    }
    
    public function getValue($path) {
        if (empty($path) || $path==NULL || $path=="") return NULL;
        $pathpart=explode(".", $path);
        if (empty($pathpart) || $pathpart==NULL || $pathpart=="") return NULL;
        $firstcheck=TRUE;
        switch ($pathpart[0]) {
            case "{currentuser}":
                $currentmodel= new fieldlist_FFModel();
                $currentmodel->registry=fieldlist_FFModel::user;
                $currentmodel->refreshMetaData();
                $currentmodel=$currentmodel->findByPk(Yii::app()->user->id);
                $currentmodel->registry=fieldlist_FFModel::user;
                $currentmodel->refresh();
                break;
            case "{currentrole}":
                $user= new fieldlist_FFModel();
                $user->registry=fieldlist_FFModel::role;
                $user->refreshMetaData();
                $user=$user->findByPk($user->id);
                $currentmodel= new fieldlist_FFModel();
                $currentmodel->registry=fieldlist_FFModel::role;
                $currentmodel->refreshMetaData();
                $currentmodel=$currentmodel->findByPk($user->user_roles_id);
                $currentmodel->registry=fieldlist_FFModel::role;
                $currentmodel->refresh();
                break;
            case "{this}":
            case "{document}":
                $currentmodel=$this->getDocument();
                break;
             case "{node}":
                $currentmodel=$this->getNode();
                break;
             case "{action}":
                $currentmodel=$this->getAction();
                break;
             case "{action}":
                $currentmodel=$this->getFolder();
                break;
             case "{availableaction}":
                $currentmodel=$this->getAvailableAction();
                break;
             case "{availablenode}":
                $currentmodel=$this->getAvailableNode();
                break;
            default :
                $currentmodel=$this->getDocument();
                $firstcheck=FALSE;
        }        
        if (count($pathpart)>1) {
            foreach ($pathpart as $index=>$part) {
                if ($index==0 && $firstcheck || $currentmodel->getAttaching()==1) continue;
                $type=$currentmodel->getType($part);
                if (strstr($part, "{")!==FALSE) continue;
                switch ($type->id) {
                    case '1':
                    case '2':
                    case '3':
                    case '4':
                    case '5':
                    case '6':
                    case '7':
                    case '11':
                    case '12':
                    case '15':
                    case '16':
                    case '17':
                    case '18':
                    case '19':
                        return $currentmodel->getAttribute($part);
                        break;
                    default :
                        switch ($type->getAttribute("view")){
                            case "combobox":
                            case "listbox":
                            case "innerguide":
                            case "radiobox":   
                                $guidemodel= new fieldlist_FFModel();
                                $guidemodel->registry=1;
                                $guidemodel->refreshMetaData();
                                $guidemodel=$guidemodel->findByPk($currentmodel->getAttribute($part));
                                $guidemodel->refresh();
                                $currentmodel=$guidemodel;
                                break;
                            case "listbox_multi":
                                return $currentmodel->getItems($part);
                                break;    
                        }
                }
            }
        }
        return $currentmodel->id;
    }
}
