<?php
    
    echo CHtml::form($this->createUrl("/mff/print/report"));
?>
<div class="filter">
    <span style="text-transform: uppercase;">ПОШУК</span>
    <fieldset style="border: 1px solid; padding-left: 20pt;">
        <legend>Базові ревізити</legend>
        <ul>
            <li>
                <span class="label first">Послуга:</span>
                <?php               
                $modelService=new FFModel();
                $modelService->registry=FFModel::gen_services;
                $modelService->refreshMetaData();
                $modelService=$modelService->findAll();
                $dataServices=CHtml::listData($modelService, "id", "name");
                $dataServices=array_merge(array(""=>""),$dataServices);    
                echo CHtml::dropDownList("cmbService", array(), $dataServices, array('style'=>'width:500px'));
                ?>
            </li>
            <li>
                <span class="label first">Сб'єкт надання послуг:</span>
                <?php               
                $modelService=new FFModel();
                $modelService->registry=FFModel::gen_authorities;
                $modelService->refreshMetaData();
                $modelService=$modelService->findAll();
                $dataServices=CHtml::listData($modelService, "id", "name");
                $dataServices=array_merge(array(""=>""),$dataServices);    
                echo CHtml::dropDownList("cmbSubject", array(), $dataServices, array('style'=>'width:500px'));
                ?>
            </li>
            <li>
                <span class="label first">Адміністратор:</span>
                <?php               
                $modelService=new FFModel();
                $modelService->registry=FFModel::user;
                $modelService->refreshMetaData();
                $modelService=$modelService->findAll("user_roles_id=2");
                $dataServices=CHtml::listData($modelService, "id", "fio");
                $dataServices=array_merge(array(""=>""),$dataServices);    
                echo CHtml::dropDownList("cmbAdministrator", array(), $dataServices, array('style'=>'width:500px'));
                ?>
            </li>
            <li>
                <span class="label first">Виконавець:</span>
                <?php               
                $modelService=new FFModel();
                $modelService->registry=FFModel::user;
                $modelService->refreshMetaData();
                $modelService=$modelService->findAll("user_roles_id=3");
                $dataServices=CHtml::listData($modelService, "id", "fio");
                $dataServices=array_merge(array(""=>""),$dataServices);    
                echo CHtml::dropDownList("cmbExecutor", array(), $dataServices, array('style'=>'width:500px'));
                ?>
            </li>
            <li>
                <span class="label first">Дата створення з:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateCreateFrom",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
                <span class="label">по:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateCreateTo",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
            </li>
            <li>
                <span class="label first">Дата реєстрації з:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateRegdateFrom",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
                <span class="label">по:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateRegdateTo",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
            </li>
            <li>
                <span class="label first">Реєстраційний номер:</span>
                <?php               
                    echo CHtml::textField("txtRegnum");
                ?>
            </li>
            <li>
                <span class="label first">Вихідна дата з:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateOutdateFrom",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
                <span class="label">по:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateOutdateTo",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
            </li>
            <li>
                <span class="label first">Вихідний номер:</span>
                <?php               
                    echo CHtml::textField("txtOutnum");
                ?>
            </li>
            <li>
                <span class="label first">Назва установи:</span>
                <?php               
                    echo CHtml::textField("txtSubject");
                ?>
            </li>
            <li>
                <span class="label first">Код ЄДРПОУ:</span>
                <?php               
                    echo CHtml::textField("txtEDRPOU");
                ?>
            </li>
            <li>
                <span class="label first">ПІБ фізичної особи:</span>
                <?php               
                    echo CHtml::textField("txtFIO");
                ?>
            </li>
            <li>
                <span class="label first">Код ДРФО:</span>
                <?php               
                    echo CHtml::textField("txtDRFO");
                ?>
            </li>
            <li>
                <span class="label first">ПІБ довіреної особи:</span>
                <?php               
                    echo CHtml::textField("txtFIOAccept");
                ?>
            </li>
            <li>
                <span class="label first">№ довіреності:</span>
                <?php               
                    echo CHtml::textField("txtNumberAccept");
                ?>
            </li>        
            <li>
                <span class="label first">Адреса:</span>
                <?php               
                    echo CHtml::textField("txtAddress");
                ?>
            </li>        
        </ul>
    </fieldset>
    <fieldset style="border: 1px solid; padding-left: 20pt;">
        <legend>Виконання</legend>
        <ul>
            <li>
                <span class="label first">Результат розгляду:</span>
                <?php               
                    $storageResult=FFStorage::model()->findByPk(FFModel::reply_storage);
                    $dataResults=new FFModel();
                    $dataResults->registry= FFModel::oneline;
                    $dataResults->refreshMetaData();
                    $dataResults=$storageResult->records;                    
                    $dataResults=CHtml::listData($dataResults, "id", "name");
                    $dataResults=  array_merge(array(""=>""),$dataResults);
                    echo CHtml::dropDownList("cmbResult", array(), $dataResults);
                ?>
            </li>
            <li>
                <span class="label first">Контрольна дата з:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"datePlandateFrom",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
                <span class="label">по:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"datePlandateTo",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
            </li>
            <li>
                <span class="label first">Продовжено з:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateMiddledateFrom",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
                <span class="label">по:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateMiddledateTo",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
            </li>
            <li>
                <span class="label first">Знято з контролю з:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateFactdateFrom",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
                <span class="label">по:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateFactdateTo",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
            </li>
            <li>
                <span class="label first">Дата вручення з:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateDeliverydateFrom",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
                <span class="label">по:</span>
                <?php               
                    $this->widget('zii.widgets.jui.CJuiDatePicker',array(
                        'name'=>"dateDeliverydateTo",
                        'language'=>Yii::app()->getLanguage(),
                        'options'=>array(
                            'showAnim'=>'fold',
                            'dateFormat'=>'yy-mm-dd',
                        ),
                    ));
                ?>
            </li>
        </ul>
    </fieldset>
    <?php

    ?>
</div>
<?php
    $this->widget(
            "zii.widgets.jui.CJuiButton",
            array(
                "name"=>"btnFilter",
                'buttonType'=>'submit',
                'caption'=>'Шукати'));
    echo CHtml::endForm();
?>