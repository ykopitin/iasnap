<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


/**
 * Description of print
 *
 * @author prk
 */
$doc=FFModel::model()->findByPk($idform);
$this->widget('mff.components.FF.FFWidget',
        array(
            "idform"=>$idform,
            "idstorage"=>$doc->storage,
            "idregistry"=>$doc->registry,
            "scenario"=>"view",	
            "profile"=>$profile,
            "name"=>"formff",
    )
);
   