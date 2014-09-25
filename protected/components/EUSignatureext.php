<?php

class EUSignatureext
{
    public $Signature;

    public $sData="";	// Входящий. Данные для подписи
    public $sSign="";   // Входящий. Подпись
    public $sSignTime="";	// Вихідний. Час підпису в форматі 
			// MM.DD.YYYY HH:ii:ss. Передається за 
			// посиланням
    public $bUseTSP="";	// Вихідний. Чи використовувався TSP.
			// Передається за посиланням
    public $sIssuer="";	//* Вихідний. Видавник сертифікату.
			// Передається за посиланням
    public $sIssuerCN="";	//* Вихідний. Загальне ім’я видавника.
			// Передається за посиланням
    public $sSerial="";	//* Вихідний. Серійний номер сертифікату.
			// Передається за посиланням
    public $sSubject="";	//* Вихідний. Власник сертифікату.
			// Передається за посиланням
    public $sSubjCN="";	// Вихідний. Загальне ім’я власника.
			// Передається за посиланням
    public $sSubjOrg="";	//* Вихідний. Організація.
			// Передається за посиланням
    public $sSubjOrgUnit="";	//* Вихідний. Підрозділ.
				// Передається за посиланням
    public $sSubjTitle="";	//* Вихідний. Посада.
			// Передається за посиланням
    public $sSubjState="";	//* Вихідний. Область.
			// Передається за посиланням
    public $sSubjLocality="";	//* Вихідний. Місто.
				// Передається за посиланням
    public $sSubjFullName="";	//* Вихідний. Повне ім’я.
				// Передається за посиланням
    public $sSubjAddress="";	//* Вихідний. Адреса.
				// Передається за посиланням
    public $sSubjPhone="";	//* Вихідний. Телефон.
			// Передається за посиланням
    public $sSubjEMail="";	//* Вихідний. E-mail.
			// Передається за посиланням
    public $sSubjDNS="";	//* Вихідний. DNS.
			// Передається за посиланням
    public $sSubjEDRPOUCode="";	//* Вихідний. ЄДРПОУ код.
				// Передається за посиланням
    public $sSubjDRFOCode="";	//* Вихідний. ДРФО код.
				// Передається за посиланням
    public $iErrorCode="";		// Вихідний. Код помилки. Передається за 
				// посиланням


    public function __construct($sData, $Signature)
    {
// sData and Signature must be decoded if base64
//        $this->Signature=base64_decode($Signature);
//        $this->sData=base64_decode($sData);
        $this->Signature=$Signature;
        $this->sData=$sData;
    }

    public function check($need_for_utf8 = true)
    {
	$i1 = 0;
	euspe_init($i1);
	$s1 = "";
	euspe_geterrdescr($i1, $s1);
	if ($i1 != 0)
		error_log("EU lib error: ".$i1."; ".$s1);
// longest form
//$i = euspe_signverify($sData, $sSign, $sSignTime, $bUseTSP, $sIssuer, $sIssuerCN, $sSerial, $sSubject, $sSubjCN, $sSubjOrg, $sSubjOrgUnit, $sSubjTitle, $sSubjState, $sSubjLocality, $sSubjFullName, $sSubjAddress, $sSubjPhone, $sSubjEmail, $sSubjDNS, $sSubjEDRPOUCode, $sSubjDRFOCode, $iErrorCode);
	$i1 = euspe_signverifyext($this->sData, $this->Signature, $this->sSignTime, $this->bUseTSP, $this->sIssuer, $this->sIssuerCN, $this->sSerial, $this->sSubject, $this->sSubjCN, $this->sSubjOrg, $this->sSubjOrgUnit, $this->sSubjTitle, $this->sSubjState, $this->sSubjLocality, $this->sSubjFullName, $this->sSubjAddress, $this->sSubjPhone, $this->sSubjEmail, $this->sSubjDNS, $this->sSubjEDRPOUCode, $this->sSubjDRFOCode, $this->iErrorCode);
	$s1="";
	euspe_geterrdescr($this->iErrorCode, $s1);
	if($this->iErrorCode==0) {
//		if($need_convert_data_from_utf16)
//			$this->sResultData = iconv($in_charset = 'UTF-16LE' , $out_charset = 'UTF-8' , $this->sResultData);
		if($need_for_utf8) {
//			$this->sData = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sData);
			$this->sSignTime = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSignTime);
			$this->sIssuer = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sIssuer);
			$this->sIssuerCN = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sIssuerCN);
			$this->sSerial = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSerial);
			$this->sSubject = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubject);
			$this->sSubjCN = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjCN);
			$this->sSubjOrg = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjOrg);
			$this->sSubjOrgUnit = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjOrgUnit);
			$this->sSubjTitle = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjTitle);
			$this->sSubjState = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjState);
			$this->sSubjLocality = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjLocality);
			$this->sSubjFullName = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjFullName);
			$this->sSubjAddress = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjAddress);
			$this->sSubjPhone = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjPhone);
			$this->sSubjEMail = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjEMail);
			$this->sSubjDNS = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjDNS);
			$this->sSubjEDRPOUCode = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjEDRPOUCode);
			$this->sSubjDRFOCode = iconv($in_charset = 'windows-1251' , $out_charset = 'UTF-8' , $this->sSubjDRFOCode);
		}
	}
	return $this->iErrorCode;

    }

	public function getMysqlSignDate() {
		if ($this->sSignTime != "") {
			$temp_date = split(" ", $this->sSignTime);
			list($DateM, $DateD, $DateY) = explode('.', $temp_date[0]);
			if (is_numeric($DateY) && is_numeric($DateM) && is_numeric($DateD)) {
				if ((strlen($DateY) == 4) && (strlen($DateM) == 2) && (strlen($DateD) == 2))
					return $DateY."-".$DateM."-".$DateD;
			}
			
		}
	}

}

?>
