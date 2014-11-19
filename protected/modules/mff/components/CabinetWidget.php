<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of CabinetWidget
 *
 * @author prk
 */

class CabinetWidget extends CWidget {
    
    public $cabinetId=null;
    public $folderId=null;
    public $userId=null;
    public $roleId=null;
    public $cabineturl=null;
    public $idregistry=null;
    public $idstorage=null;
    public $addons=null;
    public $thisrender=null;
    private $cabinets=null;
    
    public function init() {       
        Yii::import("mff.models.*");
        parent::init();
        if (empty($this->cabineturl) || $this->cabineturl==NULL) {
            $this->cabineturl=  base64_encode("mff.views.cabinet.cabinet");
        }
        if (empty($this->userId) || $this->userId==NULL) {
            $this->userId=  Yii::app()->user->id;
            if (empty($this->roleId) || $this->roleId==NULL) {
                $user= new FFModel();
                $user->registry = FFModel::user;
                $user->refreshMetaData();
                $user=$user->findByPk($this->userId);
                if (empty($user) || $user==NULL) {
                    $this->cabinets=array($this->cabinetId);
                    return;
                }
                $this->roleId=$user->user_roles_id;
            }
            if (empty($this->cabinetId) || $this->cabinetId==NULL) {
                $cabinets=new FFModel();
                $cabinets->registry=  FFModel::route_cabinet;
                $cabinets->refreshMetaData();
                $cabinets=$cabinets->findAll();
                $cabinetItems=array();
                foreach ($cabinets as $cabinet) {
                    switch ($cabinet->registry) {
                        case FFModel::route_cabinet:
                            $cabinetItems=  array_merge($cabinetItems, $cabinet->registry);
                            break;
                        case FFModel::route_cabinet_for_role:
                            $cabinet->refresh();
                            $roles=$cabinet->getItems("role");                       
                            foreach ($roles as $role) {
                                if ($this->roleId==$role->id){
                                    $cabinetItems=  array_merge($cabinetItems,array($cabinet->id));
                                    break;
                                }
                            }                       
                            break;
                        case FFModel::route_cabinet_for_users:
                            $cabinet->refresh();
                            $users=$cabinet->getItems("users"); 
                            foreach ($users as $user) {
                                if ($this->userId==$user->id){
                                    $cabinetItems=  array_merge($cabinetItems,array($cabinet->id));
                                    break;
                                }
                            }
                            break;
                    }
                }
                $this->cabinets=$cabinetItems;
            } else {
                $this->cabinets=array($this->cabinetId);
            }
        }
    }

    public function run() {
        foreach ($this->cabinets as $cabinetId) {
            $this->render(
                    "mff.views.cabinet.cabinet",
                    array(
                        "cabinetid"=>  $cabinetId, 
                        "folderid"=>  $this->folderId, 
                        "cabineturl"=>$this->cabineturl, 
                        "idregistry"=>$this->idregistry,
                        "idstorage"=>$this->idstorage,   
                        "thisrender"=>$this->thisrender,   
                        "addons"=>$this->addons,  
                        )
                    );
        }
    }

}
