<?php

class EUUserIdentity extends CUserIdentity
{
    private $_id;
    public $Signature;
    public $type_of_user = "user";

    /**
     * Constructor.
     * @param string $username username
     * @param string $password password
     */
    public function __construct($Signature, $type_of_user = "user")
    {
        $this->Signature=base64_decode($Signature);
	$this->type_of_user = $type_of_user;
    }

    public function authenticate()
    {
	$i1 = 0;
	euspe_init($i1);
	$s1 = "";
	euspe_geterrdescr($i1, $s1);
	$sData="";	// Входящий. Данные для подписи
	$sSignTime="";	// Вихідний. Час підпису в форматі 
			// MM.DD.YYYY HH:ii:ss. Передається за 
			// посиланням
	$bUseTSP="";	// Вихідний. Чи використовувався TSP.
			// Передається за посиланням
	$sIssuer="";	//* Вихідний. Видавник сертифікату.
			// Передається за посиланням
	$sIssuerCN="";	//* Вихідний. Загальне ім’я видавника.
			// Передається за посиланням
	$sSerial="";	//* Вихідний. Серійний номер сертифікату.
			// Передається за посиланням
	$sSubject="";	//* Вихідний. Власник сертифікату.
			// Передається за посиланням
	$sSubjCN="";	// Вихідний. Загальне ім’я власника.
			// Передається за посиланням
	$sSubjOrg="";	//* Вихідний. Організація.
			// Передається за посиланням
	$sSubjOrgUnit="";	//* Вихідний. Підрозділ.
				// Передається за посиланням
	$sSubjTitle="";	//* Вихідний. Посада.
			// Передається за посиланням
	$sSubjState="";	//* Вихідний. Область.
			// Передається за посиланням
	$sSubjLocality="";	//* Вихідний. Місто.
				// Передається за посиланням
	$sSubjFullName="";	//* Вихідний. Повне ім’я.
				// Передається за посиланням
	$sSubjAddress="";	//* Вихідний. Адреса.
				// Передається за посиланням
	$sSubjPhone="";	//* Вихідний. Телефон.
			// Передається за посиланням
	$sSubjEMail="";	//* Вихідний. E-mail.
			// Передається за посиланням
	$sSubjDNS="";	//* Вихідний. DNS.
			// Передається за посиланням
	$sSubjEDRPOUCode="";	//* Вихідний. ЄДРПОУ код.
				// Передається за посиланням
	$sSubjDRFOCode="";	//* Вихідний. ДРФО код.
				// Передається за посиланням
	$sResultData="";	//* Вихідний. Перевірені дані.
				// Передається за посиланням
	$iErrorCode="";		// Вихідний. Код помилки. Передається за 
				// посиланням
// longest form
//$i = euspe_signverify($sData, $sSignTime, $bUseTSP, $sIssuer, $sIssuerCN, $sSerial, $sSubject, $sSubjCN, $sSubjOrg, $sSubjOrgUnit, $sSubjTitle, $sSubjState, $sSubjLocality, $sSubjFullName, $sSubjAddress, $sSubjPhone, $sSubjEmail, $sSubjDNS, $sSubjEDRPOUCode, $sSubjDRFOCode, $sResultData, $iErrorCode);
	$i1 = euspe_signverify($this->Signature, $sSignTime, $bUseTSP, $sIssuer, $sIssuerCN, $sSerial, $sSubject, $sSubjCN, $sSubjOrg, $sSubjOrgUnit, $sSubjTitle, $sSubjState, $sSubjLocality, $sSubjFullName, $sSubjAddress, $sSubjPhone, $sSubjEmail, $sSubjDNS, $sSubjEDRPOUCode, $sSubjDRFOCode, $sResultData, $iErrorCode);
	$s1="";
	euspe_geterrdescr($iErrorCode, $s1);
error_log("step01");
	if($iErrorCode!=0)
	{
error_log("step01a,err:".$iErrorCode);
	    $this->errorCode=self::ERROR_USERNAME_INVALID;
            return !$this->errorCode;
	}
error_log("step02");
$sResultData = iconv($in_charset = 'UTF-16LE' , $out_charset = 'UTF-8' , $sResultData);
$sIssuer = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $sIssuer);

// Якщо довжина даних, які підписав користувач (рядок автентифікації), не дорівнює 40 символів,
// то зупинити процедуру автентифікації користувача. Довжина даних, які підписує користувач,
// задається у файлі auth/genstr.php (псевдовипадковий рядок)
	$sResultData = ltrim($sResultData, ';');
error_log("sResultData at login:".$sResultData);
	if (strlen($sResultData) != 40) {
		error_log("Auth: Error: Signed data has no valid auth string length");
		$this->errorCode=self::ERROR_USERNAME_INVALID;
		return !$this->errorCode; }
// Якщо рядок автентифікації містить недопустимі символи, то зупинити процедуру автентифікації користувача,
// допустимі символи задаються у файлі auth/genstr.php
//// Todo: Необхідно дослідити
	if (preg_match('/[^a-zA-Z0-9\.\$\[\]\!@\*\+\-\{\}]/s', $sResultData) > 0) {
		error_log("Auth: Error: Auth string has incorrect symbols");
		$this->errorCode=self::ERROR_USERNAME_INVALID;
		return !$this->errorCode; }
	GenStr::model()->deleteAll("itime < :itime", array(':itime' => time()-120));
	if (GenStr::model()->count('sauth=:sauth', array(':sauth'=>$sResultData)) <= 0) {
		error_log("Auth: Error: Auth string has expired 120s");
		$this->errorCode=self::ERROR_USERNAME_INVALID;
		return !$this->errorCode; }
//	Перевірка часу підпису
error_log("sSignTime:".$sSignTime);
	$date1 = DateTime::createFromFormat('m.d.Y H:i:s', $sSignTime);
//	$this->CertExpireEndTime = $date1->getTimestamp();
error_log("date1:".$date1->getTimestamp());
error_log("time:".time());
//	if (abs(time() - $date1->getTimestamp()) > 600)	// час підпису користувача відріняється від систеного часу сервера на 10 та більше хвилин
//	{
//error_log("time error");
//        $this->errorCode=self::ERROR_USERNAME_INVALID;
//        return !$this->errorCode;		
//	}
	GenStr::model()->find('sauth=:sauth', array(':sauth'=>$sResultData))->delete();

error_log("step2b,certiss:".$sIssuer);

        $record=CabUserExternCerts::model()->findByAttributes(array('certType'=>"0", 'certissuer'=>$sIssuer, 'certserial'=>$sSerial));
//error_log("step2d,certser:".$sSerial);

        if($record===null) {
error_log("step03 error empty certs external");
            $this->errorCode=self::ERROR_USERNAME_INVALID;
            return !$this->errorCode;
		}
//var_dump($record);
error_log("step04");
//	$record2=$record->CabUserExternal;
	$record2=$record->extUser;
error_log("cab_state:".$record2->cab_state);
//error_log("teststrin:"."не активований");
error_log("errors:".$this->errorCode);
        if($record2->cab_state != "активований")
            $this->errorCode=self::ERROR_PASSWORD_INVALID;
        else
        {
error_log("step06, user_roles_id:".$record2->user_roles_id."; type_of_user:".$this->type_of_user);
// Disable (comment) restriction on admin logon with main login page
//	    if (($record2->user_roles_id < 4) && ($this->type_of_user != "admin")) 	// Адміністративний користувач
//	    	{
//error_log("step06a, error - user is admin");
//			$this->errorCode=self::ERROR_USERNAME_INVALID;
//			return !$this->errorCode;
//	    }

            $this->_id=$record2->id;
            $this->setState('title', $record2->email);
            $this->errorCode=self::ERROR_NONE;
        }
error_log("step07");
        return !$this->errorCode;
    }
 
    public function getId()
    {
        return $this->_id;
    }
}

?>
