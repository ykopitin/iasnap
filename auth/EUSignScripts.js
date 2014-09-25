///////////////////////////////////////////////////////////////////
//from Certificates.js


//=============================================================================

var CertTableID = "certTable";
var SelectUserSelectID = "SelectUserSelect";
var CloseCertFormButtonID = "CloseCertFormButton";
var SelectCertFormButtonID = "SelectCertFormButtonID";

//=============================================================================

var CertificatesType = {
	CertTypeAll:     {"type": 0, "subtype": 0},
	CertTypeCA:      {"type": 1, "subtype": 0},
	CertTypeCAAll:   {"type": 2, "subtype": 0},
	CertTypeCACMP:   {"type": 2, "subtype": 1},
	CertTypeCATSP:   {"type": 2, "subtype": 2},
	CertTypeCAOCSP:  {"type": 2, "subtype": 3},
	CertTypeAdmin:   {"type": 3, "subtype": 0},
	CertTypeEndUser: {"type": 4, "subtype": 0}
}

//=============================================================================

var MakeClass = function() {
	return function( args ) {
	    if( this instanceof arguments.callee ) {
	        if( typeof this.__construct == "function" ) 
				this.__construct.apply( this, args );
	    }
		else return new arguments.callee( arguments );
	};
}

var NewClass = function( variables, constructor, functions ) {
	var retn = MakeClass();
	for( var key in variables ) {
		retn.prototype[key] = variables[key];
	}
	for( var key in functions ) {
		retn.prototype[key] = functions[key];
	}
	retn.prototype.__construct = constructor;
	return retn;
}	  

//=============================================================================

var EUCertificatesForm = NewClass({
	"frameHeight": "0",
	"frameWidth": "0",
	"formHeight": "0",
	"formWidth": "0",
	
	"header": "Сертифікати",
	"addSelect": true,
	"addSearch": false,
	"selectMultiple":false,
	"onSelectOK": "null",
	"onSelectCancel": "null",
	"CertificatesType": "CertificatesType.CertTypeAll",
	
	"CertTable": "null",
	
	"DOMElement": "",
	"dimmerShowed": false,
	"dimmer": "null"
}, 
function(frameHeight, frameWidth, formHeight, formWidth, selectMultiple) {
	this.frameHeight = frameHeight;
	this.frameWidth  = frameWidth;
	this.formHeight  = formHeight;
	this.formWidth 	 = formWidth;
	this.selectMultiple = typeof selectMultiple !== 'undefined' ? 
		selectMultiple : false;
	this.CertTable	 = CertTableForm(this, CertTableID, this.selectMultiple);
},
{
"SelectCertificate": function (formName, CertType, onSelectOK, onSelectCancell) {
	this.addSelect = false;
	this.addSearch = false;
	this.onSelectOK = onSelectOK;
	this.onSelectCancell = onSelectCancell;
	this.ShowForm(formName, CertType);
},
"ShowForm": function(formName, CertType) {
	if(euSign.DoesNeedSetSettings()) {
		alert("Не встановлені параметри файлового сховища сертифікатів та СВС");
		return;
	}

	this.header = formName;
	this.dimmer = document.getElementById('opaco');
	if(this.dimmer.style.display == "none" || this.dimmer.style.display == "") {
		this.dimmer.style.display = "block"; 
		this.dimmer.style.height = document.body.clientHeight + 'px';
	}
	else {
		this.dimmerShowed = true;
	}
	
	this.DOMElement = this._constructForm();
	this.DOMElement.style.width = this.formWidth + 'px';
	this.DOMElement.style.left = Math.floor(document.body.clientWidth/2) - this.formWidth / 2 + 'px';
	this.DOMElement.style.zIndex = 12;
	document.body.appendChild(this.DOMElement);
	
	this.CertTable.CreateHeader('Власник','ЦСК','Серійний номер',
		'Реквізити власника', 'Реквізити ЦСК');
	
	this._attachEvents();
	this._userSelected(CertType);
	
	return false;
},
"CloseForm": function() {
	this.DOMElement.innerHTML = "";
	this.DOMElement.style.display = "none"; 
	if(!this.dimmerShowed)
		this.dimmer.style.display = "none";
	if(this.onSelectCancel != "null") {
		this.onSelectCancel();
	}
	return false;
},
"OnRowClick": function(row) {
	var cells = row.getElementsByTagName('td');
	var Issuer = cells[4].getAttribute("val");
	var Serial = cells[2].getAttribute("val");
	try {
		var certInfo = euSign.GetCertificateInfoEx(Issuer, Serial);
		if(this.onSelectOK != "null") {
			this.onSelectCancell = "null";
			this.CloseForm();
			this.onSelectOK(certInfo);
		} 
		else {
			showCertInfo(certInfo, false);
		}
	} catch(e){
		showException(e);
	}
},
"OnSelectCertificates": function() {
	var certsInfo = [];
	var rows = this.CertTable.GetSelectedRows();
	for (var i = 0; i < rows.length; i++) {
		row = rows[i];
		var cells = row.getElementsByTagName('td');
		var Issuer = cells[4].getAttribute("val");
		var Serial = cells[2].getAttribute("val");
		try {
			certsInfo[i] = euSign.GetCertificateInfoEx(Issuer, Serial);
		} catch(e){
			showException(e);
			this.onSelectCancell = "null";
			this.CloseForm();
		}
	}
	if (certsInfo.length == 0) {
		alert("Не обрано жодного сертифікату");
		return;
	}
	this.onSelectCancell = "null";
	this.CloseForm();
	this.onSelectOK(certsInfo);
},
"_attachEvents": function() {
	var thisForm = this;
	
	if(this.addSelect) {
		var SelectUserSelect = document.getElementById(SelectUserSelectID);
		SelectUserSelect.onchange = function(){thisForm._userSelected(SelectUserSelect.value); return false};
	}
	
	var CloseCertFormButton = document.getElementById(CloseCertFormButtonID);
	CloseCertFormButton.onclick = function(){thisForm.CloseForm(); return false};
	
	if (this.selectMultiple) {
		var SelectCertFormButton = document.getElementById(SelectCertFormButtonID);
		SelectCertFormButton.onclick = function(){thisForm.OnSelectCertificates(); return false};
	}
},
"_constructForm": function() {
	var  container = document.createElement('div')
	var formContent = '<div class="Form" id="CertificatesForm">'; 
	formContent += "<form name=\"Certificates\" action=\"#\" class=\"FormCertificates\">"; 
	formContent += '<div align="center"><h2 class="FormHeader">' + this.header + '</h2></div>'; 
		
	formContent += '<table height=90% width=100% border="1" class="border" bordercolor="#C0C0C0">';
	
	formContent += '<tr>';
	formContent += '<th scope="col" align="left" style="padding: 4px 0px 10px 10px"><div id=NumberLabel></div></th>';

	if(this.addSelect) {
		formContent += '<th align="left" style="padding: 4px 0px 10px 10px">Тип власників: ';
		formContent += '<select name="SelectUser" id=\"' + SelectUserSelectID + '\" style="padding: 0px 0px 0px 0px">';
		formContent += '<option value="CertificatesType.CertTypeAll">Всі сертифікати</option>';
		formContent += '<option value="CertificatesType.CertTypeCA">Центри сертифікації ключів</option>';
		formContent += '<option value="CertificatesType.CertTypeCAAll">Сервери ЦСК</option>';
		formContent += '<option value="CertificatesType.CertTypeCACMP">CMP-сервери</option>';
		formContent += '<option value="CertificatesType.CertTypeCAOCSP">OCSP-сервери</option>';
		formContent += '<option value="CertificatesType.CertTypeCATSP">TSP-сервери</option>';
		formContent += '<option value="CertificatesType.CertTypeEndUser">Користувачі ЦСК</option>';
		formContent += '<option value="CertificatesType.CertTypeAdmin">Адміністратори реєстрації</option>';
		formContent += '</select>';
		formContent += '</th>';
	}
	
	if(this.addSearch) {
		formContent += '<th>Пошук за власником:';
		formContent += '<label for="SearchField"></label>';
		formContent += '<input type="text" name="SearchField" id="SearchField" />';
		formContent += '</th>';
	}
	
	formContent += '</tr>';
	
	formContent += '<tr>';
	formContent += '<td colspan="3" scope="col">';
	formContent += this.CertTable.CreateBody();
	formContent += '</td>';
	formContent += '</tr>';
	
	formContent += '</table></br>';

	formContent += '<div align="right" style="padding: 0px 10px 0px 0px">';
	
	if (this.selectMultiple) {
		formContent += '<input type="button" value="Обрати",\
			id=\"' + SelectCertFormButtonID + '\" style="width:185px;" class="button" />';
	}
	formContent += '<input type="button" value="Закрити",\
						id=\"' + CloseCertFormButtonID + '\" style="width:185px;" class="button" />'
	formContent += '</div>';
	
	formContent += "</form>"; 
	formContent += "</div>"; 
	
	container.innerHTML = formContent;
	
	return container.firstChild;
},
"_userSelected": function(certTypeStr) {
	this.CertTable.ClearRows();
	var certType = eval(certTypeStr);
	try {
		var certCount = euSign.GetCertificatesCount(certType.type, certType.subtype);
			
		for(var i = 0; i < certCount; i++) {
			var certOwnerInfo = euSign.EnumCertificates(certType.type, certType.subtype, i);
			if(certOwnerInfo == null)
				break;
				
			this.CertTable.AddRow(certOwnerInfo.GetSubjCN(), certOwnerInfo.GetIssuerCN(), 
				certOwnerInfo.GetSerial(), certOwnerInfo.GetSubject(), certOwnerInfo.GetIssuer());
		}
				
		document.getElementById("NumberLabel").innerHTML = "Кількість: " + certCount;
		this.CertTable.Initialized();
	} catch(e) {
		showException(e);
		this.CloseForm();
	}
}
}

);



///////////////////////////////////////////////////////////////////
//from CRLs.js

//=============================================================================

var CRLsTableID = "crlTable";
var CloseCRLsFormButtonID = "CloseCRLsFormButton";

//=============================================================================

var MakeClass = function() {
	return function( args ) {
	    if( this instanceof arguments.callee ) {
	        if( typeof this.__construct == "function" ) 
				this.__construct.apply( this, args );
	    }
		else return new arguments.callee( arguments );
	};
}

var NewClass = function( variables, constructor, functions ) {
	var retn = MakeClass();
	for( var key in variables ) {
		retn.prototype[key] = variables[key];
	}
	for( var key in functions ) {
		retn.prototype[key] = functions[key];
	}
	retn.prototype.__construct = constructor;
	return retn;
}	  

//=============================================================================

var EUCRLsForm = NewClass({
	"frameHeight": "0",
	"frameWidth": "0",
	"formHeight": "0",
	"formWidth": "0",
	
	"header": "Списки відкликаних сертифікатів",
	
	"CRLsTable": "null"	,
	
	"DOMElement": "",
	"dimmer": "null"
}, 
function(frameHeight, frameWidth, formHeight, formWidth) {
	this.frameHeight = frameHeight;
	this.frameWidth  = frameWidth;
	this.formHeight  = formHeight;
	this.formWidth 	 = formWidth;
	this.CRLsTable	 = CertTableForm(this, CRLsTableID);
},
{
"ShowForm": function(formName) {
	if(euSign.DoesNeedSetSettings()) {
		alert("Не встановлені параметри файлового сховища сертифікатів та СВС");
		return;
	}
	
	if(typeof formName != "undefined" && formName != '')
		this.header = formName;
	
	this.dimmer = document.getElementById('opaco');
	this.dimmer .style.display = "block"; 
	this.dimmer .style.height = document.body.clientHeight + 'px'; 
	
	this.DOMElement = this._constructForm();
	this.DOMElement.style.width = this.formWidth + 'px';
	this.DOMElement.style.left = Math.floor(document.body.clientWidth/2) - this.formWidth / 2 + 'px';
	this.DOMElement.style.zIndex = 12;
	document.body.appendChild(this.DOMElement);
	
	this.CRLsTable.CreateHeader('ЦСК','Серійний номер',
		'Час формування', 'Наступний', 'Реквізити ЦСК');
	
	this._attachEvents();
	this._update();
	
	return false;
},
"CloseForm": function() {
	this.DOMElement.innerHTML = "";
	this.DOMElement.style.display = "none"; 
	this.dimmer.style.display = "none";
	
	return false;
},
"OnRowClick": function(row) {
	var cells = row.getElementsByTagName('td');
	var Issuer = cells[4].getAttribute("val");
	var Serial = cells[1].getAttribute("val");
	var crlInfo = euSign.GetCRLDetailedInfo(Issuer, Serial);

	showCRLInfo(crlInfo, true);
},
"_attachEvents": function() {
	var thisForm = this;
	
	var CloseCRLsFormButton = document.getElementById(CloseCRLsFormButtonID);
	CloseCRLsFormButton.onclick = function(){thisForm.CloseForm(); return false};
},
"_constructForm": function() {
	var  container = document.createElement('div')
	var formContent = "<div class=\"Form\">"; 
	formContent += "<form name=\"CRLs\" action=\"#\" class=\"formCRLs\">"; 
	formContent += '<div align="center"><h2 class="FormHeader">' + this.header + '</h2></div>'; 
		
	formContent += '<table height=90% width=100% border="1" class="border" bordercolor="#C0C0C0">';
	
	formContent += '<tr>';
	formContent += '<th id="NumberLabel" scope="col" align="left" style="padding: 4px 0px 10px 10px"><pre><div id=NumberLabel></div></pre></th>';
	
	formContent += '</tr>';
	
	formContent += '<tr>';
	formContent += '<td colspan="3" scope="col">';
	formContent += this.CRLsTable.CreateBody();
	formContent += '</td>';
	formContent += '</tr>';
	
	formContent += '</table></br>';

	formContent += '<div align="right" style="padding: 0px 10px 0px 0px"><input type="button" value="Закрити",\
								id=\"' + CloseCRLsFormButtonID + '\" style="width:185px;" class="button" /></div>';
	
	formContent += "</form>"; 
	formContent += "</div>"; 
	
	container.innerHTML = formContent;
	
	return container.firstChild;
},
"_update": function() {
	this.CRLsTable.ClearRows();
	try {
		var crlCount = euSign.GetCRLsCount();
			
		for(var i = 0; i < crlCount; i++) {
			var crlInfo = euSign.EnumCRLs(i);
			if(crlInfo == null)
				break;
				
			this.CRLsTable.AddRow(crlInfo.GetIssuerCN(), 
				crlInfo.GetCRLNumber(), crlInfo.GetThisUpdate().toString(), crlInfo.GetNextUpdate().toString(), crlInfo.GetIssuer());
		}
				
		document.getElementById("NumberLabel").innerHTML = "Кількість: " + crlCount;
		this.CRLsTable.Initialized();
	} catch(e) {
		this.CloseForm();
		showException(e);
	}
}
}

);



/////////////////////////////////////////////////////////////////////
//from ReadPrivateKey.js


//=============================================================================

var DeviceTypeSelectID = "DeviceTypeSelect";
var DeviceNameSelectID = "DeviceNameSelect";
var DivDeviceNamesID = "DivDeviceNames";

var PasswordEditID = "PasswordEdit";
var NewPasswordEditID = "NewPasswordEdit";
var FormatDeviceCheckBoxID = "FormatDeviceCheckBox";
var SaveKMPasswordCheckBoxID = "SaveKMPasswordCheckBox";

var GetKeyMediaButtonID = "GetKeyMediaButton";
var CloseKeyMediaButtonID = "CloseKeyMediaButton";

//=============================================================================

var GetPrivateKeyFormType = {
	ReadPrivateKey: 0,
	ChangePassword: 1,
	GenPrivateKey: 	2
}

//=============================================================================

var MakeClass = function() {
	return function( args ) {
	    if( this instanceof arguments.callee ) {
	        if( typeof this.__construct == "function" ) 
				this.__construct.apply( this, args );
	    }
		else return new arguments.callee( arguments );
	};
}

var NewClass = function( variables, constructor, functions ) {
	var retn = MakeClass();
	for( var key in variables ) {
		retn.prototype[key] = variables[key];
	}
	for( var key in functions ) {
		retn.prototype[key] = functions[key];
	}
	retn.prototype.__construct = constructor;
	return retn;
}	  

//=============================================================================

var EUReadPKForm = NewClass({
	"frameHeight": "0",
	"frameWidth": "0",
	"formHeight": "0",
	"formWidth": "0",
	
	"title": null,
	"subTitle": null,
	
	"onSelectOK": null,
	"onSelectFail": null,
	"onSelectCancel": null,
	
	"formType": GetPrivateKeyFormType.ReadPrivateKey,
	
	"DOMElement": "",
	"dimmer": "",
	"dimmerShowed": false
}, 
function(frameHeight, frameWidth, formHeight, formWidth) {
	this.frameHeight = frameHeight;
	this.frameWidth  = frameWidth;
	this.formHeight  = formHeight;
	this.formWidth 	 = formWidth;
},
{

"ChangePasswordForm": function(onSelectOK, onSelectFail, onSelectCancel) {
	this.formType = GetPrivateKeyFormType.ChangePassword;
	this.ShowForm(onSelectOK, onSelectFail, onSelectCancel, "Зміна пароля захисту <br> особистого ключа");
},
"GenerateKeyForm": function(onSelectOK, onSelectFail, onSelectCancel) {
	this.formType = GetPrivateKeyFormType.GenPrivateKey;
	this.ShowForm(onSelectOK, onSelectFail, onSelectCancel, "Генерація особистого <br> ключа");
},
"ShowForm": function(onSelectOK, onSelectFail, onSelectCancel, title, subTitle) {

	this.onSelectOK = onSelectOK;
	this.onSelectFail = onSelectFail;
	this.onSelectCancel = onSelectCancel;
	
	this.title = title;
	this.subTitle = subTitle;
	
	this.dimmer = document.getElementById('opaco');
	if(this.dimmer.style.display == "none" || this.dimmer.style.display == "") {
		this.dimmer.style.display = "block"; 
		this.dimmer.style.height = document.body.clientHeight + 'px';
	}
	else {
		this.dimmerShowed = true;
	}
	
	this.DOMElement = this._constructForm();
	this.DOMElement.style.width = this.formWidth + 'px';
	this.DOMElement.style.minHeight = this.formHeight + 'px';
	this.DOMElement.style.left = Math.floor(document.body.clientWidth/2) - this.formWidth / 2 + 'px';
	this.DOMElement.style.zIndex = 13;
	document.body.appendChild(this.DOMElement);

	this._getDeviceNames();
	this._selectDefaultKeyMediaFromSettings();
	this._attachEvents();
	
	return false;
},
"CloseForm": function() {
	
	this.DOMElement.parentNode.removeChild(this.DOMElement);
	if(!this.dimmerShowed)
		this.dimmer.style.display = "none";
	
	return false;
},
"_attachEvents": function() {
	var thisForm = this;

	var DeviceTypeSelect = document.getElementById(DeviceTypeSelectID);
	DeviceTypeSelect.onchange = function(){
		thisForm._getDeviceNames(); 
		document.getElementById(PasswordEditID).value = "";
		return false
		};
	
	var DeviceNameSelect = document.getElementById(DeviceNameSelectID);
	DeviceNameSelect.onchange = function(){
		document.getElementById(PasswordEditID).value = "";
		return false
		};
	
	var GetKeyMediaButton = document.getElementById(GetKeyMediaButtonID);
	GetKeyMediaButton.onclick = function(){
		var deviceType = document.getElementById(DeviceTypeSelectID).value;
		var deviceName = document.getElementById(DeviceNameSelectID).value;
		var password = document.getElementById(PasswordEditID).value;
		
		switch(thisForm.formType) {
			case GetPrivateKeyFormType.ReadPrivateKey: {
				var saveKMPassword = document.getElementById(SaveKMPasswordCheckBoxID).checked;
				thisForm.CloseForm(); 
				thisForm.onSelectOK(deviceType, deviceName, password);
				if (saveKMPassword)
					thisForm._setKeyMediaSettings(deviceType, deviceName, password);
				break;
			}
			case GetPrivateKeyFormType.ChangePassword: {
				var newPassword = document.getElementById(NewPasswordEditID).value;
				thisForm.CloseForm(); 
				thisForm.onSelectOK(deviceType, deviceName, password, newPassword);
				break;
			}
			case GetPrivateKeyFormType.GenPrivateKey: {
				var formatDevice = document.getElementById(FormatDeviceCheckBoxID).checked;
				thisForm.CloseForm(); 
				thisForm.onSelectOK(deviceType, deviceName, password, formatDevice);
				break;
			}
		}
		return false;
	}

	var CloseButton = document.getElementById(CloseKeyMediaButtonID);
	CloseButton.onclick = function(){
		thisForm.CloseForm(); 
		if(thisForm.onSelectCancel != null)
			thisForm.onSelectCancel();
		return false};
},
"_constructForm": function () {
	
	var okButtonTitle = "Обрати";
	
	var  container = document.createElement('div')
	
	var formContent = ""; 
	formContent+= "<div class=\"Form\">"; 
	formContent+= "<form name=\"keyMedia\" action=\"#\" class=\"formKeyMedia\">"; 
	formContent+= '<div align="center"><h3 class="FormHeader">' + this.title + '</h3></div>'
	formContent+= '<table height=90% width=100% border="1" class="border" bordercolor="#C0C0C0">'; 
	if(this.subTitle != null && this.subTitle != "") {
		formContent+= '<tr><td align="center"><i>'+ this.subTitle + '</i></tr></td>';
	}
	formContent+= "<tr><td valign=\"top\" align=\"center\" class=\"form\">"; 
	formContent+= "   <table border=\"0\" cellspacing=\"0\" cellpadding=\"0\" width=\"100%\">"; 
	formContent+= "   <tr><td valign=\"top\" align=\"left\" style=\"padding: 10px 30px\">Тип носія:</td></tr>"; 
	formContent+= "   <tr><td valign=\"top\" align=\"center\" >"; 
	formContent+= "   <select id = " + DeviceTypeSelectID + " class=\"select\">"; 
	var result = "";
	var typeIndex = 0; 
	while(true) {
		result = euSign.EnumKeyMediaTypes(parseInt(typeIndex, 10)); 
		if (result == "") 
			break;
		formContent += "<option value=\""+typeIndex+"\">"+result+"</option>"; 
		typeIndex++; 
	}
	formContent+= "   </select>"; 
	formContent+= "   </td></tr>"; 
	formContent+= "   <tr><td valign=\"top\" align=\"left\" style=\"padding: 10px 30px\">Назва носія:</td></tr>"; 
	formContent+= "   <tr><td valign=\"top\" align=\"center\"><div id=" + DivDeviceNamesID + " ></div></td></tr>"; 
	formContent+= "   <tr><td valign=\"top\" align=\"left\" style=\"padding: 10px 30px\">Пароль:</td></tr>"; 
	formContent+= "   <tr><td valign=\"top\" align=\"center\"><input type=\"Password\" id = " + PasswordEditID + " class=\"edit\" maxlength=\"20\"></td></tr>"; 

	switch(this.formType) {
		case GetPrivateKeyFormType.ReadPrivateKey: {
			formContent += '<tr><td valign=\"top\" align=\"left\" style=\"padding-top: 10px; padding-left: 30px;\"><input type="checkbox" id=' + SaveKMPasswordCheckBoxID + ' />Запам`ятати пароль<br></td></tr>';
			break;
		}
		case GetPrivateKeyFormType.ChangePassword: {
			formContent+= "   <tr><td valign=\"top\" align=\"left\" style=\"padding: 10px 30px\">Новий пароль:</td></tr>"; 
			formContent+= "   <tr><td valign=\"top\" align=\"center\"><input type=\"Password\" id = " + NewPasswordEditID + " class=\"edit\" maxlength=\"20\"></td></tr>"; 
			break;
		}
		case GetPrivateKeyFormType.GenPrivateKey: {
			formContent += '<tr><td valign=\"top\" align=\"left\" style=\"padding-top: 10px; padding-left: 30px;\"><input type="checkbox" id=' + FormatDeviceCheckBoxID + ' />Форматувати пристрій<br></td></tr>';
			break;
		}
	}	
	
	formContent+= "   <tr><td valign=\"top\" align=\"right\" nowrap style=\"padding-top:20px\"></td></tr>"; 
	formContent+= "   </table>"; 
	formContent+= "</td></tr>"; 
	formContent+= "</table>"; 
	formContent+= '<div align="right" style="padding: 0px 10px 10px 0px"><input type="button" id = ' + GetKeyMediaButtonID + ' value="' + okButtonTitle + '" class="button" />';
	formContent+= '<input type="button" id = ' + CloseKeyMediaButtonID + ' value=\"Відміна\" class="button" /></div>';
	formContent+= "</form>"; 
	formContent+= "</div>"; 
	
	container.innerHTML = formContent;
	return container.firstChild;
}, 
"_getDeviceNames": function() {
	var formContent = "";
	var typeIndex = 0; 
	var deviceIndex = 0; 

	typeIndex = document.getElementById(DeviceTypeSelectID).value;
	
	formContent += "   <select id=" + DeviceNameSelectID + " class=\"select\">"; 
	while(true) {
	
		var result = euSign.EnumKeyMediaDevices(parseInt(typeIndex, 10), parseInt(deviceIndex, 10)); 
		if (result == "") 
			break; 
		formContent += "<option value=\"" + deviceIndex+"\">" + result + "</option>"; 
		deviceIndex++; 
	}

	formContent += "   </select>"; 

	document.getElementById(DivDeviceNamesID).innerHTML= formContent;

	var disabled = "";
	if (deviceIndex < 1) {
		disabled = "disabled";
	}
	
	document.getElementById(DeviceNameSelectID).disabled = disabled;
	document.getElementById(PasswordEditID).disabled = disabled;
	document.getElementById(GetKeyMediaButtonID).disabled = disabled;
},
"_selectDefaultKeyMediaFromSettings": function() {
	var typeIndex;
	var deviceIndex;
	var password;
	
	var keyMediaSettings; 
	try {

		keyMediaSettings = euSign.GetKeyMediaSettings();
		var keyMedia = keyMediaSettings.GetKeyMedia();
		
		typeIndex = keyMedia.GetTypeIndex();
		deviceIndex = keyMedia.GetDevIndex();
		password = keyMedia.GetPassword();
	
	} catch (e) {
		typeIndex = 1;
		deviceIndex = 0;
		password = "";
	}

	document.getElementById(DeviceTypeSelectID).selectedIndex = typeIndex;
	this._getDeviceNames();
	document.getElementById(DeviceNameSelectID).selectedIndex = deviceIndex;
	document.getElementById(PasswordEditID).value = password;
},
"_setKeyMediaSettings": function(typeIndex, deviceIndex, password) {
	var keyMediaSettings; 
	try {
		keyMediaSettings = euSign.GetKeyMediaSettings();
	} catch (e) {
		keyMediaSettings = euSign.CreateKeyMediaSettings();
	}
	
	var keyMedia = keyMediaSettings.GetKeyMedia();
	keyMedia.SetTypeIndex(parseInt(typeIndex, 10));
	keyMedia.SetDevIndex(parseInt(deviceIndex, 10));
	keyMedia.SetPassword(password);
	keyMediaSettings.SetKeyMedia(keyMedia);
	
	euSign.SetKeyMediaSettings(keyMediaSettings);
}
}

);



/////////////////////////////////////////////////////////////////////
//from ServerSettingsTab.js

//=============================================================================
	
var ServerType = {
	ServerTypeProxy: 	{"name": "Proxy-сервер", "port": 80, "useTitle": "Підключатися через proxy-сервер"},
	ServerTypeTSP: 		{"name": "TSP-сервер ЦСК", "port": 80, "useTitle": "Отримувати позначки часу", "certType":"CertificatesType.CertTypeCATSP"},
	ServerTypeOCSP: 	{"name": "OCSP-сервер ЦСК", "port": 80, "useTitle": "Використовувати OCSP-сервер", "certType":"CertificatesType.CertTypeCAOCSP"},
	ServerTypeLDAP: 	{"name": "LDAP-сервер ЦСК", "port": 389, "useTitle": "Використовувати LDAP-сервер", "certType":"CertificatesType.CertTypeCA"},
	ServerTypeCMP: 		{"name": "CMP-сервер ЦСК", "port": 80, "useTitle": "Використовувати CMP-сервер", "certType":"CertificatesType.CertTypeCACMP"}
}

//=============================================================================

var UseCheckBoxID = "_UseCheckBox";
var AddressTextEditID = "_AddressTextEdit";
var PortTextEditID = "_PortTextEdit";
var AuthCheckBoxID = "_AuthCheckBox";
var AnonymousCheckBoxID = "_AnonymousCheckBox";
var UserTextEditID = "_UserTextEdit";
var PasswordCheckBoxID = "_PasswordCheckBox";
var PasswordTextEditID = "_PasswordTextEdit";
var FromCertButtonID = "_FromCertButton";
var BeforeStoreCheckBoxID = "BeforeStoreCheckBox";

var AuthElementID = "_AuthElement";
var HiddenFormElementsID = "_FormElements";

//=============================================================================

function CheckServerData(ServerName, Address, Port) {
	if(Address == "") {
		alert('Не вказане ім\'я або ІР-адреса ' + ServerName);
		return false;
	}
	
	if(Port == "") {
		alert('Не вказаний номер TCP-порта ' + ServerName );
		return false;
	}

	if (parseInt(Port, 10) < 1 || parseInt(Port, 10) > 65535) {
		alert('Номер TCP-порта ' + ServerName +
			' має невірний формат(повинен бути в діапазоні від 1 до 65 535)');
		return false;
	}
	
	return true;
}

//-----------------------------------------------------------------------------

function IsServerNameExist(serverName, names) {

	if (names == '' || names.length == 0)
		return false;
		
	var namesArray = names.split(";");
	for(var i = 0; i < namesArray.length; i++) {
		if(namesArray[i].replace(/[ ]/g,'') == serverName)
			return true;
	}
	
	return false;
}

//=============================================================================

var MakeClass = function() {
	return function( args ) {
	    if( this instanceof arguments.callee ) {
	        if( typeof this.__construct == "function" ) 
				this.__construct.apply( this, args );
	    }
		else return new arguments.callee( arguments );
	};
}

var NewClass = function( variables, constructor, functions ) {
	var retn = MakeClass();
	for( var key in variables ) {
		retn.prototype[key] = variables[key];
	}
	for( var key in functions ) {
		retn.prototype[key] = functions[key];
	}
	retn.prototype.__construct = constructor;
	return retn;
}	  

//=============================================================================

var EUServerSettingsTab = NewClass({
	"TabID": "null",
	"ServerType": "",
	"onChange": null
}, 

function(TabID, ServerType, onChange) {
	this.TabID = TabID;
	this.ServerType = ServerType;
	this.onChange = onChange;
},

{
"GetContent": function() {
	var content = "";
	content = '<div id=' + this.TabID + ' style="display: none;" class="SettingsTab">\
			<h3 class="SettingsTabHeader">' + this.ServerType.name + '</h3>';
		
	//Add use checkbox
	content += '<p class="SettingsParameter"><input type="checkbox" id=' + 
		this.TabID + UseCheckBoxID + ' />' + this.ServerType.useTitle + '</p>';
	
	//Add server content
	content += '<div id=' + this.TabID + HiddenFormElementsID + '>';
	
	//Add IP/DNS + port fields
	content += '<div>DNS ім`я чи ip-адреса сервера:  <input type="text" id=' + this.TabID + AddressTextEditID + ' class="edit" style="width:45%;"/></div>\
				<div>TSP порт: <input type="text" id=' + this.TabID + PortTextEditID + ' class="edit" style="width: 10%; margin-left: 141px;" /></div>';
	if(this.ServerType == ServerType.ServerTypeTSP ||
		this.ServerType == ServerType.ServerTypeOCSP ||
		this.ServerType == ServerType.ServerTypeLDAP ||
		this.ServerType == ServerType.ServerTypeCMP) {
		content += '<div align="right" style="padding: 0px 10px 0px 0px"><input type="button" value="Змінити",\
								id=' + this.TabID + FromCertButtonID + ' style="width:185px;" class="button" disabled="disabled"/></div>';
	}
		
	//Add auth/Anonymous fields
	if(this.ServerType == ServerType.ServerTypeProxy) {
		content += '<p class="SettingsParameter"><input type="checkbox" id=' + this.TabID + 
					AuthCheckBoxID + ' /> Автентифікуватися на ' + this.ServerType.name + '</p>';
	}
	if(this.ServerType == ServerType.ServerTypeLDAP) {
		content += '<p class="SettingsParameter"><input type="checkbox" id=' +
			this.TabID + AnonymousCheckBoxID + ' /> Анонімний доступ</p>';
	}
	
	if(this.ServerType == ServerType.ServerTypeProxy || 
		this.ServerType == ServerType.ServerTypeLDAP) {
		content += '<div id=' + this.TabID + AuthElementID + '>' +
					'<div>Ім\'я користувача:  <input type="text" id=' + this.TabID + UserTextEditID + ' class="edit" style="width:45%;"/></div>\
					<div>Пароль:  <input type="password" id=' + this.TabID + PasswordTextEditID + ' class="edit" style="width:45%; margin-left: 62px;"/></div>';
	}
	
	if(this.ServerType == ServerType.ServerTypeProxy) {
		content += '<div><input type="checkbox" id=' + this.TabID + PasswordCheckBoxID + ' />Зберегти пароль</div>';
	}
	if(this.ServerType == ServerType.ServerTypeProxy || 
		this.ServerType == ServerType.ServerTypeLDAP) {
		content += '</div>';
	}
	
	//Add check box for OCSP server
	if(this.ServerType == ServerType.ServerTypeOCSP) {
		content += '<div><input type="checkbox" id=' + this.TabID + BeforeStoreCheckBoxID + ' />Перевіряти до перевірки у файловому сховищі</div>';
	}
	content += '</div>';
	content += '</div>';
	
	return content;
},
"WillShow": function() {
	this._attachEvents();
	this._useCheckBoxClick();
},
"Validate": function() {
	var Address = document.getElementById(this.TabID + AddressTextEditID).value;
	var Port = document.getElementById(this.TabID + PortTextEditID).value;
	
	var UserTextEdit = document.getElementById(this.TabID + UserTextEditID);
	var AuthCheckBox = document.getElementById(this.TabID + AuthCheckBoxID);
	var AnonymousCheckBox = document.getElementById(this.TabID + AnonymousCheckBoxID); 
		
	if(document.getElementById(this.TabID + UseCheckBoxID).checked) {
		if(!CheckServerData(this.ServerType.name, Address, Port))
			return false;
		
		if(UserTextEdit) {
			var needUserInfo = false;
			if(AuthCheckBox) {
				needUserInfo = AuthCheckBox.checked;
			}
			else if(AnonymousCheckBox) {
				needUserInfo = !AnonymousCheckBox.checked;
			}
			
			if(needUserInfo && (UserTextEdit.value == '') ) {
				alert('Не вказане ім\'я користувача ' + this.ServerType.name);
				return false;		
			}
		}
	}	
		
	return true;
},
"Use": function(use){
	if(arguments.length == 1) {
		document.getElementById(this.TabID + UseCheckBoxID).checked = use;
	}
	else {
		return document.getElementById(this.TabID + UseCheckBoxID).checked;
	}
},
"ServerAddress": function(serverAddress) {
	if(arguments.length == 1) {
		document.getElementById(this.TabID + AddressTextEditID).value = serverAddress;
	}
	else {
		return document.getElementById(this.TabID + AddressTextEditID).value;
	}
},
"ServerPort": function(serverPort) {
	if(arguments.length == 1) {
		document.getElementById(this.TabID + PortTextEditID).value = serverPort;
	}
	else {
		return document.getElementById(this.TabID + PortTextEditID).value;
	}
},
"Anonymous": function(anonymous) {
	var AuthCheckBox = document.getElementById(this.TabID + AuthCheckBoxID);
	var AnonymousCheckBox = document.getElementById(this.TabID + AnonymousCheckBoxID);
	
	if(arguments.length == 1) {
		if(AuthCheckBox)
			AuthCheckBox.checked = !anonymous;
		else if(AnonymousCheckBox)
			AnonymousCheckBox.checked = anonymous;
	}
	else {
		if(AuthCheckBox) {
			return !AuthCheckBox.checked;
		}
		else if(AnonymousCheckBox) {
			return AnonymousCheckBox.checked;
		}
	}
},
"BeforeStore": function(beforeStore) {
	var BeforeStoreCheckBox = document.getElementById(this.TabID + BeforeStoreCheckBoxID);
	if(arguments.length == 1) {
		BeforeStoreCheckBox.checked = beforeStore;
	}
	else {
		return BeforeStoreCheckBox.checked;
	}
},
"User": function(user) {
	var UserTextEdit = document.getElementById(this.TabID + UserTextEditID);
	if(arguments.length == 1) {
		UserTextEdit.value = user;
	}
	else {
		return UserTextEdit.value;
	}
},
"SavePassword": function(save) {
	var PasswordCheckBox = document.getElementById(this.TabID + PasswordCheckBoxID);
	if(arguments.length == 1) {
		PasswordCheckBox.checked = save;
	}
	else {
		return PasswordCheckBox.checked;
	}
},
"Password": function(password) {
	var PasswordTextEdit = document.getElementById(this.TabID + PasswordTextEditID);
	if(arguments.length == 1) {
		PasswordTextEdit.value = password;
	}
	else {
		return PasswordTextEdit.value;
	}
},
"_attachChangeEvent": function(ItemsIDs) {
	var thisForm = this;
	
	for(var i = 0; i < arguments.length; i++) {
		var element = document.getElementById(this.TabID + arguments[i]);
		if(element)
			element.onclick = function(){thisForm.onChange();};
	}
},
"_attachEvents": function() {
	var thisForm = this;
	
	var UseCheckBox	= document.getElementById(this.TabID + UseCheckBoxID);
	UseCheckBox.onclick = function(){thisForm._useCheckBoxClick(); thisForm.onChange();};
	
	var AuthCheckBox = document.getElementById(this.TabID + AuthCheckBoxID);
	if(AuthCheckBox)
		AuthCheckBox.onclick = function(){thisForm._authCheckBoxClick(this.checked); thisForm.onChange();};
	
	var AnonymousCheckBox = document.getElementById(this.TabID + AnonymousCheckBoxID);
	if(AnonymousCheckBox)
		AnonymousCheckBox.onclick = function(){ thisForm._authCheckBoxClick(!this.checked);  thisForm.onChange();};

	var FromCertBtn = document.getElementById(this.TabID + FromCertButtonID);
	if(FromCertBtn)		
		FromCertBtn.onclick = function(){thisForm._fromCertButtonClick();};
	
	this._attachChangeEvent(AddressTextEditID, PortTextEditID, UserTextEditID, 
		PasswordTextEditID, PasswordCheckBoxID, BeforeStoreCheckBoxID);
},
"_authCheckBoxClick": function(checked) {
	disabled = "";
	var visibility = "visible";
	var UserTextEdit = document.getElementById(this.TabID + UserTextEditID);
	var PasswordTextEdit = document.getElementById(this.TabID + PasswordTextEditID);
	var PasswordCheckBox = document.getElementById(this.TabID + PasswordCheckBoxID);
	
	if(!checked) {
		disabled = "disabled";
		visibility = "hidden";
		UserTextEdit.value = "";
		PasswordTextEdit.value = "";
		if(PasswordCheckBox)
			PasswordCheckBox.checked = false;
	}
	
	UserTextEdit.disabled = disabled;
	PasswordTextEdit.disabled = disabled;
	if(PasswordCheckBox)
		PasswordCheckBox.disabled = disabled;
	
	document.getElementById(this.TabID + AuthElementID).style.visibility = visibility;
},
"_fromCertButtonClick": function(certInfo) {
	if(arguments.length == 0) {
	var thisForm = this;
		var euCertificatesForm = EUCertificatesForm(frameHeight, frameWidth + 100, 400, 600);
				euCertificatesForm.SelectCertificate('Сертифікат '+ this.ServerType.name + 'a', 
				this.ServerType.certType, 
				function(certInfo){thisForm._fromCertButtonClick(certInfo);},
				function(){});
	}
	else {
		if(certInfo == null)
			return;
			
		if(this.ServerType == ServerType.ServerTypeOCSP) {
			var serverNames = document.getElementById(this.TabID + AddressTextEditID).value;
			if(IsServerNameExist(certInfo.GetSubjDNS(), serverNames)) {
				alert(this.ServerType.name + ' вже є у списку');
				return;
			}
			if(serverNames != "") {
				var namesArray = serverNames.split(";");
				serverNames = "";
				for(var i = 0; i < namesArray.length; i++) {
					var tmp = namesArray[i].replace(/[ ]/g,'');
					if(tmp != "")
						serverNames += tmp + ';';
				}
			}
			serverNames += certInfo.GetSubjDNS();
			document.getElementById(this.TabID + AddressTextEditID).value = serverNames;
		}
		else {
			document.getElementById(this.TabID + AddressTextEditID).value = certInfo.GetSubjDNS();
		}
		this.onChange();
	}
},
"_useCheckBoxClick": function() {
	var disabled = "";
	var visibility = "visible";
	var AuthCheckBox = document.getElementById(this.TabID + AuthCheckBoxID);
	var AnonymousCheckBox = document.getElementById(this.TabID + AnonymousCheckBoxID);
	var BeforeStoreCheckBox = document.getElementById(this.TabID + BeforeStoreCheckBoxID);
	var FromCertButton = document.getElementById(this.TabID + FromCertButtonID);
	
	if(!document.getElementById(this.TabID + UseCheckBoxID).checked) {
		disabled = "disabled";
		document.getElementById(this.TabID + AddressTextEditID).value = "";
		document.getElementById(this.TabID + PortTextEditID).value = this.ServerType.port;
		
		if(AuthCheckBox)
			AuthCheckBox.checked = false;
		if(AnonymousCheckBox)
			AnonymousCheckBox.checked = true;
		if(BeforeStoreCheckBox)
			BeforeStoreCheckBox.checked = false;
		visibility = "hidden";
	}
	
	document.getElementById(this.TabID + HiddenFormElementsID).style.visibility = visibility;
	document.getElementById(this.TabID + AddressTextEditID).disabled = disabled;
	document.getElementById(this.TabID + PortTextEditID).disabled = disabled;
	
	if(FromCertButton)
		FromCertButton.disabled = disabled;
	
	if(AuthCheckBox) {
		AuthCheckBox.disabled = disabled;
		this._authCheckBoxClick(AuthCheckBox.checked);
	}
	
	if(AnonymousCheckBox) {
		AnonymousCheckBox.disabled = disabled;
		this._authCheckBoxClick(!AnonymousCheckBox.checked);
	}
	
	if(BeforeStoreCheckBox)
		BeforeStoreCheckBox.disabled = disabled;
}

}
)

//=============================================================================

var CertCatalogTextEditID = "CertCatalogTextEdit";
var ChangeCertCatalogButtonID = "ChangeCertCatalogButton";
var AutoReadChangesCheckBoxID = "AutoReadChangesCheckBox";
var SaveCertFromOCSPCheckBoxID = "SaveCertificatesFromOCSPCheckBox";
var ExpireTimeTextEditID = "TimeOfCertStoreTextEdit";
var CheckCRLsCheckBoxID = "CheckCRLsCheckBox";
var OnlyOwnCACheckBoxID = "OnlyOwnCACheckBox";
var AutoDownloadCRLsCheckBoxID = "AutoDownloadCRLsCheckBox";
var FullAndDeltaCRLsCheckBoxID = "FullAndDeltaCRLsCheckBox";

//=============================================================================

var EUFileStorageTab = NewClass({
	"TabID": "null",
	"onChange": null
}, 
function(TabID, onChange) {
	this.TabID = TabID;
	this.onChange = onChange;
},

{
"GetContent": function() {
	var content = "";
	content = '<div id=' + this.TabID + ' style="display: none;" class="SettingsTab">\
			<h3 class="SettingsTabHeader">Файлове сховище сертифікатів та СВС</h3>';
	
	content +=	'<p class="SettingsParameter">Параметри файлового сховища</p>\
		<div>Каталог з сертифікатами та СВС:</div>\
		<div><input type="text" id=' + CertCatalogTextEditID + ' class="edit" style="width:95%;"/></div>\
		<div align="right" style="padding: 0px 10px 0px 0px"><input type="button" value="Змінити",\
								id=' + ChangeCertCatalogButtonID + ' style="width:185px;" class="button"/></div>\
		\
		<div><input type="checkbox" id=' + AutoReadChangesCheckBoxID + ' />Автоматично перечитувати при виявленні змін</div>\
		<div><input type="checkbox" id=' + SaveCertFromOCSPCheckBoxID + ' />Зберігати сертифікати, що отримані з OCSP- чи LDAP-серверів</div>\
		<div>Час зберігання стану перевіреного сертифікату, с: <input type="text" id=' + ExpireTimeTextEditID + ' class="edit" style="width:12%;"/></div>\
		\
		<p class="SettingsParameter"><input type="checkbox" id=' + CheckCRLsCheckBoxID + ' />Перевіряти СВС</p>';
	content += '<div id=' + this.TabID + HiddenFormElementsID + '>';
	content += '<div><input type="checkbox" id=' + OnlyOwnCACheckBoxID + ' />Тільки свого ЦСК</div>\
		<div><input type="checkbox" id=' + FullAndDeltaCRLsCheckBoxID + ' />Повний та частковий</div>\
		<div><input type="checkbox" id=' + AutoDownloadCRLsCheckBoxID + ' />Завантажувати автоматично</div>\
		</div>'
	
	content += '</div>';
	content += '</div>';
	
	return content;
},
"WillShow": function() {
	this._attachEvents();
	this._checkCRLsCheckBoxClick();
},
"Validate": function() {
	var Path = document.getElementById(CertCatalogTextEditID).value;
	var ExpireTime = parseInt(document.getElementById(ExpireTimeTextEditID).value, 10);

	if(Path == "") {
		alert("Не вказане ім''я каталогу з сертифікатами та СВС");
		return false;
	}
	
	if ((ExpireTime < 1) ||  (ExpireTime > 60 * 60 * 24)) {
		alert('Час зберігання стану перевіреного сертифіката ' +
				'має невірний формат (повинен бути в діапазоні від ' +
				'1 до 86 400 с (1 доби))');
		return false;
	}
		
	return true;
},
"Path": function(path) {
	if(arguments.length == 1) {
		document.getElementById(CertCatalogTextEditID).value = path;
	}
	else {
		return document.getElementById(CertCatalogTextEditID).value;
	}
},
"CheckCRLs": function(checkCRLs) {
	if(arguments.length == 1) {
		document.getElementById(CheckCRLsCheckBoxID).checked = checkCRLs;
	}
	else {
		return document.getElementById(CheckCRLsCheckBoxID).checked;
	}
},
"AutoRefresh": function(autoRefresh) {
	if(arguments.length == 1) {
		document.getElementById(AutoReadChangesCheckBoxID).checked = autoRefresh;
	}
	else {
		return document.getElementById(AutoReadChangesCheckBoxID).checked;
	}
},
"OwnCRLsOnly": function(ownCRLsOnly) {
	if(arguments.length == 1) {
		document.getElementById(OnlyOwnCACheckBoxID).checked = ownCRLsOnly;
	}
	else {
		return document.getElementById(OnlyOwnCACheckBoxID).checked;
	}
},
"FullAndDeltaCRLs": function(fullAndDeltaCRLs) {
	if(arguments.length == 1) {
		document.getElementById(FullAndDeltaCRLsCheckBoxID).checked = fullAndDeltaCRLs;
	}
	else {
		return document.getElementById(FullAndDeltaCRLsCheckBoxID).checked;
	}
},
"AutoDownloadCRLs": function(autoDownloadCRLs) {
	if(arguments.length == 1) {
		document.getElementById(AutoDownloadCRLsCheckBoxID).checked = autoDownloadCRLs;
	}
	else {
		return document.getElementById(AutoDownloadCRLsCheckBoxID).checked;
	}
},
"SaveLoadedCerts": function(saveLoadedCerts) {
	if(arguments.length == 1) {
		document.getElementById(SaveCertFromOCSPCheckBoxID).checked = saveLoadedCerts;
	}
	else {
		return document.getElementById(SaveCertFromOCSPCheckBoxID).checked;
	}
},
"ExpireTime": function(expireTime) {
	if(arguments.length == 1) {
		document.getElementById(ExpireTimeTextEditID).value = expireTime;
	}
	else {
		return document.getElementById(ExpireTimeTextEditID).value;
	}
},
"_attachChangeEvent": function(ItemsIDs) {
	var thisForm = this;
	
	for(var i = 0; i < arguments.length; i++) {
		var element = document.getElementById(arguments[i]);
		if(element)
			element.onclick = function(){thisForm.onChange();};
	}
},
"_attachEvents": function() {
	var thisForm = this;
	var CheckCRLsCheckBox = document.getElementById(CheckCRLsCheckBoxID);
	CheckCRLsCheckBox.onclick = function(){thisForm._checkCRLsCheckBoxClick();  thisForm.onChange();};

	var AutoDownloadCRLsCheckBox = document.getElementById(AutoDownloadCRLsCheckBoxID);
	AutoDownloadCRLsCheckBox.onclick = function(){thisForm._autoDownloadCRLsCheckBoxClick();  thisForm.onChange();};
	
	var ChangeCertCatalogButton = document.getElementById(ChangeCertCatalogButtonID);
	ChangeCertCatalogButton.onclick = function(){thisForm._changeCatalogButtonClick();  thisForm.onChange();}
	
	this._attachChangeEvent(CertCatalogTextEditID, AutoReadChangesCheckBoxID, SaveCertFromOCSPCheckBoxID, 
		ExpireTimeTextEditID, OnlyOwnCACheckBoxID, FullAndDeltaCRLsCheckBoxID);
},
"_autoDownloadCRLsCheckBoxClick": function() {
	disabled = "";
	
	if(!document.getElementById(AutoDownloadCRLsCheckBoxID).checked || 
		document.getElementById(AutoDownloadCRLsCheckBoxID).disabled != "") {
		disabled = "disabled";
		document.getElementById(FullAndDeltaCRLsCheckBoxID).checked = false; 
	}
	
	document.getElementById(FullAndDeltaCRLsCheckBoxID).disabled = disabled;
},
"_checkCRLsCheckBoxClick": function() {
	var disabled = "";
	var visibility = "visible";
	if(!document.getElementById(CheckCRLsCheckBoxID).checked) {
		disabled = "disabled";
		visibility = "hidden";
		document.getElementById(OnlyOwnCACheckBoxID).checked = false;
		document.getElementById(AutoDownloadCRLsCheckBoxID).checked = false;
	}
	
	document.getElementById(this.TabID + HiddenFormElementsID).style.visibility = visibility;
	document.getElementById(OnlyOwnCACheckBoxID).disabled = disabled;
	document.getElementById(AutoDownloadCRLsCheckBoxID).disabled = disabled;
	this._autoDownloadCRLsCheckBoxClick();
},
"_changeCatalogButtonClick": function() {
	try { 
		var catalogName = euSign.SelectFolder();
		if(catalogName == "" || catalogName == null) 
			return;
		document.getElementById(CertCatalogTextEditID).value = catalogName;
	} catch(e) {
		alert(e);
	}
}
}
)



////////////////////////////////////////////////////////////////////
//from Settings.js


//=============================================================================

var CloseSettingsButtonID = "CloseSettingsButton";
var SaveSettingsButtonID = "SaveSettingsButton";

var FileStorageTabID = "FileStorageTab";
var ProxyServerTabID = "ProxyServerTab";
var TSPServerTabID = "TSPServerTab";
var OCSPServerTabID = "OCSPServerTab";
var LDAPServerTabID = "LDAPServerTab";
var CMPServerTabID = "CMPServerTab";

var ContentSuffix = "Content";

//=============================================================================

var MakeClass = function() {
	return function( args ) {
	    if( this instanceof arguments.callee ) {
	        if( typeof this.__construct == "function" ) 
				this.__construct.apply( this, args );
	    }
		else return new arguments.callee( arguments );
	};
}

var NewClass = function( variables, constructor, functions ) {
	var retn = MakeClass();
	for( var key in variables ) {
		retn.prototype[key] = variables[key];
	}
	for( var key in functions ) {
		retn.prototype[key] = functions[key];
	}
	retn.prototype.__construct = constructor;
	return retn;
}	  

//=============================================================================

var EUSettingsForm = NewClass({
	"frameHeight": "0",
	"frameWidth": "0",
	"formHeight": "0",
	"formWidth": "0",
	
	"ShowingTabID": "null",
		
	"ProxyServerTab": "null",
	"TSPServerTab": "null",
	"OCSPServerTab": "null",
	"LDAPServerTab": "null",
	"CMPServerTab": "null",
	
	"DOMElement": "",
	"dimmer": ""
}, 

function(frameHeight, frameWidth, formHeight, formWidth) {
	this.frameHeight = frameHeight;
	this.frameWidth  = frameWidth;
	this.formHeight  = formHeight;
	this.formWidth 	 = formWidth;
	
	var thisForm = this;
	
	this.FileStorageTab = EUFileStorageTab(FileStorageTabID + ContentSuffix, thisForm._settingsChange);
	this.ProxyServerTab = EUServerSettingsTab(ProxyServerTabID + ContentSuffix, ServerType.ServerTypeProxy, thisForm._settingsChange);
	this.TSPServerTab = EUServerSettingsTab(TSPServerTabID + ContentSuffix, ServerType.ServerTypeTSP, thisForm._settingsChange);
	this.OCSPServerTab = EUServerSettingsTab(OCSPServerTabID + ContentSuffix, ServerType.ServerTypeOCSP, thisForm._settingsChange);
	this.LDAPServerTab = EUServerSettingsTab(LDAPServerTabID + ContentSuffix, ServerType.ServerTypeLDAP, thisForm._settingsChange);
	this.CMPServerTab = EUServerSettingsTab(CMPServerTabID + ContentSuffix, ServerType.ServerTypeCMP, thisForm._settingsChange);
},
{
"ShowForm": function() {
	this.dimmer = document.getElementById('opaco');
	this.dimmer.style.display = "block";
	this.dimmer.style.height = document.body.clientHeight + 'px'; 
	
	this.DOMElement = this._constructForm();
	this.DOMElement.style.width = this.formWidth + 'px';
	this.DOMElement.style.minHeight = this.formHeight + 'px';
	this.DOMElement.style.left = Math.floor(document.body.clientWidth/2) - this.formWidth / 2 + 'px';
	this.DOMElement.style.zIndex = 11;
	document.body.appendChild(this.DOMElement);

	this._attachEvents();
	document.getElementById(SaveSettingsButtonID).disabled = "disabled";
	ShowSpinner('SettingsForm');
	this.UpdateForm();
	HideSpinner('');
	this._showTabContent(FileStorageTabID);
	return false;
},
"CloseForm": function() {
	if(this.WasChanged()) {
		if(confirm("Зберегти параметри роботи перед виходом?")){
			ShowSpinner('SettingsForm');
			if(!this.SaveForm()) {
				HideSpinner('');
				return;
			}
			HideSpinner('');
		}
	}
	
	this.DOMElement.parentNode.removeChild(this.DOMElement);
	document.getElementById('opaco').style.display = "none";
	
	return false;
},
"SaveForm": function() {
	if(!this.WasChanged())
		return true;
	
	var	wasSaved = true;
	if(!this.FileStorageTab.Validate())
	{
		this._showTabContent(FileStorageTabID);
		return false;
	}
	wasSaved &= this._saveFileStorageSettings();

	if(!this.ProxyServerTab.Validate()) {
		this._showTabContent(ProxyServerTabID);
		return false;
	}
	wasSaved &= this._saveProxyServerSettings();

	if(!this.TSPServerTab.Validate()) {
		this._showTabContent(TSPServerTabID);
		return false;
	}
	wasSaved &= this._saveTSPServerSettings();

	if(!this.OCSPServerTab.Validate()) {
		this._showTabContent(OCSPServerTabID);
		return false;
	}
	wasSaved &= this._saveOCSPServerSettings();;

	if(!this.LDAPServerTab.Validate()) {
		this._showTabContent(LDAPServerTabID);
		return false;
	}
	wasSaved &= this._saveLDAPServerSettings();
		
	if(!this.CMPServerTab.Validate()) {
		this._showTabContent(CMPServerTabID);
		return false;
	}
	wasSaved &= this._saveCMPServerSettings();
	
	if(!wasSaved && euSign.DoesNeedSetSettings()) {
		alert("Виникла помилка при збереженні параметрів");
		return false;
	} else {
		document.getElementById(SaveSettingsButtonID).disabled = "disabled";
		alert("Параметри було успішно збережено");
		return true;
	}
},
"UpdateForm": function() {
	var retVal  = this._updateFileStorageContent();
	    retVal &= this._updateProxyContent();
	    retVal &= this._updateTSPContent();
	    retVal &= this._updateOCSPContent();
	    retVal &= this._updateLDAPContent();
	    retVal &= this._updateCMPContent();
	if(!retVal || euSign.DoesNeedSetSettings()) {
		if(confirm("Виникла помилка при отриманні параметрів.\n" +
			"Встановити налаштування бібліотеки за замовчуванням?")) {
			
			try {
				var installPath = euSign.GetInstallPath() + "\\Certificates and CRLs";
				euSign.CreateFolder(installPath);
				this.FileStorageTab.Path(installPath);
				this._settingsChange();
			} catch(e) {
				showException(e);
			}
			
			return;
		}
		else {			
			alert("Для продовження роботи встановіть параметри файлового сховища сертифікатів та СВС");
		}
	}
},
"WasChanged": function() {
	return (document.getElementById(SaveSettingsButtonID).disabled == "");
},
"_attachEvents": function() {
	var thisForm = this;
	
	var CloseSettingsButton = document.getElementById(CloseSettingsButtonID);
	CloseSettingsButton.onclick = function(){thisForm.CloseForm(); return false};
	
	var SaveSettingsButton = document.getElementById(SaveSettingsButtonID);
	SaveSettingsButton.onclick = function(){
				ShowSpinner('SettingsForm'); 
				thisForm.SaveForm(); 
				HideSpinner('');
				return false};
	var Tab = document.getElementById(FileStorageTabID);
	Tab.onclick = function(){thisForm._showTabContent(FileStorageTabID); return false};
	Tab = document.getElementById(ProxyServerTabID);
	Tab.onclick = function(){thisForm._showTabContent(ProxyServerTabID); return false};
	Tab = document.getElementById(TSPServerTabID);
	Tab.onclick = function(){thisForm._showTabContent(TSPServerTabID); return false};
	Tab = document.getElementById(OCSPServerTabID);
	Tab.onclick = function(){thisForm._showTabContent(OCSPServerTabID); return false};
	Tab = document.getElementById(LDAPServerTabID);
	Tab.onclick = function(){thisForm._showTabContent(LDAPServerTabID); return false};
	Tab = document.getElementById(CMPServerTabID);
	Tab.onclick = function(){thisForm._showTabContent(CMPServerTabID); return false};
},
"_constructForm": function() {
	var  container = document.createElement('div')
	var formContent = '<div class="Form" id="SettingsForm">'; 
	formContent += '<form name="Settings" action="#" class="FormSettings">'; 
	formContent += '<div align="center"><h2 class="FormHeader">Параметри роботи</h2></div>'; 
		
	formContent += '<table height=90% width=100% border="1" class="border" bordercolor="#C0C0C0">';
	
	formContent += '<tr style="vertical-align: top;">';
	formContent += '<td style="width:27%">'; 
	
	formContent += '<ul id="Tabs">\
		<li id=' + FileStorageTabID + ' class="Tab"><a href="#FileStorage" return false;">Файлове сховище</a></li>\
		<li id=' + ProxyServerTabID + ' class="Tab"><a href="#ProxyServer" return false;">Proxy-сервер</a></li>\
		<li id=' + TSPServerTabID + ' class="Tab"><a href="#TSPServer" return false;">TSP-сервер</a></li>\
		<li id=' + OCSPServerTabID + ' class="Tab"><a href="#OCSPServer" return false;">OCSP-сервер</a></li>\
		<li id=' + LDAPServerTabID + ' class="Tab"><a href="#LDAPServer" return false;">LDAP-сервер</a></li>\
		<li id=' + CMPServerTabID + ' class="Tab"><a href="#CMPServer" return false;">CMP-сервер</a></li>\
	</ul>';
	formContent += '</td>';
	formContent += '<td style="padding: 10px 10px 10px 10px">' + 
							this.FileStorageTab.GetContent() + 
							this.ProxyServerTab.GetContent() + 
							this.TSPServerTab.GetContent() + 
							this.OCSPServerTab.GetContent() + 
							this.LDAPServerTab.GetContent() + 
							this.CMPServerTab.GetContent() + 
							'</td>';
	formContent += '</tr>';
	
	
	formContent += '</table></br>';

	formContent += '<div align="right" style="padding: 0px 10px 10px 0px"><input type="button" value="Зберегти",\
								id=\"' + SaveSettingsButtonID + '\" style="width:185px;" class="button" />';
	formContent += '<input type="button" value="Закрити",\
								id=\"' + CloseSettingsButtonID + '\" style="width:185px;" class="button" /></div>';
	
	formContent += "</form>"; 
	formContent += "</div>"; 
	
	container.innerHTML = formContent;
	
	return container.firstChild;
},
"_showTabContent": function (tabToShowID) {

	if (tabToShowID == this.ShowingTabID)
		return;
	document.getElementById(tabToShowID).className = 'SelectedTab';
	document.getElementById(tabToShowID).href = 'Tab';
	if(this.ShowingTabID != "null")
		document.getElementById(this.ShowingTabID).className = 'Tab';

	document.getElementById(tabToShowID + ContentSuffix).style.display = 'block';
	if(this.ShowingTabID != "null")
		document.getElementById(this.ShowingTabID + ContentSuffix).style.display = 'none';

	this.ShowingTabID = tabToShowID;
},
//-----------------------------------------------------------------------------
"_settingsChange": function(){
	document.getElementById(SaveSettingsButtonID).disabled = "";
},
"_saveFileStorageSettings": function() {	
	var settings = euSign.CreateFileStoreSettings();
	settings.SetPath(this.FileStorageTab.Path());
	settings.SetCheckCRLs(this.FileStorageTab.CheckCRLs());
	settings.SetAutoRefresh(this.FileStorageTab.AutoRefresh());
	settings.SetOwnCRLsOnly(this.FileStorageTab.OwnCRLsOnly());
	settings.SetFullAndDeltaCRLs(this.FileStorageTab.FullAndDeltaCRLs());
	settings.SetAutoDownloadCRLs(this.FileStorageTab.AutoDownloadCRLs());
	settings.SetSaveLoadedCerts(this.FileStorageTab.SaveLoadedCerts());
	settings.SetExpireTime(parseInt(this.FileStorageTab.ExpireTime(), 10));
	var wasSaved;
	try {
		euSign.SetFileStoreSettings(settings);
		wasSaved = true;
	} catch(e) {
		wasSaved = false;
	}
	
	return wasSaved;
},
"_saveProxyServerSettings": function() {
	var settings = euSign.CreateProxySettings();
	settings.SetUseProxy(this.ProxyServerTab.Use());
	settings.SetAnonymous(this.ProxyServerTab.Anonymous());
	settings.SetAddress(this.ProxyServerTab.ServerAddress());
	settings.SetPort(this.ProxyServerTab.ServerPort());
	settings.SetUser(this.ProxyServerTab.User());
	settings.SetPassword(this.ProxyServerTab.Password());
	settings.SetSavePassword(this.ProxyServerTab.SavePassword());
	var wasSaved;
	try {
		euSign.SetProxySettings(settings);
		wasSaved = true;
	} catch(e){
		wasSaved = false;
	}

	return wasSaved;
},
"_saveTSPServerSettings": function() {
	var settings = euSign.CreateTSPSettings();
	settings.SetGetStamps(this.TSPServerTab.Use());
	settings.SetAddress(this.TSPServerTab.ServerAddress());
	settings.SetPort(this.TSPServerTab.ServerPort());	
	var wasSaved;
	try {
		euSign.SetTSPSettings(settings);
		wasSaved = true;
	} catch(e){
		wasSaved = false;
	}	

	return wasSaved;
},
"_saveOCSPServerSettings": function() {	
	var settings = euSign.CreateOCSPSettings();
	settings.SetUseOCSP(this.OCSPServerTab.Use());
	settings.SetBeforeStore(this.OCSPServerTab.BeforeStore());
	settings.SetAddress(this.OCSPServerTab.ServerAddress());
	settings.SetPort(this.OCSPServerTab.ServerPort());
	var wasSaved;
	try {
		euSign.SetOCSPSettings(settings);
		wasSaved = true;
	} catch(e){
		wasSaved = false;
	}		

	return wasSaved;
},
"_saveLDAPServerSettings": function() {
	var settings = euSign.CreateLDAPSettings();
	settings.SetUseLDAP(this.LDAPServerTab.Use());
	settings.SetAnonymous(this.LDAPServerTab.Anonymous());
	settings.SetAddress(this.LDAPServerTab.ServerAddress());
	settings.SetPort(this.LDAPServerTab.ServerPort());
	settings.SetUser(this.LDAPServerTab.User());
	settings.SetPassword(this.LDAPServerTab.Password());
	var wasSaved;
	try {
		euSign.SetLDAPSettings(settings);
		wasSaved = true;
	} catch(e){
		wasSaved = false;
	}	

	return wasSaved;
},
"_saveCMPServerSettings": function() {
	var settings = euSign.CreateCMPSettings();
	settings.SetUseCMP(this.CMPServerTab.Use());
	settings.SetAddress(this.CMPServerTab.ServerAddress());
	settings.SetPort(this.CMPServerTab.ServerPort());
	settings.SetCommonName("");
	var wasSaved;
	try {
		euSign.SetCMPSettings(settings);
		wasSaved = true;
	} catch(e){
		wasSaved = false;
	}		

	return wasSaved;
},
"_updateFileStorageContent": function() {
	var fileStoreSettings;
	var wasUpdated;
	try {
		fileStoreSettings = euSign.GetFileStoreSettings();
		wasUpdated = true;
	} catch(e) {
		fileStoreSettings = euSign.CreateFileStoreSettings();
		wasUpdated = false;
	}
	
	this.FileStorageTab.Path(fileStoreSettings.GetPath());
	this.FileStorageTab.CheckCRLs(fileStoreSettings.GetCheckCRLs()); 
	this.FileStorageTab.AutoRefresh(fileStoreSettings.GetAutoRefresh()); 
	this.FileStorageTab.OwnCRLsOnly(fileStoreSettings.GetOwnCRLsOnly());
	this.FileStorageTab.FullAndDeltaCRLs(fileStoreSettings.GetFullAndDeltaCRLs()); 
	this.FileStorageTab.AutoDownloadCRLs(fileStoreSettings.GetAutoDownloadCRLs());
	this.FileStorageTab.SaveLoadedCerts(fileStoreSettings.GetSaveLoadedCerts()); 
	this.FileStorageTab.ExpireTime(fileStoreSettings.GetExpireTime());
	
	this.FileStorageTab.WillShow();

	return wasUpdated;
}, 
"_updateProxyContent": function() {
	var proxyServerSettings;
	var wasUpdated;
	try {
		proxyServerSettings = euSign.GetProxySettings();
		wasUpdated = true;
	} catch(e) {
		proxyServerSettings = euSign.CreateProxySettings();
		wasUpdated = false;
	}
	
	this.ProxyServerTab.Use(proxyServerSettings.GetUseProxy());
		
	this.ProxyServerTab.ServerAddress(proxyServerSettings.GetAddress());
	this.ProxyServerTab.ServerPort(proxyServerSettings.GetPort());
	this.ProxyServerTab.Anonymous(proxyServerSettings.GetAnonymous());
	this.ProxyServerTab.SavePassword(proxyServerSettings.GetSavePassword());
	this.ProxyServerTab.User(proxyServerSettings.GetUser());
	this.ProxyServerTab.Password(proxyServerSettings.GetPassword());
	
	this.ProxyServerTab.WillShow();

	return wasUpdated;
},
"_updateTSPContent": function() {
	var tspServerSettings;
	var wasUpdated;
	try {
		tspServerSettings = euSign.GetTSPSettings();
		wasUpdated = true;
	} catch(e) {
		tspServerSettings = euSign.CreateTSPSettings();
		wasUpdated = false;
	}

	this.TSPServerTab.Use(tspServerSettings.GetGetStamps());
		
	this.TSPServerTab.ServerAddress(tspServerSettings.GetAddress());
	this.TSPServerTab.ServerPort(tspServerSettings.GetPort());

	this.TSPServerTab.WillShow();
	
	return wasUpdated;
},
"_updateOCSPContent": function() {
	var ocspServerSettings;
	var wasUpdated;
	try {
		ocspServerSettings = euSign.GetOCSPSettings();
		wasUpdated = true;
	} catch(e) {
		ocspServerSettings = euSign.CreateOCSPSettings();
		wasUpdated = false;
	}
	this.OCSPServerTab.Use(ocspServerSettings.GetUseOCSP());
		
	this.OCSPServerTab.ServerAddress(ocspServerSettings.GetAddress());
	this.OCSPServerTab.ServerPort(ocspServerSettings.GetPort());
	this.OCSPServerTab.BeforeStore(ocspServerSettings.GetBeforeStore());
	
	this.OCSPServerTab.WillShow();
	
	return wasUpdated;
},
"_updateLDAPContent": function() {
	var ldapServerSettings;
	var wasUpdated;
	try {
		ldapServerSettings = euSign.GetLDAPSettings();
		wasUpdated = true;
	} catch(e) {
		ldapServerSettings = euSign.CreateLDAPSettings();
		wasUpdated = false;
	}
	this.LDAPServerTab.Use(ldapServerSettings.GetUseLDAP());
		
	this.LDAPServerTab.ServerAddress(ldapServerSettings.GetAddress());
	this.LDAPServerTab.ServerPort(ldapServerSettings.GetPort());
	this.LDAPServerTab.Anonymous(ldapServerSettings.GetAnonymous());
	this.LDAPServerTab.User(ldapServerSettings.GetUser());
	this.LDAPServerTab.Password(ldapServerSettings.GetPassword());
	
	this.LDAPServerTab.WillShow();
	
	return wasUpdated;
},
"_updateCMPContent": function() {
	var cmpServerSettings;
	var wasUpdated;
	try {
		cmpServerSettings = euSign.GetCMPSettings();
		wasUpdated = true;
	} catch(e) {
		cmpServerSettings = euSign.GetCMPSettings();
		wasUpdated = false;
	}

	this.CMPServerTab.Use(cmpServerSettings.GetUseCMP());
		
	this.CMPServerTab.ServerAddress(cmpServerSettings.GetAddress());
	this.CMPServerTab.ServerPort(cmpServerSettings.GetPort());
	
	this.CMPServerTab.WillShow();

	return wasUpdated;
}
}

);


/////////////////////////////////////////////////////////////////////
//from Spin.js


!function(e,t,n){function o(e,n){var r=t.createElement(e||"div"),i;for(i in n)r[i]=n[i];return r}function u(e){for(var t=1,n=arguments.length;t<n;t++)e.appendChild(arguments[t]);return e}function f(e,t,n,r){var o=["opacity",t,~~(e*100),n,r].join("-"),u=.01+n/r*100,f=Math.max(1-(1-e)/t*(100-u),e),l=s.substring(0,s.indexOf("Animation")).toLowerCase(),c=l&&"-"+l+"-"||"";return i[o]||(a.insertRule("@"+c+"keyframes "+o+"{"+"0%{opacity:"+f+"}"+u+"%{opacity:"+e+"}"+(u+.01)+"%{opacity:1}"+(u+t)%100+"%{opacity:"+e+"}"+"100%{opacity:"+f+"}"+"}",a.cssRules.length),i[o]=1),o}function l(e,t){var i=e.style,s,o;if(i[t]!==n)return t;t=t.charAt(0).toUpperCase()+t.slice(1);for(o=0;o<r.length;o++){s=r[o]+t;if(i[s]!==n)return s}}function c(e,t){for(var n in t)e.style[l(e,n)||n]=t[n];return e}function h(e){for(var t=1;t<arguments.length;t++){var r=arguments[t];for(var i in r)e[i]===n&&(e[i]=r[i])}return e}function p(e){var t={x:e.offsetLeft,y:e.offsetTop};while(e=e.offsetParent)t.x+=e.offsetLeft,t.y+=e.offsetTop;return t}var r=["webkit","Moz","ms","O"],i={},s,a=function(){var e=o("style",{type:"text/css"});return u(t.getElementsByTagName("head")[0],e),e.sheet||e.styleSheet}(),d={lines:12,length:7,width:5,radius:10,rotate:0,corners:1,color:"#000",speed:1,trail:100,opacity:.25,fps:20,zIndex:2e9,className:"spinner",top:"auto",left:"auto",position:"relative"},v=function m(e){if(!this.spin)return new m(e);this.opts=h(e||{},m.defaults,d)};v.defaults={},h(v.prototype,{spin:function(e){this.stop();var t=this,n=t.opts,r=t.el=c(o(0,{className:n.className}),{position:n.position,width:0,zIndex:n.zIndex}),i=n.radius+n.length+n.width,u,a;e&&(e.insertBefore(r,e.firstChild||null),a=p(e),u=p(r),c(r,{left:(n.left=="auto"?a.x-u.x+(e.offsetWidth>>1):parseInt(n.left,10)+i)+"px",top:(n.top=="auto"?a.y-u.y+(e.offsetHeight>>1):parseInt(n.top,10)+i)+"px"})),r.setAttribute("aria-role","progressbar"),t.lines(r,t.opts);if(!s){var f=0,l=n.fps,h=l/n.speed,d=(1-n.opacity)/(h*n.trail/100),v=h/n.lines;(function m(){f++;for(var e=n.lines;e;e--){var i=Math.max(1-(f+e*v)%h*d,n.opacity);t.opacity(r,n.lines-e,i,n)}t.timeout=t.el&&setTimeout(m,~~(1e3/l))})()}return t},stop:function(){var e=this.el;return e&&(clearTimeout(this.timeout),e.parentNode&&e.parentNode.removeChild(e),this.el=n),this},lines:function(e,t){function i(e,r){return c(o(),{position:"absolute",width:t.length+t.width+"px",height:t.width+"px",background:e,boxShadow:r,transformOrigin:"left",transform:"rotate("+~~(360/t.lines*n+t.rotate)+"deg) translate("+t.radius+"px"+",0)",borderRadius:(t.corners*t.width>>1)+"px"})}var n=0,r;for(;n<t.lines;n++)r=c(o(),{position:"absolute",top:1+~(t.width/2)+"px",transform:t.hwaccel?"translate3d(0,0,0)":"",opacity:t.opacity,animation:s&&f(t.opacity,t.trail,n,t.lines)+" "+1/t.speed+"s linear infinite"}),t.shadow&&u(r,c(i("#000","0 0 4px #000"),{top:"2px"})),u(e,u(r,i(t.color,"0 0 1px rgba(0,0,0,.1)")));return e},opacity:function(e,t,n){t<e.childNodes.length&&(e.childNodes[t].style.opacity=n)}}),function(){function e(e,t){return o("<"+e+' xmlns="urn:schemas-microsoft.com:vml" class="spin-vml">',t)}var t=c(o("group"),{behavior:"url(#default#VML)"});!l(t,"transform")&&t.adj?(a.addRule(".spin-vml","behavior:url(#default#VML)"),v.prototype.lines=function(t,n){function s(){return c(e("group",{coordsize:i+" "+i,coordorigin:-r+" "+ -r}),{width:i,height:i})}function l(t,i,o){u(a,u(c(s(),{rotation:360/n.lines*t+"deg",left:~~i}),u(c(e("roundrect",{arcsize:n.corners}),{width:r,height:n.width,left:n.radius,top:-n.width>>1,filter:o}),e("fill",{color:n.color,opacity:n.opacity}),e("stroke",{opacity:0}))))}var r=n.length+n.width,i=2*r,o=-(n.width+n.length)*2+"px",a=c(s(),{position:"absolute",top:o,left:o}),f;if(n.shadow)for(f=1;f<=n.lines;f++)l(f,-2,"progid:DXImageTransform.Microsoft.Blur(pixelradius=2,makeshadow=1,shadowopacity=.3)");for(f=1;f<=n.lines;f++)l(f);return u(t,a)},v.prototype.opacity=function(e,t,n,r){var i=e.firstChild;r=r.shadow&&r.lines||0,i&&t+r<i.childNodes.length&&(i=i.childNodes[t+r],i=i&&i.firstChild,i=i&&i.firstChild,i&&(i.opacity=n))}):s=l(t,"animation")}(),typeof define=="function"&&define.amd?define(function(){return v}):e.Spinner=v}(window,document);



////////////////////////////////////////////////////////////////////
//from Table.js


var headerSuffix = "Header";
var bodySuffix   = "Body"; 
var selectRowColor = '#bfe0fe';
var deselectRowCOlor = '#F7F7F7';
var selectedRowColor = '#E0E0E0';

//=============================================================================

 function updateInnerHTML(id, replacement, divId) {  
   var elem = document.getElementById(id);  
   var replaceDiv = document.getElementById(divId);  
   var tag = elem.nodeName;
   var oldHTML = replaceDiv.innerHTML;  
   oldHTML = oldHTML.replace( /[\r\n\t]/g, '' );
   
   var re= new RegExp('<(\s*'+tag+'[^>]*id="?'+id +'"?[^>]*)>(.*?)(?:</table></'+tag+'[^>]*>|</'+tag+'[^>]*>)','i');  
   replacement="<$1>" + replacement + "</" + tag +">";  
  
   newHTML= oldHTML.replace(re,replacement);  
   replaceDiv.innerHTML = newHTML;  
}  

//=============================================================================

var MakeClass = function() {
	return function( args ) {
	    if( this instanceof arguments.callee ) {
	        if( typeof this.__construct == "function" ) 
				this.__construct.apply( this, args );
	    }
		else return new arguments.callee( arguments );
	};
}

var NewClass = function( variables, constructor, functions ) {
	var retn = MakeClass();
	for( var key in variables ) {
		retn.prototype[key] = variables[key];
	}
	for( var key in functions ) {
		retn.prototype[key] = functions[key];
	}
	retn.prototype.__construct = constructor;
	return retn;
}	

//=============================================================================

var CertTableForm = NewClass({
	"delegate": "null",
	"headerID": "null",
	"bodyID": "null",
	"selectMultiple":false
}, 
function(delegate, tableID, selectMultiple) {
	this.delegate = delegate;
	this.headerID = tableID + headerSuffix;
	this.bodyID = tableID + bodySuffix;
	this.selectMultiple = typeof selectMultiple !== 'undefined' ? 
		selectMultiple : false;
},
{
"CreateBody": function() {
	var formContent = "";
	formContent = '<div id="certFakeScrollContainer">';
	formContent += '<div id="certHeaderContainer">';
	formContent += '<table class="certTable" align="center" id=\"' + this.headerID + '\">';
	formContent += '<thead><tr></tr></thead></table>';
	formContent += '</div>';
	formContent += '<div id="scroll">';
	formContent += '<table class="certTable" id=\"' + this.bodyID + '\" align="center">';
	formContent += '<tbody></tbody></table>';
	formContent += '</div>';
	formContent += '</div>';
	
	return formContent;
},
"CreateHeader": function() {
	var s = document.getElementById(this.headerID).innerHTML; 
	s = s.replace(/[\r\n]/g,''); // remove \r and \n
	var tableEndRegExp = /(.*)(<\/thead>)/gi; 
	
	var row = "<tr>";
	for(var i = 0; i < arguments.length; i++) {
		row = row + "<td>" + arguments[i] + "</td>";
	}
	row = row + "</tr>"
	
	s = s.replace(tableEndRegExp, '$1' + row + '$2');
	updateInnerHTML(this.headerID, s, "certHeaderContainer");
},
"AddRow": function() {
	var s = document.getElementById(this.bodyID).innerHTML; 
	s = s.replace(/[\r\n]/g,''); // remove \r and \n
	var tableEndRegExp = /(.*)(<\/tbody>)/gi; 
	
	var row="<tr>";
	var substr = "";
	for(var i = 0; i < arguments.length; i++) {
		substr = arguments[i];
		if(substr.length > 15) {
			substr = substr.substr(0, 15) + '...';
		}
		row = row + "<td val=\'" + arguments[i] + "\'>" + substr + "</td>";
	}
	row = row + "</tr>"
	
	s = s.replace(tableEndRegExp, '$1' + row + '$2');
	updateInnerHTML(this.bodyID, s, "scroll");
	return false; 
},
"ClearRows": function() {
	var s = document.getElementById(this.bodyID).innerHTML; 
	s = s.replace(/[\r\n]/g,''); // remove \r and \n
	var tableEndRegExp = /(<tbody>)(.*)(<\/tbody>)/gi; 
	
	s = s.replace(tableEndRegExp, '$1'+'$3');
	updateInnerHTML(this.bodyID, s, "scroll");
	return false; 
},
"Initialized": function() {
	var root = window.addEventListener || window.attachEvent ? 
		window : document.addEventListener ? document : null;
	if (root) {
		if (root.addEventListener) this._initSort(false);
		else if (root.attachEvent) this._initSort();
	}
	
	configRows(this.bodyID, this.delegate, this.selectMultiple);
	this._prepareScroll();
},
"GetSelectedRows": function() {
	var table = document.getElementById(this.bodyID);
	var trs = table.getElementsByTagName('tr');
	var selectedRows = [];
	var i = 0;
	for(var j = 0; j < trs.length; j++) {
		if (trs[j].selected == true)
			selectedRows[i++] = trs[j];
	}
	return selectedRows;
},
"_prepareScroll": function() {
	var scrollablePanel = document.getElementById('scroll');
	var headerContainer = document.getElementById('certHeaderContainer');
	
	scrollablePanel.onscroll = function (e) {
		headerContainer.scrollLeft = scrollablePanel.scrollLeft;
	}
},
"_initSort": function(e) {
    if (!document.getElementsByTagName) return;

    for (var j = 0; (thead = document.getElementById(this.headerID).
		getElementsByTagName("thead").item(j)); j++) {
        var node;
        for (var i = 0; (node = thead.getElementsByTagName("td").item(i)); i++) {
            if (node.addEventListener) node.addEventListener("click", sort, false);
            else if (node.attachEvent) node.attachEvent("onclick", sort);
            node.title = "Нажмите на заголовок, чтобы отсортировать колонку";
        }
        thead.parentNode.up = 0;
        
        if (typeof(initial_sort_id) != "undefined"){
            td_for_event = thead.getElementsByTagName("td").item(initial_sort_id);
            if (document.createEvent){
                var evt = document.createEvent("MouseEvents");
                evt.initMouseEvent("click", false, false, window, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, td_for_event);
                td_for_event.dispatchEvent(evt);
            } else if (td_for_event.fireEvent) td_for_event.fireEvent("onclick");
            if (typeof(initial_sort_up) != "undefined" && initial_sort_up){
                if (td_for_event.dispatchEvent) td_for_event.dispatchEvent(evt);
                else if (td_for_event.fireEvent) td_for_event.fireEvent("onclick");
            }
        }
    }
}
});

//=============================================================================
 
 function configRows(tableID, delegate, selectMultiple) {
	var table = document.getElementById(tableID);
	var trs = table.getElementsByTagName('tr');
	for(var j = 0; j < trs.length; j++) {
		trs[j].selected = false;
		trs[j].onmouseover = function(){
			this.bgColor = selectRowColor;
			return false;};
		trs[j].onmouseout = function(){
		if (this.selected && selectMultiple)
			this.bgColor = selectedRowColor;
		else
			this.bgColor = deselectRowCOlor;
		return false;};
		trs[j].onclick = function(){
			if (selectMultiple) {
				if (!this.selected)
					this.bgColor = selectedRowColor;
				else
					this.bgColor = deselectRowCOlor;
				this.selected = !this.selected;
			}
			else
				delegate.OnRowClick(this);
			return false;
		};
	}
}

 function GetTablePrefix(row) {
	var pa = row.parentNode;
	while(pa.tagName.toLowerCase() != "table") {
		pa=pa.parentNode;
	}
	var regExp = /(.*)(Header)/;
	return pa.id.replace(regExp, '$1');
 }
 
//=============================================================================
 
 var img_dir = "./";
 var sort_case_sensitive = false;

 function _sort(a, b) {
     var a = a[0];
     var b = b[0];
     var _a = (a + '').replace(/,/, '.');
     var _b = (b + '').replace(/,/, '.');
     if (parseFloat(_a) && parseFloat(_b)) return sort_numbers(parseFloat(_a), parseFloat(_b));
     else if (!sort_case_sensitive) return sort_insensitive(a, b);
     else return sort_sensitive(a, b);
 }

 function sort_numbers(a, b) {
     return a - b;
 }

 function sort_insensitive(a, b) {
     var anew = a.toLowerCase();
     var bnew = b.toLowerCase();
     if (anew < bnew) return -1;
     if (anew > bnew) return 1;
     return 0;
 }

 function sort_sensitive(a, b) {
     if (a < b) return -1;
     if (a > b) return 1;
     return 0;
 }

 function getConcatenedTextContent(node) {
     var _result = "";
     if (node == null) {
         return _result;
     }

     var childrens = node.childNodes;
     var i = 0;
     while (i < childrens.length) {
         var child = childrens.item(i);
         switch (child.nodeType) {
             case 1: // ELEMENT_NODE
             case 5: // ENTITY_REFERENCE_NODE
                 _result += getConcatenedTextContent(child);
                 break;
             case 3: // TEXT_NODE
             case 2: // ATTRIBUTE_NODE
             case 4: // CDATA_SECTION_NODE
                 _result += child.nodeValue;
                 break;
             case 6: // ENTITY_NODE
             case 7: // PROCESSING_INSTRUCTION_NODE
             case 8: // COMMENT_NODE
             case 9: // DOCUMENT_NODE
             case 10: // DOCUMENT_TYPE_NODE
             case 11: // DOCUMENT_FRAGMENT_NODE
             case 12: // NOTATION_NODE
             // skip
             break;
         }
         i++;
     }
     return _result;
 }

 function sort(e) {
     var el = window.event ? window.event.srcElement : e.currentTarget;
     while (el.tagName.toLowerCase() != "td") el = el.parentNode;
     var a = new Array();
     var name = el.lastChild.nodeValue;
     var dad = el.parentNode;
     var table = dad.parentNode.parentNode;
     var up = table.up;
     var node, arrow, curcol;
     for (var i = 0; (node = dad.getElementsByTagName("td").item(i)); i++) {
         if (node.lastChild.nodeValue == name){
             curcol = i;
             if (node.className == "curcol"){
                 arrow = node.firstChild;
                 table.up = Number(!up);
             }else{
                 node.className = "curcol";
                 arrow = node.insertBefore(document.createElement("img"),node.firstChild);
                 table.up = 0;
             }
             arrow.src = img_dir + table.up + ".gif";
             arrow.alt = "";
         }else{
             if (node.className == "curcol"){
                 node.className = "";
                 if (node.firstChild) node.removeChild(node.firstChild);
             }
         }
     }
	 var tablePrefix = GetTablePrefix(el);
     var tbody = document.getElementById(tablePrefix + bodySuffix).getElementsByTagName("tbody").item(0);
     for (var i = 0; (node = tbody.getElementsByTagName("tr").item(i)); i++) {
         a[i] = new Array();
         a[i][0] = getConcatenedTextContent(node.getElementsByTagName("td").item(curcol));
         a[i][1] = getConcatenedTextContent(node.getElementsByTagName("td").item(1));
         a[i][2] = getConcatenedTextContent(node.getElementsByTagName("td").item(0));
         a[i][3] = node;
     }
     a.sort(_sort);
     if (table.up) a.reverse();
     for (var i = 0; i < a.length; i++) {
         tbody.appendChild(a[i][3]);
     }
} 



/////////////////////////////////////////////////////////////////////
//from Utils.js

//=============================================================================
	
var spinner;

//=============================================================================
	
function ShowSpinner(formID) {
	var opts = {
	  lines: 13, // The number of lines to draw
	  length: 7, // The length of each line
	  width: 4, // The line thickness
	  radius: 10, // The radius of the inner circle
	  corners: 1, // Corner roundness (0..1)
	  rotate: 0, // The rotation offset
	  color: '#000', // #rgb or #rrggbb
	  speed: 1, // Rounds per second
	  trail: 60, // Afterglow percentage
	  shadow: false, // Whether to render a shadow
	  hwaccel: false, // Whether to use hardware acceleration
	  className: 'spinner', // The CSS class to assign to the spinner
	  zIndex: 2e9, // The z-index (defaults to 2000000000)
	  top: 'auto', // Top position relative to parent in px
	  left: 'auto' // Left position relative to parent in px
	};
	var target = document.getElementById(formID);
	spinner = new Spinner(opts).spin(target);
}

//-----------------------------------------------------------------------------

function HideSpinner() {
	if(spinner != null) {
		spinner.stop();
		spinner = null;
	}
}

//=============================================================================
	
function showException(e) {
	if (e.description) {
		alert(e.description.replace("java.lang.Exception:",""));
	} else {
		alert(e);
	}
}

//=============================================================================


/////////////////////////////////////////////////////////////////////
//from GenPrivateKey.js

//=============================================================================
var GenPrivateKeyFormID = "GenPrivateKeyForm"; 

var ChooseKeysTypePanelID = "ChooseKeysTypePanel";
var UAPanelID = "UAKeysSpecPanel";
var RSAPanelID = "RSAKeysSpecPanel";
var CertRequestPanelID = "CertRequestPanel";

var UAKeysParamsPanelID = "UAKeysParamsPanel";
var InterKeysParamsPanelID = "InterKeysParamsPanel";
var SaveRequestsPanelID = "SaveRequestsPanel";

var NextButtonID = "NextButton";
var PrevButtonID = "PrevButton";
var CloseGenKeyButtonID = "CloseGenKeyButton";

var ChooseKeysUARadioBtnID = "ChooseKeysUARadioBtn";
var ChooseKeysRSARadioBtnID = "ChooseKeysRSARadioBtn";
var ChooseKeysUARSARadioBtnID = "ChooseKeysUARSARadioBtn";
var KeysTypeRadioBtnName = "KeysTypeRadioBtn";

var PrivKeyToBlobCheckBoxID = "PrivKeyToBlobCheckBox";
var PrivKeyToBlobPanelID = "PrivKeyToBlobPanel";
var PrivKeyBlobFileEditID = "PrivKeyBlobFileEdit";
var PrivKeyBlobFileButtonID = "PrivKeyBlobFileButton";
var PrivKeyBlobPasswordEditID = "PrivKeyBlobPasswordEdit";

var SelectAlgSuffixID = "SelectAlgSuffix";
var SelectDSAlgSuffixID = "SelectDSAlgSuffix";
var SelectKEPAlgID = "SelectKEPAlgSuffix";

var DSKeyAndKEPKeyID = "DSKeyAndKEPKey";

var ParamsFolderEditSuffixID = "ParamsFolderEditSuffix";
var ChangeFolderButtonSuffixID = "ChangeFolderSuffix";

var RequestPathID = "RequestPath";
var SaveRequestsButtonID = "SaveRequestsButton";
var ShowRequestsButtonID = "ShowRequestsButton";
//=============================================================================

var spinner;

var MakeClass = function() {
	return function( args ) {
	    if( this instanceof arguments.callee ) {
	        if( typeof this.__construct == "function" ) 
				this.__construct.apply( this, args );
	    }
		else return new arguments.callee( arguments );
	};
}

var NewClass = function( variables, constructor, functions ) {
	var retn = MakeClass();
	for( var key in variables ) {
		retn.prototype[key] = variables[key];
	}
	for( var key in functions ) {
		retn.prototype[key] = functions[key];
	}
	retn.prototype.__construct = constructor;
	return retn;
}	  

//=============================================================================

function ChangeSelectIndex(selectID, selectIndex) {
	document.getElementById(selectID).value = selectIndex;
}

//-----------------------------------------------------------------------------

function ChangeVisibility(visible, elementID) {
	var visibility;

	if(visible) {
		visibility = "visible";
	} else {
		visibility = "hidden";
	}
	
	document.getElementById(elementID).style.visibility = visibility;
}

//-----------------------------------------------------------------------------

function ChangeFile(editID, fileName) {
	var fileName = euSign.SelectFile(false, fileName);
		if(fileName == "")
			return;
	document.getElementById(editID).value = fileName;
}

//-----------------------------------------------------------------------------

function ChangeFolder(editID) {
	var folderName = euSign.SelectFolder();
		if(folderName == "")
			return;
	document.getElementById(editID).value = folderName;
}

//-----------------------------------------------------------------------------

function MakeSelect(selectID, selectWidth, items) {
	var content = '<select id=' + selectID + ' class="select" style="width:' + selectWidth +';">';
	
	for(var i = 0; i < items.length; i++)
		content += '<option value=' + i + ' >' + items[i] + '</option>';
	
	content += '</select>';
	return content;
}

//-----------------------------------------------------------------------------

function MakeChangeEdit(text, editID, editWidth, buttonID, onclick) {
	var content = '<tr><td colspan=2>' + text + '</td></tr>\
	   <tr>\
			<td align="left" class="text" style="padding:0px 0px 0px 0px"><input type="edit" id=' + editID + ' size="58" class="edit" style="width:'+ editWidth + ';"/></td>\
			<td align="left" class="text" style="padding:0px 0px 0px 0px"><input type="button" id=' + buttonID +
				' value="Змінити" class="button" style="width:60px; height:18px; margin:0px;" onclick=' + onclick  + ' /></td>\
	   </tr>';
	return content;
}

//=============================================================================

var EUGenPKForm = NewClass({
	"frameHeight": "0",
	"frameWidth": "0",
	"formHeight": "0",
	"formWidth": "0", 
	
	"onSelectOK": null,
	"onSelectFail": null,
	"onSelectCancel": null,
	
	"showIndex": 0,
	"showPanel": null,
	
	"requests": null,
	"KMSelected": false,
	
	"DOMElement": "",
	"dimmer": ""
}, 
function(frameHeight, frameWidth, formHeight, formWidth) {
	this.frameHeight = frameHeight;
	this.frameWidth  = frameWidth;
	this.formHeight  = formHeight;
	this.formWidth 	 = formWidth;
},
{
"ShowForm": function(onSelectOK, onSelectFail, onSelectCancel) {

	this.onSelectOK = onSelectOK;
	this.onSelectFail = onSelectFail;
	this.onSelectCancel = onSelectCancel;

	this.dimmer = document.getElementById('opaco');
	this.dimmer.style.display = "block"; 
	this.dimmer.style.height = document.body.clientHeight + 'px'; 
	
	this.DOMElement = this._constructForm();
	this.DOMElement.style.width = this.formWidth + 'px';
	this.DOMElement.style.minHeight = this.formHeight + 'px';
	this.DOMElement.style.left = Math.floor(document.body.clientWidth/2) - this.formWidth / 2 + 'px';
	this.DOMElement.style.zIndex = 12;
	document.body.appendChild(this.DOMElement);

	this._attachEvents();
	this.showPanel = document.getElementById(ChooseKeysTypePanelID);
	this._showPanel(0);
	this._privKeyToBlobCheckBoxClick();
	ChangeVisibility(false, SelectKEPAlgID);
	
	ChangeSelectIndex(UAPanelID + SelectDSAlgSuffixID, 1);
	ChangeSelectIndex(SelectKEPAlgID, 2);
	ChangeSelectIndex(RSAPanelID + SelectDSAlgSuffixID, 1);	
	
	return false;
},
"CloseForm": function() {
	
	this.DOMElement.parentNode.removeChild(this.DOMElement);
	document.getElementById('opaco').style.display = "none";
	
	return false;
},
"_attachEvents": function() {
	var thisForm = this;

	var PrivKeyToBlobCheckBox = document.getElementById(PrivKeyToBlobCheckBoxID);
	PrivKeyToBlobCheckBox.onclick = function(){thisForm._privKeyToBlobCheckBoxClick()};
	
	var PrivKeyBlobFileButton = document.getElementById(PrivKeyBlobFileButtonID);	
	PrivKeyBlobFileButton.onclick = function(){ChangeFile(PrivKeyBlobFileEditID, "Key.dat")};

	var NextButton = document.getElementById(NextButtonID);	
	NextButton.onclick = function(){thisForm._showNext();};
	
	var PrevButton = document.getElementById(PrevButtonID);	
	PrevButton.onclick = function(){thisForm._showPrev();};
	
	var CloseButton = document.getElementById(CloseGenKeyButtonID);
	CloseButton.onclick = function(){thisForm.CloseForm(); return false};
	
	var SaveRequestsButton = document.getElementById(SaveRequestsButtonID);
	SaveRequestsButton.onclick = function(){thisForm._saveRequests();};

	var ShowRequestsButton = document.getElementById(ShowRequestsButtonID);
	ShowRequestsButton.onclick = function(){thisForm._showRequests();};
},
"_constructForm": function () {
	var  container = document.createElement('div')
	
	var formContent = ""; 
	formContent+= '<div class="Form" id="' + GenPrivateKeyFormID + '">'; 
	formContent+= '<form name="genPrivKey" action="#" class="privKeyForm">'; 
	formContent+= '<div align="center"><h3 class="FormHeader">Генерація ключів</h3></div>'
	formContent+= '<table height=90% width=100% border="1" class="border" bordercolor="#C0C0C0">'; 
	formContent+= '<tr>';
	
	formContent += '<td style="padding: 0px 10px 10px 10px">' + 
							this._selectKeysTypesPanel() + 
							this._uaKeysPanel() + 
							this._rsaKeysPanel() + 
							this._certRequestPanel() + 
					'</td>';
	formContent+= '</tr>'; 
	formContent+= "</table>"; 

	formContent += '<div align="right" style="padding: 0px 10px 10px 0px"><input type="button" id = ' + PrevButtonID + ' value=\"Назад\" class="button" />';
	formContent += '<input type="button" id = ' + NextButtonID + ' value=\"Далі\" class="button" />';
	formContent += '<input type="button" id = ' + CloseGenKeyButtonID + ' value=\"Відміна\" class="button" /></div>';
	formContent+= "</form>"; 
	formContent+= "</div>"; 
	
	container.innerHTML = formContent;
	return container.firstChild;
}, 
"_selectKeysTypesPanel": function() {	
	var content = "";
	content = '<div id=' + ChooseKeysTypePanelID + ' style="display: none;" + class="GenKeyPanel">';
	
	content += 'Генерувати ключі: <br>';
	content += '<input type="radio" name=' + KeysTypeRadioBtnName + ' id=' + ChooseKeysUARadioBtnID + ' checked> для державних алгоритмів і протоколів<br>';
	content += '<input type="radio" name=' + KeysTypeRadioBtnName + ' id=' + ChooseKeysRSARadioBtnID + ' > для міжнародних алгоритмів і протоколів<br>';
	content += '<input type="radio" name=' + KeysTypeRadioBtnName + ' id=' + ChooseKeysUARSARadioBtnID + ' > для державних та міжнародних алгоритмів і протоколів<br><br>'
		
	content += '<input type="checkbox" id=' + PrivKeyToBlobCheckBoxID + ' />Зберегти особистий ключ до файлу<br><br>';
	
	content += 	'<div id=' +  PrivKeyToBlobPanelID + '>';	
	content += 	'<table border="0" align="left" cellpadding="0" cellspacing="0" width="100%">';
				
	content += MakeChangeEdit("Ім\'я файла для збереження особистого ключа", 
		PrivKeyBlobFileEditID, "340px", PrivKeyBlobFileButtonID);
	content += '<tr><td> Пароль доступу до особистого ключа: </td></tr>\
				<tr>\
					<td align="left" colspan=2><input type="password" id='+ PrivKeyBlobPasswordEditID + ' size="58" class="edit" style="width:340px;"/></td>\
				</tr>\
				</table>';
	content +=  '</div>';
	content +=  '</div>';
	content +=  '</div>';

	return content;
},
"_keysSelectPanel": function(panelID, addKEPCheckBox, algNames, keysTypesDS, keysTypesKEP) {
	var content = "";
	var index;
	
	content = 	'<table border="0" align="left" cellpadding="0" cellspacing="0" width="100%">\
				 <tr><td colspan=2 style="padding: 10px 0px">Тип криптографічних алгоритмів та протоколів:</td></tr>';
	
	content += '<tr><td colspan=2 style="padding: 0px 0px 10px">' + 
		MakeSelect(panelID + SelectAlgSuffixID, "80%", algNames) + '</td></tr>';
		
	if(addKEPCheckBox) {
		content += '<tr><td colspan=2 style="padding: 0px 0px 10px"><input type="checkbox" id=' + 
			DSKeyAndKEPKeyID + ' onclick="ChangeVisibility(this.checked,\'' +
			SelectKEPAlgID + '\')"/>Використовувати окремий ключ для протоколу розподілу<td></tr>';
	}	
	
	content += '<tr><td colspan=2>Параметри ключів:</td></tr>';
	content += '<tr>'
	content += '<td colspan=2 style="padding: 0px 0px 10px"><table border="0" align="left" cellpadding="0" cellspacing="0" width="100%">' 
	content += '<tr><td>' + MakeSelect(panelID + SelectDSAlgSuffixID, "200px", keysTypesDS) + '</td>';
	if(addKEPCheckBox)
		content += '<td>' + MakeSelect(SelectKEPAlgID, "200px", keysTypesKEP) + '</td>';
	else
		content += '<td></td>';
	content += '</tr>';
	content += '</td></table>';
	
	content += '</tr>';
	var changeText = "Місце розміщення параметрів:";
	var changeFolderFunc = 'ChangeFolder("' + panelID + ParamsFolderEditSuffixID + '")';
	content += MakeChangeEdit(changeText, 
		panelID + ParamsFolderEditSuffixID, "340px", panelID + ChangeFolderButtonSuffixID,
		changeFolderFunc);

	content += '</table>';
		
	return content;
},
"_uaKeysPanel": function() {	
	var algNames = ['ДСТУ 4145-2002 та Диффі-Гелман в гр. точок ЕК'];
	var dsKeys = ['мінімальна (191 біт)', 'базова (257 біт)', 'велика (307 біт)', 'з файлу параметрів'];
	var kepKeys = ['базова (257 біт)', 'велика (431 біт)', 'максимальна (571 біт)', 'з файлу параметрів'];
	
	var content = '<div id=' + UAPanelID + ' style="display: none;" + class="GenKeyPanel">';	
	content += this._keysSelectPanel(UAPanelID, true, algNames, dsKeys, kepKeys);
	content += '</div>';
	return content;
},
"_rsaKeysPanel": function() {	
	var algNames = ['RSA'];
	var dsKeys = ['мінімальна (1024 біта з SHA-1)', 
				  'базова (2048 біт з SHA-256)', 
				  'велика (3072 біта з SHA-256)',
				  'максимальна (4096 біт з SHA-256)',
				  'з файлу параметрів'];

	var content = '<div id=' + RSAPanelID + ' style="display: none;" + class="GenKeyPanel">';
	content += this._keysSelectPanel(RSAPanelID, false, algNames, dsKeys);
	content += '</div>';

	return content;
},
"_certRequestPanel": function() {	
	var content = "";
	content = '<div id=' + CertRequestPanelID + ' style="display: none;" + class="GenKeyPanel">';
	
	content += '<table border="0" align="left" cellpadding="0" cellspacing="0" width="100%">\
				<tr><td colspan=2 style="padding: 10px 0px">Запити на сертифікацію:</td></tr>';
	var changeText = "Місце розміщення запитів на сертифікацію:";
	var changeFolderFunc = 'ChangeFolder("' + RequestPathID + '")';
	content += MakeChangeEdit(changeText, RequestPathID, "340px", RequestPathID + "Button", changeFolderFunc);
	content += '<tr><td colspan=2 style="padding: 10px 0px" align="right">\
				<input type="button" id="' + ShowRequestsButtonID +'" value="Переглянути"\
						style="width:125px" class="button" />' +
			   '<input type="button" id="' + SaveRequestsButtonID + '" value="Зберегти"\
						style="width:125px" class="button" />' +
				'</td></tr>';
	content += "</table>";
	content += "</div>";	
	
	return content;
},
"_showPanel": function(index){
	var showFormID;
	var isFirst = false;
	var isLast = false;

	switch(index) {
		case 0: {
			showFormID = ChooseKeysTypePanelID;
			isFirst = true;
			break;
		}
		case 1: {
			showFormID = UAPanelID;
			break;
		}
		case 2: {
			showFormID = RSAPanelID;
			break;
		}
		case 3: {
			if(!this.KMSelected) 
			{
				if(!this._genPrivateKey(false))
					return;
			}
			this.KMSelected = false;
			isLast = true;
			showFormID = CertRequestPanelID;
			break;
		}
		case 4: {
			this.CloseForm();
			return;
			break;
		}
	}
	this.showPanel.style.display = 'none';
	this.showPanel = document.getElementById(showFormID);
	this.showIndex = index; 
	this.showPanel.style.display = 'block';
	
	if(isLast)
		document.getElementById(NextButtonID).value = "Завершити";
	else
		document.getElementById(NextButtonID).value = "Далі";
	
	var visibility = "visible";
	if(isFirst)
		visibility = "hidden";
		
	document.getElementById(PrevButtonID).style.visibility = visibility;
},
//-----------------------------------------------------------------------------
"_showNext": function () {
	var useUA = document.getElementById(ChooseKeysUARadioBtnID).checked;
	var useRSA = document.getElementById(ChooseKeysRSARadioBtnID).checked;

	var nextIndex;
	
	switch(this.showIndex) {
		case 0: {
			nextIndex = useUA ? 1 :
						useRSA ? 2 : 1;
			break;
		}
		case 1: {
			nextIndex = useUA ? 3 :
				useRSA ? 3 : 2;
			break;
		}
		case 2: {
			nextIndex = 3;
			break;
		}
		case 3: {
			nextIndex = 4;
			break;
		}
	}
	
	this._showPanel(nextIndex);
},
"_showPrev": function () {
	var useUA = document.getElementById(ChooseKeysUARadioBtnID).checked;
	var useRSA = document.getElementById(ChooseKeysRSARadioBtnID).checked;
	var useUARSA = document.getElementById(ChooseKeysUARSARadioBtnID).checked;
	
	var prevIndex;
	
	switch(this.showIndex) {
		case 0: {
			return;
		}
		case 1: {
			prevIndex = 0;
			break;
		}
		case 2: {
			prevIndex = useUARSA ? 1 : 0;
			break;
		}
		case 3: {
			prevIndex = useUARSA ? 2 : 
							useRSA ? 2 : 1;
			break;
		}
	}
	
	this._showPanel(prevIndex);
},
"_privKeyToBlobCheckBoxClick": function(){
	var visibility;

	if(document.getElementById(PrivKeyToBlobCheckBoxID).checked) {
		document.getElementById(PrivKeyBlobFileEditID).value = "";
		document.getElementById(PrivKeyBlobPasswordEditID).value = "";
		visibility = "visible";
	} else {
		visibility = "hidden";
	}
	
	document.getElementById(PrivKeyToBlobPanelID).style.visibility = visibility;
},
"_genPrivateKey": function(typeIndex, devIndex, password) {
	
	var thisForm = this;
		
	var selectDevice = !document.getElementById(PrivKeyToBlobCheckBoxID).checked;
	var getPrivKeyBlob = !thisForm.KMSelected && !selectDevice;
	var isIE6 = navigator.userAgent.indexOf("IE 6") != -1;
	if(!thisForm.KMSelected)
	{
		if(selectDevice) {
			var euReadPKForm = EUReadPKForm(frameHeight, frameWidth, 300, 330);
			if (isIE6)
				ChangeVisibility(false, GenPrivateKeyFormID); 
				
			euReadPKForm.GenerateKeyForm( 
				function(typeInd, devInd, pass, formatDevice) {
					if (isIE6)
						ChangeVisibility(true, GenPrivateKeyFormID);
					if (formatDevice)
						euSign.SetKeyMediaPassword(typeInd, devInd, pass);
					thisForm.KMSelected = true; 
					thisForm._genPrivateKey(typeInd, devInd, pass);
					thisForm.KMSelected = false;
					}, 
				function() {	
					if (isIE6)
						ChangeVisibility(true, GenPrivateKeyFormID);
					alert("Не обрано жодного пристрою");
					}, 
				function() {	
					if (isIE6)
						ChangeVisibility(true, GenPrivateKeyFormID);
					});
			return false;
		}
		else {
			typeIndex = 0;
			devIndex = 0;
			password = document.getElementById(PrivKeyBlobPasswordEditID).value;;
		}
	}
	else {
		selectDevice = false;
	}
	
	var useUA = document.getElementById(ChooseKeysUARadioBtnID).checked;
	var useRSA = document.getElementById(ChooseKeysRSARadioBtnID).checked;
	var useUARSA = document.getElementById(ChooseKeysUARSARadioBtnID).checked;
	
	useUA = useUA || useUARSA;
	useRSA = useRSA || useUARSA;
				
	var uaKeysType = useUA ? euSign.EU_KEYS_TYPE_DSTU_AND_ECDH_WITH_GOSTS : euSign.EU_KEYS_TYPE_NONE; 
	
	var uaDSKeysSpec = useUA ? (parseInt(document.getElementById(UAPanelID + SelectDSAlgSuffixID).value) + 1) : 0;
	var useDSKeyAsKEP = useUA ? !document.getElementById(DSKeyAndKEPKeyID).checked : false;
	var uaKEPSpec = (useUA && useDSKeyAsKEP) ? 0 : (parseInt(document.getElementById(SelectKEPAlgID).value)) + 1;
	var uaParamsPath = useUA ? document.getElementById(UAPanelID + ParamsFolderEditSuffixID).value : "";

	var internationalKeysType = useRSA ? euSign.EU_KEYS_TYPE_RSA_WITH_SHA : euSign.EU_KEYS_TYPE_NONE; 
	var internationalKeysSpec = useRSA ? (parseInt(document.getElementById(RSAPanelID + SelectDSAlgSuffixID).value) + 1) : 0;
	var internationalParamsPath = useRSA ? document.getElementById(RSAPanelID + ParamsFolderEditSuffixID).value : "";
	
	var keyInfo = null;
	var getPrivateKey = false;
	if(getPrivKeyBlob) {
		keyInfo = euSign.CreatePrivateKeyInfo();
		getPrivateKey = true;
	}
	
	ShowSpinner('GenPrivateKeyForm');
	try {
		requests = euSign.GeneratePrivateKeyEx(selectDevice,
			parseInt(typeIndex, 10), parseInt(devIndex, 10), password, uaKeysType, uaDSKeysSpec,
			useDSKeyAsKEP, uaKEPSpec, uaParamsPath, internationalKeysType,
			internationalKeysSpec, internationalParamsPath, keyInfo, getPrivateKey);
	} catch(e){
		requests = null;
		HideSpinner();
		showException(e);
		
		return false;
	}
	
	if(getPrivKeyBlob) {
		var privFileName = document.getElementById(PrivKeyBlobFileEditID).value; 
		try {
			euSign.WriteFile(privFileName, 
					keyInfo.GetPrivateKey()); 
		} catch(e) {
			showException(e);
		}
	}
	
	if(requests.size() != 0) {
		var filePath = requests.get(0).GetDefaultRequestFileName();
		var filename = filePath.replace(/^.*[\\\/]/, '');
		var path = filePath.replace(filename, '');
		document.getElementById(RequestPathID).value = path;
	}
	
	HideSpinner();
	
	if(this.KMSelected) {
		this._showPanel(3);
	}

	return true;
},
"_saveRequests": function() {
	if(requests == null)
		return;
		
	var folderForStoreRequests = document.getElementById(RequestPathID).value; 
	
	try {
		for(var i = 0; i < requests.size(); i++) {
			var request = requests.get(i);
			var filename = request.GetDefaultRequestFileName().replace(/^.*[\\\/]/, '');
			
			euSign.WriteFile(folderForStoreRequests + '\\' + filename, 
				request.GetRequest()); 
		}
	} catch(e) {
		showException(e);
		return;
	}
	alert("Усі запити на отримання сертифіката успішно збережено");
},
"_showRequests": function() {
	if(requests == null)
		return;
	
	try {
		for(var i = 0; i < requests.size(); i++) {
			showCRInfo(requests.get(i));
		}
	} catch(e) {
		showException(e);
		return;
	}
}
}

);



/////////////////////////////////////////////////////////////////////
//from InformationAlerts.js

	function showCertInfo(certInfo, detailed)  {
		var certInfoStr = "";
		
		if(certInfo != null && certInfo != "") {
			certInfoStr = "Реквізити видавця: " + certInfo.GetIssuer() + "\n" +
				"Ім'я видавця: " + certInfo.GetIssuerCN() + "\n" +
				"Серійний номер: " + certInfo.GetSerial() + "\n" +
				"Реквізити власника: " + certInfo.GetSubject() + "\n" +
				"Ім'я власника: " + certInfo.GetSubjCN() + "\n" +
				"Організація: " + certInfo.GetSubjOrg() + "\n" +
				"Підрозділ: " + certInfo.GetSubjOrgUnit() + "\n" +
				"Посада: " + certInfo.GetSubjTitle() + "\n" +
				"Область: " + certInfo.GetSubjState() + "\n" +
				"Місто: " + certInfo.GetSubjLocality() + "\n" +
				"Повне ім'я власника: " + certInfo.GetSubjFullName() + "\n" +
				"Адреса: " + certInfo.GetSubjAddress() + "\n" +
				"Телефон: " + certInfo.GetSubjPhone() + "\n" +
				"Електронна пошта: " + certInfo.GetSubjEMail() + "\n" +
				"Електронна адреса: " + certInfo.GetSubjDNS() + "\n" +
				"Код ЄДРПОУ: " + certInfo.GetSubjEDRPOUCode() + "\n" +
				"Код ДРФО: " + certInfo.GetSubjDRFOCode();
			
			if(detailed) { 
				certInfoStr +=	"Ідентифікатор НБУ: " + certInfo.GetSubjNBUCode() + "\n" +
					"Код СПФМ: " + certInfo.GetSubjSPFMCode() + "\n" +
					"Код організації: " + certInfo.GetSubjOCode() + "\n" +
					"Код підрозділу: " + certInfo.GetSubjOUCode() + "\n" +
					"Код користувача: " + certInfo.GetSubjUserCode() + "\n";
			
				certInfoStr += "Строк чинності сертифіката: " + "\n" +
					"Сертифікат чинний з: " + certInfo.GetCertBeginTime().toString() + "\n" +
					"Сертифікат чинний до: " + certInfo.GetCertEndTime().toString() + "\n";
			
				if(certInfo.IsPrivKeyTimesAvail()) {
					certInfoStr +=	"Строк дії особистого ключа: " + "\n" +
						"Час введення в дію ос. ключа: " + certInfo.GetPrivKeyBeginTime().toString() + "\n" +
						"Час виведення з дії ос. ключа: " + certInfo.GetPrivKeyEndTime().toString() + "\n";
				}	
				else {
					certInfoStr +=	"Строк дії особистого ключа: відсутній\n";
				}				
				
				certInfoStr += "Параметри відкритого ключа\n";
				if(certInfo.GetPublicKeyType() == euSign.CERT_KEY_TYPE_DSTU4145) {
					certInfoStr += "Тип ключа: ДСТУ 4145-2002\n";
					certInfoStr += "Довжина ключа: " + certInfo.GetPublicKeyBits() + " біт(а)\n";
					certInfoStr += "Відкритий ключ: " + certInfo.GetPublicKey();
				}
				else if(certInfo.GetPublicKeyType() == euSign.CERT_KEY_TYPE_RSA) {
					certInfoStr += "Тип ключа: RSA\n";
					certInfoStr += "Довжина ключа: " + certInfo.GetPublicKeyBits() + " біт(а)\n";
					certInfoStr += "Модуль: " + certInfo.GetRSAModul();
					certInfoStr += "Експонента: " + certInfo.GetRSAExponent();
				}
				else {
					certInfoStr += "Тип ключа: не визначено\n";
				}
				
				certInfoStr += "Ідентифікатор відкритого ключа ЕЦП: " + certInfo.GetPublicKeyID() + "\n";
				
				certInfoStr += "Використання ключів: " + certInfo.GetKeyUsage() + "\n" +
					"Уточнене призначення ключів: " + certInfo.GetExtKeyUsages() + "\n" +
					"Правила сертифікації: " + certInfo.GetPolicies() + "\n";

				if(certInfo.IsSubjTypeAvail()) {
					if(certInfo.IsSubjCA()) {
						certInfoStr += "Тип власника: ЦСК\n";
						certInfoStr += "Обмеження на довжину ланцюжка: " + certInfo.GetChainLength() + "\n";
					}
					else {
						certInfoStr += "Тип власника: Не ЦСК\n";
					}
				}
				else {
					certInfoStr += "Тип власника не визначений\n";
				}

				certInfoStr += "Інф. про точки доступу до СВС ЦСК: " + "\n" +
					"Точка доступу до повних СВС ЦСК: " + certInfo.GetCRLDistribPoint1() + "\n" +
					"Точка доступу до часткових СВС ЦСК: " + certInfo.GetCRLDistribPoint2() + "\n";

				if(certInfo.GetOCSPAccessInfo() != '' ||
					certInfo.GetIssuerAccessInfo() != '' ||
					certInfo.GetTSPAccessInfo() != '')	{
					
					if(certInfo.GetOCSPAccessInfo() != '')
						certInfoStr += "Точка доступу до OCSP-сервера: " + certInfo.GetOCSPAccessInfo() + "\n";
					
					if(certInfo.GetIssuerAccessInfo() != '')	
						certInfoStr += "Точка доступу до сертифікатів: " + certInfo.GetIssuerAccessInfo() + "\n";
						
					if(certInfo.GetTSPAccessInfo() != '')
						certInfoStr += "Точка доступу до TSP-сервера: " + certInfo.GetTSPAccessInfo() + "\n";
				}
				else {
					certInfoStr += "Інф. про точки доступу до серверів ЦСК відсутня\n";
				}
			  
				certInfoStr += "Ід. відкр. ключа ЕЦП ЦСК: " + certInfo.GetIssuerPublicKeyID() + "\n";
			
				if(certInfo.IsPowerCert()) {
					certInfoStr += "Сертифікат посилений\n";
				}
				
				if(certInfo.IsLimitValueAvail()) {
					certInfoStr += "Максимальне обмеження на транзакцію: " + 
						+ certInfo.GetLimitValue() + " " + certInfo.GetLimitValueCurrency();
				}
			}			
		}
		else {
			certInfoStr = "Інформація про сертифікат відсутня";
		}
		alert(certInfoStr);
	}
	
	function showSenderInfo(senderInfo) {
		var timeInfo;

		if(senderInfo.GetTimeInfo().IsTimeAvail())
			timeInfo = senderInfo.GetTimeInfo().GetTime();
		else
			timeInfo = "відсутні";

		alert("Реквізити видавця: " + senderInfo.GetOwnerInfo().GetIssuer() + "\n" + 
			"Ім'я видавця: " + senderInfo.GetOwnerInfo().GetIssuerCN() + "\n" + 
			"Серійний номер: " + senderInfo.GetOwnerInfo().GetSerial() + "\n" + 
			"Реквізити власника: " + senderInfo.GetOwnerInfo().GetSubject() + "\n" + 
			"Ім'я власника: " + senderInfo.GetOwnerInfo().GetSubjCN() + "\n" + 
			"Організація: " + senderInfo.GetOwnerInfo().GetSubjOrg() + "\n" + 
			"Підрозділ: " + senderInfo.GetOwnerInfo().GetSubjOrgUnit() + "\n" + 
			"Посада: " + senderInfo.GetOwnerInfo().GetSubjTitle() + "\n" +
			"Область: " + senderInfo.GetOwnerInfo().GetSubjState() + "\n" + 
			"Місто: " + senderInfo.GetOwnerInfo().GetSubjLocality() + "\n" + 
			"Повне ім'я власника: " + senderInfo.GetOwnerInfo().GetSubjFullName() + "\n" + 
			"Адреса: " + senderInfo.GetOwnerInfo().GetSubjAddress() + "\n" + 
			"Телефон: " + senderInfo.GetOwnerInfo().GetSubjPhone() + "\n" + 
			"Електронна пошта: " + senderInfo.GetOwnerInfo().GetSubjEMail() + "\n" + 
			"Електронна адреса: " + senderInfo.GetOwnerInfo().GetSubjDNS() + "\n" + 
			"Код ЄДРПОУ: " + senderInfo.GetOwnerInfo().GetSubjEDRPOUCode() + "\n" + 
			"Код ДРФО: " + senderInfo.GetOwnerInfo().GetSubjDRFOCode() + "\n" + 
			"Наявність часу підпису: " + senderInfo.GetTimeInfo().IsTimeAvail() + "\n" + 
			"Наявність позначки часу: " + senderInfo.GetTimeInfo().IsTimeStamp() + "\n" + 
			"Час підпису або позначка часу: " +  timeInfo.toString()); 
	}
	
	function showSignerInfo(signInfo) {
		var timeInfo;

		if(signInfo.GetTimeInfo().IsTimeAvail())
			timeInfo = signInfo.GetTimeInfo().GetTime();
		else
			timeInfo = "відсутні";

		alert("Реквізити видавця: " + signInfo.GetOwnerInfo().GetIssuer() + "\n" + 
			"Ім'я видавця: " + signInfo.GetOwnerInfo().GetIssuerCN() + "\n" + 
			"Серійний номер: " + signInfo.GetOwnerInfo().GetSerial() + "\n" + 
			"Реквізити власника: " + signInfo.GetOwnerInfo().GetSubject() + "\n" + 
			"Ім'я власника: " + signInfo.GetOwnerInfo().GetSubjCN() + "\n" + 
			"Організація: " + signInfo.GetOwnerInfo().GetSubjOrg() + "\n" + 
			"Підрозділ: " + signInfo.GetOwnerInfo().GetSubjOrgUnit() + "\n" + 
			"Посада: " + signInfo.GetOwnerInfo().GetSubjTitle() + "\n" +
			"Область: " + signInfo.GetOwnerInfo().GetSubjState() + "\n" + 
			"Місто: " + signInfo.GetOwnerInfo().GetSubjLocality() + "\n" + 
			"Повне ім'я власника: " + signInfo.GetOwnerInfo().GetSubjFullName() + "\n" + 
			"Адреса: " + signInfo.GetOwnerInfo().GetSubjAddress() + "\n" + 
			"Телефон: " + signInfo.GetOwnerInfo().GetSubjPhone() + "\n" + 
			"Електронна пошта: " + signInfo.GetOwnerInfo().GetSubjEMail() + "\n" + 
			"Електронна адреса: " + signInfo.GetOwnerInfo().GetSubjDNS() + "\n" + 
			"Код ЄДРПОУ: " + signInfo.GetOwnerInfo().GetSubjEDRPOUCode() + "\n" + 
			"Код ДРФО: " + signInfo.GetOwnerInfo().GetSubjDRFOCode() + "\n" + 
			"Наявність часу підпису: " + signInfo.GetTimeInfo().IsTimeAvail() + "\n" + 
			"Наявність позначки часу: " + signInfo.GetTimeInfo().IsTimeStamp() + "\n" + 
			"Час підпису або позначка часу: " +  timeInfo.toString()); 
	}
	
	function showCRLInfo(CRLInfo, detailed) {
	if (CRLInfo == null) {
		alert("Інформація про СВС відсутня");
		return;
	}
	var CRLInfoStr = "";
	CRLInfoStr = "ЦСК: " + CRLInfo.GetIssuerCN() + "\n" + 
				 "Реквізити ЦСК: " + CRLInfo.GetIssuer() + "\n" +
				 "Кількість СВС: " + CRLInfo.GetCRLNumber() + "\n" +
				 "Час формування: " + CRLInfo.GetThisUpdate().toString() + "\n" +
				 "Наступний: "+ CRLInfo.GetNextUpdate().toString() + "\n";
	
	if(detailed) {
		CRLInfoStr += "Ідентифікатор відкритого ключа ЦСК: " + CRLInfo.GetIssuerPublicKeyID() + "\n" + 					  
					  "Кількість відізваних сертифікатів: " + CRLInfo.GetRevokedItemsCount() + "\n";
	}
	alert(CRLInfoStr);
}



function showCRInfo(request)  {
	var crInfoStr = "";
	
	if(request != null && request != "") {
		
		if(request.isSelfSigned()) {
			crInfoStr = "Запит на сертифікат самопідписаний" + "\n";
		}
		else
		{
			crInfoStr = "Реквізити видавця: " + request.GetSignIssuer() + "\n" +
						"Серійний номер " + request.GetSignIssuer() + "\n";
		}
		
		var simple = request.IsSimple() || (request.GetSubject() == "");
		
		if(!simple) {
			crInfoStr +=	
				"Реквізити власника: " + request.GetSubject() + "\n" +
				"Ім'я власника: " + request.GetSubjCN() + "\n" +
				"Організація: " + request.GetSubjOrg() + "\n" +
				"Підрозділ: " + request.GetSubjOrgUnit() + "\n" +
				"Посада: " + request.GetSubjTitle() + "\n" +
				"Область: " + request.GetSubjState() + "\n" +
				"Місто: " + request.GetSubjLocality() + "\n" +
				"Повне ім'я власника: " + request.GetSubjFullName() + "\n" +
				"Адреса: " + request.GetSubjAddress() + "\n" +
				"Телефон: " + request.GetSubjPhone() + "\n" +
				"Електронна пошта: " + request.GetSubjEMail() + "\n" +
				"Електронна адреса: " + request.GetSubjDNS() + "\n" +
				"Код ЄДРПОУ: " + request.GetSubjEDRPOUCode() + "\n" +
				"Код ДРФО: " + request.GetSubjDRFOCode()+ "\n";
			
			crInfoStr +=	"Ідентифікатор НБУ: " + request.GetSubjNBUCode() + "\n" +
				"Код СПФМ: " + request.GetSubjSPFMCode() + "\n" +
				"Код організації: " + request.GetSubjOCode() + "\n" +
				"Код підрозділу: " + request.GetSubjOUCode() + "\n" +
				"Код користувача: " + request.GetSubjUserCode() + "\n";
		
			if(request.IsCertTimesAvail()) {
				crInfoStr += "Строк чинності сертифіката: " + "\n" +
					"Сертифікат чинний з: " + request.GetCertBeginTime().toString() + "\n" +
					"Сертифікат чинний до: " + request.GetCertEndTime().toString() + "\n";
			}
			else {
				crInfoStr +=	"Строк дії сертифіката: відсутній\n";
			}	
			
			if(request.IsPrivKeyTimesAvail()) {
				crInfoStr +=	"Строк дії особистого ключа: " + "\n" +
					"Час введення в дію ос. ключа: " + request.GetPrivKeyBeginTime().toString() + "\n" +
					"Час виведення з дії ос. ключа: " + request.GetPrivKeyEndTime().toString() + "\n";
			}	
			else {
				crInfoStr +=	"Строк дії особистого ключа: відсутній\n";
			}				
		}
		
		crInfoStr += "Параметри відкритого ключа\n";
		if(request.GetPublicKeyType() == euSign.CERT_KEY_TYPE_DSTU4145) {
			crInfoStr += "Тип ключа: ДСТУ 4145-2002\n";
			crInfoStr += "Довжина ключа: " + request.GetPublicKeyBits() + " біт(а)\n";
			crInfoStr += "Відкритий ключ: " + request.GetPublicKey();
		}
		else if(request.GetPublicKeyType() == euSign.CERT_KEY_TYPE_RSA) {
			crInfoStr += "Тип ключа: RSA\n";
			crInfoStr += "Довжина ключа: " + request.GetPublicKeyBits() + " біт(а)\n";
			crInfoStr += "Модуль: " + request.GetRSAModul() + "\n";
			crInfoStr += "Експонента: " + request.GetRSAExponent() + "\n";;
		}
		else {
			crInfoStr += "Тип ключа: не визначено\n";
		}
			
		crInfoStr += "Ідентифікатор відкритого ключа: " + request.GetPublicKeyID() + "\n";
		
		if(request.GetExtKeyUsages() == "") {
			crInfoStr += "Уточнене призначення ключів: відсутнє\n";
		} else {
			crInfoStr += "Уточнене призначення ключів: " + request.GetExtKeyUsages() + "\n";
		}
		
		if(request.IsSubjTypeAvail()) {
			var subjType = request.GetSubjType();
		
			switch(subjType){
				case euSign.SUBJECT_TYPE_CA: {
					crInfoStr += "Тип власника: ЦСК\n";
					break;
				}
				case euSign.SUBJECT_TYPE_CA_SERVER: {
					var subjSubType = request.GetSubjSubType();
					switch(subjSubType)
					{
						case euSign.SUBJECT_CA_SERVER_SUB_TYPE_CMP: {
							crInfoStr += "Тип власника: CMP-сервер ЦСК\n";
							break;
						}
						case euSign.SUBJECT_CA_SERVER_SUB_TYPE_TSP: {
							crInfoStr += "Тип власника: TSP-сервер ЦСК\n";
							break;
						}
						case euSign.SUBJECT_CA_SERVER_SUB_TYPE_OCSP: {
							crInfoStr += "Тип власника: OCSP-сервер ЦСК\n";
							break;
						}
						default:
							crInfoStr += "Тип власника: Не визначено\n";						
					}
					break;
				}
				case euSign.SUBJECT_TYPE_RA_ADMINISTRATOR: {
					crInfoStr += "Тип власника: адміністратор реєстрації\n";
					break;
				}
				case euSign.SUBJECT_TYPE_END_USER: {
					crInfoStr += "Тип власника: користувач ЦСК\n";
					break;
				}
				default:
					crInfoStr += "Тип власника: Не визначено\n";
			}
		}
		else {
			crInfoStr += "Тип власника відсутній\n";
		}

		if(!simple) {
			crInfoStr += "Інф. про точки доступу до СВС ЦСК: " + "\n" +
				"Точка доступу до повних СВС ЦСК: " + request.GetCRLDistribPoint1() + "\n" +
				"Точка доступу до часткових СВС ЦСК: " + request.GetCRLDistribPoint2() + "\n";
		}
	}
	else {
		crInfoStr = "Інформація про запит на сертифікат відсутня";
	}
	alert(crInfoStr);
}
