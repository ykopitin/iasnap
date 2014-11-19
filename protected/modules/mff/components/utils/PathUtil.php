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

    protected function getDocument() {
        return $this->document;
    }

    protected function setDocument($document) {
        $this->document = $document;       
    }

    public function __construct($document) {
        $this->setDocument($document);
    }
    
    public function getValue($path) {
        if (empty($path) || $path==NULL || $path="") return NULL;
        $pathpart=explode(".", $path);
        if (empty($pathpart) || $pathpart==NULL || $pathpart="") return NULL;
        switch ($pathpart[0]) {
            case "{currentuser}":
                $currentmodel=Yii::app()->user;
                unset($pathpart[0]);
                break;
            case "{currentrole}":
                $user=Yii::app()->user;
                $currentmodel= new FFModel();
                $currentmodel->registry=FFModel::role;
                $currentmodel->refreshMetaData();
                $currentmodel=$currentmodel->findByPk($user->user_roles_id);
                unset($pathpart[0]);
                break;
            case "{this}":
                unset($pathpart[0]);
            default :
                $currentmodel=$this->getDocument();
        }
        $result=$currentmodel->id;
        if (isset($pathpart) && $pathpart!=NULL && count($pathpart)>0) {
            foreach ($pathpart as $part) {
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
                                $guidemodel= new FFModel();
                                
                                $currentmodel->getAttribute($part);
                                break;
                        }
                }
            }
        }
    }
}
