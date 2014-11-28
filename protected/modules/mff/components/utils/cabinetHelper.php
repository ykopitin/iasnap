<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of cabinetHelper
 *
 * @author prk
 */

class cabinetHelper {
    
    private $userId;
    private $roleId;
    private $authoritiesId;

    private $tableNameNode;
    private $tableNameAvailableNode;
    private $tableNameRefMultiguide;

    
    /**
     * 
     * @param type $userId
     */
    public function __construct($userId) {
        $this->userId=$userId;
        if ($userId!=null) {
            $user=new FFModel();
            $user->registry=FFModel::user;
            $user->refreshMetaData();
            $user=$user->findByPk($userId);
            $this->roleId=$user->user_roles_id;
            $this->authoritiesId=$user->authorities_id;   
        }
        
        $this->tableNameNode=  "ff_".FFRegistry::model()->findByPk(FFModel::route_node)->tablename;
        $this->tableNameAvailableNode=  "ff_".FFRegistry::model()->findByPk(FFModel::available_nodes)->tablename;
        $this->tableNameRefMultiguide=  "ff_".FFRegistry::model()->findByPk(FFModel::ref_multiguide)->tablename;
     }
    
    /**
     * Показывает документы в кабинетах. с прямым доступом к базе
     * @param type $cabinetid
     * @param type $folderId
     * @param type $userId
     */
    public function getDocumensFromFolder($folderId) {          
        $criteria= new CDbCriteria();
        $criteria->distinct=true;
        $criteria->select="doc.id id, ref_avn.`owner_field` owner_field, ref_avn.`reference` reference";
        $criteria->alias="doc";
        $criteria->join="INNER JOIN ".$this->tableNameRefMultiguide." ref1 on ".
                "((ref1.`owner`=doc.id) and (ref1.`owner_field`='available_nodes')) ".
		"INNER JOIN ".$this->tableNameAvailableNode." avn on (ref1.`reference`=avn.id) ".
		"INNER JOIN ".$this->tableNameRefMultiguide." ref2 on ((ref2.`reference`=avn.`node`) and (ref2.`owner_field`='nodes')) ".
                "LEFT OUTER JOIN ".$this->tableNameRefMultiguide." ref_avn on (ref_avn.`owner`=avn.id) ";
        $criteria->addCondition("ref2.`owner`=:folderid");
        $criteria->params[":folderid"]=$folderId;
        
        $documents=new FFModel();
        $documents->registry=FFModel::document_base;
        $documents->refreshMetaData();
        $documents=$documents->findAll($criteria);
        
        $documentIds=array();
        foreach ($documents as $document) {
            if (($document->getAttribute("owner_field")=="users" && $document->getAttribute("reference")==$this->userId) || 
                ($document->getAttribute("owner_field")=="roles" && $document->getAttribute("reference")==$this->roleId) || 
                ($document->getAttribute("owner_field")=="authorities" && $document->getAttribute("reference")==$this->authoritiesId) || 
                ($document->getAttribute("owner_field")==null)  
               ) 
                {
                    $documentIds=  array_merge ($documentIds, array($document->getAttribute("id")));
                }
        }
        
        for ($i1=0;$i1<count($documentIds);$i1++) {
            for ($i2=$i1+1;$i2<count($documentIds);$i2++) {
                if ($i1==$i2) continue;
                if (($documentIds[$i1]==$documentIds[$i2])) {
                    $documentIds[$i2]=NULL;
                }
            }                    
        }
               
        $documentIds2=array();
        foreach ($documentIds as $value) {
            if ($value!=null) $documentIds2=  array_merge($documentIds2,array($value));
        }
        return $documentIds2;
    }
}
