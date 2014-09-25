<?php
class AjaxController extends CController {
    // actionIndex вызывается всегда, когда action не указан явно.
    function actionIndex(){
        $input = Yii::app()->request->getPost('input');
        // для примера будем приводить строку к верхнему регистру
        $output = mb_strtoupper($input, 'utf-8');
 
        // если запрос асинхронный, то нам нужно отдать только данные
        if(Yii::app()->request->isAjaxRequest){
            echo CHtml::encode($output);
            // Завершаем приложение
            Yii::app()->end();
        }
        else {
            // если запрос не асинхронный, отдаём форму полностью
            $this->render('form', array(
                'input'=>$input,
                'output'=>$output,
            ));
        }
    }
}
?>