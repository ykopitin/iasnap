<?php

class base58 {

    public static function encode($str) {
        $result="";
        for ($index = 0; $index < strlen($str); $index++) {
            $result.="+".self::_encode(ord($str[$index]));
        }
        return $result;
    }
    
    public static function decode($str) {
        $result="";
        $part=  explode("+", $str);
        for ($index = 0; $index < count($part); $index++) {
            if ($part[$index]=="") continue;
            $result.=chr(self::_decode($part[$index]));
        }     
        return $result;
    }
    
    protected static function _encode($num) {
        $alphabet = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
        $base_count = strlen($alphabet);
        $encoded = '';
        while ($num >= $base_count) {
            $div = $num / $base_count;
            $mod = ($num - ($base_count * intval($div)));
            $encoded = $alphabet[$mod] . $encoded;
            $num = intval($div);
        }
        if ($num) {
            $encoded = $alphabet[$num] . $encoded;
        }
        return $encoded;
    }

    protected static function _decode($num) {
        $alphabet = '123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ';
        $len = strlen($num);
        $decoded = 0;
        $multi = 1;
        for ($i = $len - 1; $i >= 0; $i--) {
            $decoded += $multi * strpos($alphabet, $num[$i]);
            $multi = $multi * strlen($alphabet);
        }
        return $decoded;
    }

}

