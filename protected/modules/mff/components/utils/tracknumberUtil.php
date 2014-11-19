<?php

/*
 * Для работы с трэкномером
 */

/**
 * Description of tracknumberUtil
 *
 * @author prk
 */
class tracknumberUtil {
    /// Секретные коэфициенты
    private static $coefficient=array(3,5,9,2,3,4,7,1,6,7,1);

    /// Генерирует трекномер
    public static function getTracknumberFromId($id) {
        $text="48200000000";
        $text=str_pad($id, 11, $text, STR_PAD_LEFT);
        $control=0;
        $coefficient=self::$coefficient;
        for ($index=0;$index<11;$index++) {
            $control+=$text[$index]*$coefficient[$index];
        }
        $control_last = $control % 11;        
        if ($control_last==10) {
            $control=(string)$control;
            $control_last=$control[strlen($control)-1];
        }
        return $text.$control_last;
    }

    /// Проверяет правильность трэкномера
    public static function checkTracknumber($tracknumber) {
        if (strlen($tracknumber)!=12) return FALSE;
        $control=0;
        $coefficient=self::$coefficient;
        for ($index=0;$index<11;$index++) {
            $control+=$tracknumber[$index]*$coefficient[$index];
        }
        $control_last = $control % 11;        
        if ($control_last==10) {
            $control=(string)$control;
            $control_last=$control[strlen($control)-1];
        }
        return ($tracknumber[11]==$control_last);
    }
    
    /// Получает ID документа из трэкномера
    public static function getIdFromTracknumber($tracknumber) {
        if (!self::checkTracknumber($tracknumber)) return FALSE;
        $id=substr($tracknumber, 4,-1);
        $id=$id*1;
        return $id;
    }
    
}
