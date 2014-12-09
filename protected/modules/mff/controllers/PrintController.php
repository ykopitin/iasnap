<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of PrintController
 *
 * @author prk
 */

class PrintController extends Controller
{
    public $layout='//layouts/blank';    //put your code here
    
    public function actionPrint($id,$profile="default") {
        $this->render("print",array("idform"=>$id,"profile"=>$profile));
    }
    
    public function actionReport() {
        if (isset($_POST) && isset($_POST["btnFilter"])) {
            $model=new FFModel();
            $model->registry=FFModel::document_cnap;
            $model->refreshMetaData();   
            $criteria=new CDbCriteria();
            $criteria->alias="doc";
            if (isset($_POST["cmbService"]) && $_POST["cmbService"]!="") {
                $criteria->addColumnCondition(array("service"=> $_POST["cmbService"]));
            }
            if (isset($_POST["cmbSubject"]) && $_POST["cmbSubject"]!="") {
                $criteria->addColumnCondition(array("authorities"=> $_POST["cmbSubject"]));
            }
            /// Многострочник?
            if (isset($_POST["cmbAdministrator"]) && $_POST["cmbAdministrator"]!="") {                
                $criteria->join .= " INNER JOIN ff_ref_multiguide refadm on ((doc.id = refadm.`owner`) and (refadm.owner_field='administrator')) ";
                $criteria->addColumnCondition(array("refadm.reference"=> $_POST["cmbAdministrator"]));
            }
            if (isset($_POST["cmbExecutor"]) && $_POST["cmbExecutor"]!="") {
                $criteria->join .= " INNER JOIN ff_ref_multiguide refexec on ((doc.id = refexec.`owner`) and (refexec.owner_field='executor')) ";
                $criteria->addColumnCondition(array("refexec.reference"=> $_POST["cmbExecutor"]));
            }
            if (isset($_POST["dateCreateFrom"]) && $_POST["dateCreateFrom"]!="") {
                $criteria->addCondition("createdate>=".$_POST["dateCreateFrom"]);
            }
            if (isset($_POST["dateCreateTo"]) && $_POST["dateCreateTo"]!="") {
                $criteria->addCondition("(createdate-1)<=".$_POST["dateCreateTo"]);
            }
            if (isset($_POST["dateRegdateFrom"]) && $_POST["dateRegdateFrom"]!="") {
                $criteria->addCondition("regdate>=".$_POST["dateRegdateFrom"]);
            }
            if (isset($_POST["dateRegdateTo"]) && $_POST["dateRegdateTo"]!="") {
                $criteria->addCondition("regdate<=".$_POST["dateRegdateTo"]);
            }
            if (isset($_POST["txtRegnum"]) && $_POST["txtRegnum"]!="") {
                $criteria->addSearchCondition("regnum", $_POST["txtRegnum"]);
            }
            if (isset($_POST["dateOutdateFrom"]) && $_POST["dateOutdateFrom"]!="") {
                $criteria->addCondition("outdate>=".$_POST["dateOutdateFrom"]);
            }
            if (isset($_POST["dateOutdateTo"]) && $_POST["dateOutdateTo"]!="") {
                $criteria->addCondition("outdate<=".$_POST["dateOutdateTo"]);
            }
            if (isset($_POST["txtOutnum"]) && $_POST["txtOutnum"]!="") {
                $criteria->addSearchCondition("outnum", $_POST["txtOutnum"]);
            }
            if (isset($_POST["txtSubject"]) && $_POST["txtSubject"]!="") {
                $criteria->addSearchCondition("organization_name", $_POST["txtSubject"]);
            }
            if (isset($_POST["txtEDRPOU"]) && $_POST["txtEDRPOU"]!="") {
                $criteria->addSearchCondition("organization_edrpou", $_POST["txtEDRPOU"]);
            }
            if (isset($_POST["txtFIO"]) && $_POST["txtFIO"]!="") {
                $criteria->addSearchCondition("person_name", $_POST["txtFIO"]);
            }
            if (isset($_POST["txtDRFO"]) && $_POST["txtDRFO"]!="") {
                $criteria->addSearchCondition("person_drfo", $_POST["txtDRFO"]);
            }
            if (isset($_POST["txtFIOAccept"]) && $_POST["txtFIOAccept"]!="") {
                $criteria->addSearchCondition("autority_person_name", $_POST["txtFIOAccept"]);
            }
            if (isset($_POST["txtNumberAccept"]) && $_POST["txtNumberAccept"]!="") {
                $criteria->addSearchCondition("autority_person_number", $_POST["txtNumberAccept"]);
            }
            if (isset($_POST["txtAddress"]) && $_POST["txtAddress"]!="") {
                $criteria->addSearchCondition("address", $_POST["txtAddress"]);
            }
            /// Многострочник?
            if (isset($_POST["cmbResult"]) && $_POST["cmbResult"]!="") {
                $criteria->addColumnCondition(array("reply"=> $_POST["cmbResult"]));
            }
            if (isset($_POST["datePlandateFrom"]) && $_POST["datePlandateFrom"]!="") {
                $criteria->addCondition("plandate>=".$_POST["datePlandateFrom"]);
            }
            if (isset($_POST["datePlandateTo"]) && $_POST["datePlandateTo"]!="") {
                $criteria->addCondition("plandate<=".$_POST["datePlandateTo"]);
            }
            if (isset($_POST["dateMiddledateFrom"]) && $_POST["dateMiddledateFrom"]!="") {
                $criteria->addCondition("renewal_date>=".$_POST["datePlandateFrom"]);
            }
            if (isset($_POST["dateMiddledateTo"]) && $_POST["dateMiddledateTo"]!="") {
                $criteria->addCondition("renewal_date<=".$_POST["dateMiddledateTo"]);
            }
            if (isset($_POST["dateFactdateFrom"]) && $_POST["dateFactdateFrom"]!="") {
                $criteria->addCondition("factdate=>".$_POST["dateFactdateFrom"]);
            }
            if (isset($_POST["dateFactdateTo"]) && $_POST["dateFactdateTo"]!="") {
                $criteria->addCondition("factdate<=".$_POST["dateFactdateTo"]);
            }
            if (isset($_POST["dateDeliverydateFrom"]) && $_POST["dateDeliverydateFrom"]!="") {
                $criteria->addCondition("result_date_delivery>=".$_POST["dateDeliverydateFrom"]);
            }
            if (isset($_POST["dateDeliverydateTo"]) && $_POST["dateDeliverydateTo"]!="") {
                $criteria->addCondition("result_date_delivery<=".$_POST["dateDeliverydateTo"]);
            }
            if ($criteria->condition != "") {
                $model=$model->findAll($criteria);
                $this->render("list",  array("model"=>$model));
            } else {
                $this->render("filter");
            }
        } else
        $this->render("filter");
    }
    
    public function actionStatistic() {
        $this->render("statistic");
    }
}
