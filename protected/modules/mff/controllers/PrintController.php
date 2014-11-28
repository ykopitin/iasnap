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
    
}
