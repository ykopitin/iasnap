var e_mail;
var phone;
var completed_steps=0;
var timeoutHandle = "";



function regFormUtils_DefaultFileSettings() {
	try {
		var settings = euSign.CreateFileStoreSettings();
//	Каталог, в якому розміщуються сертифікати та списки відкликаних сертифікатів
		var tempdir = euSign.GetInstallPath();
		settings.SetPath(tempdir);
//	Признак необхідності використання списку відкликаних сертифікатів (СВС) при визначенні статусу сертифіката
		settings.SetCheckCRLs(true);
//	Встановити необхідність автоматично перечитувати файлове сховище сертифікатів, у якому також зберігатимуться списки відкликаних сертифікатів					
		settings.SetAutoRefresh(true);
//	Признак необхідності використання СВС тільки власного ЦСК користувача
		settings.SetOwnCRLsOnly(false);
//	Признак необхідності перевірки наявності двох діючих СВС – повного та часткового
		settings.SetFullAndDeltaCRLs(true);
		settings.SetAutoDownloadCRLs(false);
		settings.SetSaveLoadedCerts(true);
//	Час зберігання стану перевіреного сертифіката (у секундах) 
		settings.SetExpireTime(3600);				
//	Застосувати встановлені параметри та записати їх до реєстру
		euSign.SetFileStoreSettings(settings);

	} catch(e) {showException(e); alert("Помилка створення параметрів файлового сховища. "+euSign.GetLastError()); euSign.Finalize(); return;}
}


//	Підтримка кодування Base64 всіма браузерами через функцію hybrid_encode. Якщо доступна, буде використовуватись вбудована в браузер функція btoa,
//	якщо такої функції немає (IE), то використовується функція Base64.encode з файлу auth/base64ie.js
function hybrid_encode(txt) {
	if (typeof(btoa) === 'function') {
		return btoa(txt);
	} else {
		return Base64.encode(txt);
	}
}
function hybrid_decode(txt) {
	if (typeof(atob) === 'function') {
		return atob(txt);
	} else {
		return Base64.decode(txt);
	}
}


//	Функція authForm_SignIn викликається при натисканні на кнопку Увійти за ЕЦП, та забезпечує обмін інформацією з сервером,
//	проходження процедури підписання даних та відправки підписаних даних за допомогою форми auth-form
function authForm_SignIn() {
	var url_certs = YiiUrl("getcertificates");
	var url_string = YiiUrl("getstring");
//	FillDataToSign();
//	Скрипт sign/getstring очікує послідовність символів GenerateAuthString як запит на генерування рядку автентифікації
	$send = "GenerateAuthString";
//	Функція hybrid_encode(string):base64string призначена для кодування в Base64 у браузерах MSIE та у не MSIE (MSIE не має функції btoa, яка є в інших браузерах).
//	Функція перетворення Base64.Encode міститься у файлі base64ie.js, який підключається у шаблоні auth.xsl
	$send = hybrid_encode($send);
//	Підготовчі дії з ініціалізації криптографічного модулю
	var euSign = document.getElementById("euSign");
        try {
		var euisinit = euSign.IsInitialized();
		if (euisinit == true) {euSign.Finalize(); }
		euSign.SetCharset("UTF-16LE");
		euSign.SetUIMode(false);
		euSign.Initialize();
		euSign.width = "1px";
		euSign.SetUIMode(false);
	} catch(e) {
		if (confirm("Помилка при запуску Java-аплету. Можливо, Вам необхідно дозволити браузеру запуск Java. Чи бажаєти перейти на сторінку перевірки інсталяції Java?")) {
			window.open("http://www.java.com/ru/download/testjava.jsp");
		}
		return;
	}

//	Отримання комплекту сертифікатів основних центрів сертифікації та їх серверів
	jQuery.ajax({
	  type: 'GET',
	  url: url_certs,
	  dataType: 'json',
	  success: function(ret_data){
		$('.results').html(ret_data);
		for (var ii in ret_data)
		{
			try {
				var cf_str = ret_data[ii];
				$cert_file = euSign.BASE64Decode(cf_str);
//	Збереження файлу сертифікату до директорії
				euSign.WriteFile(euSign.GetInstallPath()+"\/"+ii, $cert_file);
			} catch(e) {
				alert("Помилка отримання комплекту сертифікатів. " +e.Message);
				euSign.Finalize();
				return;
			}
		}

		jQuery.ajax({
		  type: 'POST',
		  url: url_string,
		  data: {ask: $send}, //$send="GenerateAuthString"
		  dataType: 'json',

		  success: function(data){
		    $('.results').html(data);
//	data.randstr містить рядок автентифікації
			var Randstr = data.randstr;
			document.getElementsByName("AuthForm[Signature]")[0].value=data.randstr;
			try {
				try {
					{
						{
//	Встановлення параметрів файлового сховища за замовчуванням
							regFormUtils_DefaultFileSettings();
							var ProxySettings;
							try {
								ProxySettings = euSign.CreateProxySettings();
								ProxySettings = euSign.GetProxySettings();
								document.getElementById('ProxyUse').checked = ProxySettings.GetUseProxy();
								Use_Proxy_Check();
								if (ProxySettings.GetUseProxy()==true) {
									document.getElementById('ProxyName').value = ProxySettings.GetAddress();
									document.getElementById('ProxyPort').value = ProxySettings.GetPort();
									document.getElementById('ProxyAnonymous').checked = !ProxySettings.GetAnonymous();
									Use_Proxypas_Check();
									if (document.getElementById('ProxyAnonymous').checked){
										document.getElementById('ProxyUser').value = ProxySettings.GetUser();
										document.getElementById('ProxyPass').value = ProxySettings.GetPassword();
									}
								}
							} catch(e) { // Помилка при зчитуванні параметрів проксі-сервера. Зберігаємо пусті параметри
								try {
									ProxySettings = euSign.CreateProxySettings();
									euSign.SetProxySettings(ProxySettings);
								} catch(e) {
									showException(e); alert("Помилка при встановленні початкових параметрів. Перевірте, чи запущений програмний модуль Java. "+euSign.GetLastError()); euSign.Finalize(); return;
								}
							}
//	Спроба зчитування збережених параметрів файлового сховища
							try {
								var settings = euSign.CreateFileStoreSettings();
								settings = euSign.GetFileStoreSettings();
								document.getElementById('OwnCertPath').value = settings.GetPath();
							} catch(e) {
								showException(e); alert("Помилка створення параметрів файлового сховища. "+euSign.GetLastError()); euSign.Finalize();
								return;
							}
						}
					}
			
				} catch(e) {

					if (confirm("Помилка при запуску Java-аплету. Можливо, Вам необхідно дозволити браузеру запуск Java. Чи бажаєти перейти на сторінку перевірки Java?")) {
						window.location="http://www.java.com/ru/download/testjava.jsp";
					}
					return;
				}				
				
//	Початкові налаштування Java-модулю. Необхідно, оскільки користувач може здійснити авторизацію не з комп'ютера, на якому він здійснив реєстрацію (тому параметри можуть бути не встановлені).
//	Якщо на цьому комп'ютері був раніше налаштований інший програмний модуль з іншими параметрами, то вони можуть бути перезаписані новими

//	Встановлення(перезапис) параметрів сервера OCSP. У даному випадку використовуватиметься сервер OCSP Центрального засвідчувального органу
				var OCSPSettings = euSign.CreateOCSPSettings();
				OCSPSettings.SetUseOCSP(true);
//!false for debug purposes
				OCSPSettings.SetUseOCSP(false); //test value, must be commented in production
				OCSPSettings.SetBeforeStore(false);
//				OCSPSettings.SetAddress("czo.gov.ua/services/ocsp"); //disabled for debug purposes
				OCSPSettings.SetAddress("ca.iit.com.ua"); //test value, must be commented in production
				OCSPSettings.SetPort("80");
				euSign.SetOCSPSettings(OCSPSettings);

//	Створити порожній параметр LDAP
				var LDAPSettings = euSign.CreateLDAPSettings();
				euSign.SetLDAPSettings(LDAPSettings);

//	Створити порожній параметр налаштувань сервера міток часу. Цей параметр повинен бути визначений у наступних кроках налаштування
				var TSPSettings = euSign.CreateTSPSettings();
				euSign.SetTSPSettings(TSPSettings);
		
//	Створити порожній параметр. Цей параметр буде визначений у наступних кроках налаштування
				var CMPSettings = euSign.CreateCMPSettings();
				euSign.SetCMPSettings(CMPSettings);

				var ModeSettings = euSign.CreateModeSettings();
//	Mode offline = false - функціонувати з використанням мережі Інтернет (завантажувати сертифікати, перевіряти мітки часу, завантажувати СВС тощо
				ModeSettings.SetOfflineMode(false);
				euSign.SetModeSettings(ModeSettings);
			
			} catch(e) {
				if (confirm("Помилка при запуску Java-аплету. Можливо, Вам необхідно дозволити браузеру запуск Java. Чи бажаєти перейти на сторінку перевірки інсталяції Java?")) {
					window.location="http://www.java.com/ru/download/testjava.jsp";
				}
				return;
			}
//	Відображення форми вибору носія з закритим ключем
			var frameHeight = 450;
			var frameWidth = 800;
			var euReadPKForm = EUReadPKForm(frameHeight, frameWidth, 300, 330);
			euReadPKForm.ShowForm( 
//	Тут розміщена функція, яка виконується у разі успішного вибору носія закритого ключа			
				function(deviceType, deviceName, password) {
					try {
//	Вибір сертифікату CMP-сервера з комплекту завантажених сертифікатів, що підходить до зчитуваного закритого ключа
						var CMPCertCount = euSign.GetCMPServerCertificatesCount();
						if (CMPCertCount <= 0) {
							alert("Не знайдено жодного сертифікату");
							return;
						}
						for (var i = 0; i < CMPCertCount; i++) {
						    try{
							var cert_info1 = euSign.EnumCMPServerCertificatesCount(i);
							var cert_info2 = euSign.GetCertificateInfoEx(cert_info1.GetIssuer(), cert_info1.GetSerial());
							var CMPSettings = euSign.GetCMPSettings();
							CMPSettings.SetUseCMP(true);
							CMPSettings.SetAddress(cert_info1.GetSubjDNS());
							CMPSettings.SetPort("80");
							euSign.SetCMPSettings(CMPSettings);

							euSign.ResetOperation();
							euSign.ResetPrivateKey();
							euSign.ReadPrivateKeySilently(parseInt(deviceType, 10), parseInt(deviceName, 10), password); 
						    } catch(e) {
//	Todo: Додати перевірку коду помилки. Якщо код не дорівнює помилці зчитування закритого ключа - тоді вихід з функції
//							alert("next cmp");
						    }
						}
//alert("0:0 key readed");
						try {
//	Спроба встановити налаштування TSP-сервера з сертифіката користувача
//	Отримання інформації про власника закритого ключа, який зчитаний
							var ownerInfo = euSign.GetPrivateKeyOwnerInfo();
//	Отримання розширеної інформації про сертифікат власника закритого ключа на основі інформації про Видавця сертифікату та його Серійного номеру
							var CertInfoEx = euSign.GetCertificateInfoEx(ownerInfo.GetIssuer(), ownerInfo.GetSerial());
//	Отримання інформації про адресу розміщення сервера позначок часу (TimeStamp) з сертифіката користувача
							var CertInfoTSP = CertInfoEx.GetTSPAccessInfo();
//	Отримання інформації про поточні налаштування сервера TSP
							var tsp = euSign.CreateTSPSettings();
							tsp = euSign.GetTSPSettings();
//	Отримання інформації про кількість сертифікатів серверів TSP у файловому сховищі.
//	?? Сертифікат TSP-сервера повинен зчитуватись з сервера ЦЗО в момент імпорту власного сертифіката користувача після функції CheckCertificate
//	На даний момент сертифікат TSP-сервера повинен зчитуватись з web-порталу через ajax за адресою sign/getcertificates
							var tspServers = euSign.GetTSPServerCertificatesCount();
//alert("0:1 before tsp");
							if (tspServers >=1)
							{
//	Встановити обов'язковість наявності позначки часу у підписі користувача
								tsp.SetGetStamps(true);
//	Встановлення адреси TSP-сервера з сертифіката користувача (функція GetTSPAccessInfo, яка витягує інформацію про TSP з сертифікату, не містить порту сервера)
								tsp.SetAddress(CertInfoTSP);
//	Todo: необхідно перевірити, чи всі сертифікати мають TSP-сервер з портом 80
								if (CertInfoTSP.indexOf("http://") == 0)
									tsp.SetPort("80");
								else
									tsp.SetPort("80"); // Невідомо, чи є 80 порт стандартним для цього
								try {
//	Збереження встановлений параметрів TSP-сервера
									euSign.SetTSPSettings(tsp);
								} catch(e) { 
//	У випадку збою встановлення параметрів - зтерти зчитаний закритий ключ та завершити роботу Java-модулю
									euSign.ResetPrivateKey();
									euSign.Finalize();
									showException(e);
									alert("Не встановлені параметри TSP-сервера. Перевірте наявність сертифіката TSP-сервера у файловому сховищі");
									return;
								}
							} else {
//	Якщо в сховищі нема жодного сертифіката TSP-сервера. Це може статися, коли на сервері ЦЗО немає інформації про TSP-сервер видавця сертифіката, але це є проблемою конкретного видавця сертифікатів
//	або коли не вдалося підключитись до сервера ЦЗО для отримання інформації про імпортований сертифікат користувача
								euSign.ResetPrivateKey();
								euSign.Finalize();
								alert("Перевірте наявність сертифіката TSP-сервера у файловому сховищі, а також параметри доступу до мережі Інтернет");
								return;
							}
						} catch(e) {showException(e+" " + euSign.GetLastError()+" " + euSign.GetLastErrorCode());
							euSign.ResetPrivateKey();
							euSign.Finalize();
							alert("Виникла помилка при встановлені параметрів сервера міток часу");
							return;
						}
						
//	Здійснення підписання рядку автентифікації (попередньо збереженого у елемент document.getElementsByName("Signature")[0])
//	Signature містить рядок, який був згенерований скриптом sign/getstring
//						Randstr = document.getElementById("SignRandstr").value;
						var Signature = document.getElementsByName("AuthForm[Signature]")[0].value;
						document.getElementsByName("AuthForm[Signature]")[0].value = euSign.SignInternal("true", Signature);
//						post('/index.php?r=sign/login', {Signature2: "1234"});
						authForm_SetProxy();
						euSign.ResetPrivateKey();
						euSign.Finalize();
						document.forms["AuthForm"].submit();
//						return true;
					} catch(e)  {
						if (euSign.GetLastErrorCode() == 65)	//EU_ERROR_GET_TIME_STAMP
						{
							alert("Виникла помилка при отриманні позначки часу. Перевірте з'єднання з мережею Інтернет (параметри проксі-сервера) а також чинність сертифікату");
							euSign.Finalize(); euSign.Initialize();
							return;
						}
						if (euSign.GetLastErrorCode() == 18)	//EU_ERROR_KEY_MEDIAS_ACCESS_FAILED
						{
							alert("Виникла помилка при введенні паролю доступу до носія. Будь-ласка, введіть правильний пароль доступу");
							euSign.Finalize(); euSign.Initialize();
							return;
						}
						if (euSign.GetLastErrorCode() == 19)	//EU_ERROR_KEY_MEDIAS_READ_FAILED
						{
							alert("Виникла помилка при зчитуванні ключа на носії. Будь-ласка, підключить до комп'ютера та оберіть потрібний носій з меню зчитування ключа");
							euSign.Finalize(); euSign.Initialize();
							return;
						}
						if (euSign.GetLastErrorCode() == 24)	//EU_ERROR_BAD_PRIVATE_KEY
						{
							alert("Виникла помилка при зчитуванні ключа на носії. Ключ пошкоджений або має невідомий формат");
							euSign.Finalize(); euSign.Initialize();
							return;
						}
						if (euSign.GetLastErrorCode() == 51)	//EU_ERROR_BAD_PRIVATE_KEY
						{
							alert("Не знайдений сертифікат користувача. Додайте свій сертифікат до сховища");
							euSign.Finalize(); euSign.Initialize();
							showStep(2);
							return;
						}
						alert("Помилка при створенні підпису. Код помилки:" + euSign.GetLastErrorCode(+"("+euSign.GetLastError+")"));
					}
				},
//	Тут може бути функція, яка виконується у разі невдалої спроби зчитування ключа з носія (необхідно уточнити)
				null,
//	Тут може бути функція, яка виконується у разі відміни зчитування ключа (необхідно уточнити)
				null, 
//	Текст заголовка форми зчитування ключа
				"Оберіть ключовий носій");
		  },
//	Функція, яка виконується, якщо підготовчий обмін даними з сервером не завершився успішно
		  error: function(data){alert("Неможливо здійснити обмін даними з веб-порталом");}
	})

				  },
				  error: function(){alert("Помилка отримання комплекту сертифікатів."); return;}
				});
//	return false - т.к. Submit должен происходить исключительно через JS
	return false;
}



//	Функції динамічного показу елементів налаштування проксі-сервера
function show_element(type,status)
{param=document.getElementById(type);
if(status==1)
param.style.display = "block";
else
param.style.display = "none";
}

function Use_Proxy_Check(){
    // Пишем на jQuery
    if($('#ProxyUse').is(':checked')) {
        $('#proxy-settings').slideDown();
    } else {
        $('#proxy-settings').slideUp();
    }
}

function Use_Proxypas_Check(){
    if($('#ProxyAnonymous').is(':checked')) {
        $('#proxy-auth').slideDown();
    } else {
        $('#proxy-auth').slideUp();
    }
}


//	Запуск переходу на іншу вкладку по натисканню на вкладку
	$("li.step").click(function(){
		showStep(this.id.substr(this.id.length - 1));
		});


//	Показує елементи вказаної вкладки авторизації
//	Використовуються ID елементів типу li
function showStep(goStepNumber) {

	var curStep = $(".step.active").attr('id');
	var curStepNumber = curStep.substr(curStep.length - 1);
	
	if (curStepNumber == 1) {	// Якщо перехід виконується з першой вкладки (вхід), то ініціалізувати Java-модуль для інших вкладок
		try {
			var euisinit = euSign.IsInitialized();
			if (euisinit == false) {
				euSign.SetCharset("UTF-16LE");
				euSign.SetUIMode(false);
				euSign.Initialize();
				euSign.width = "1px";
				euSign.SetUIMode(false);
				euisinit = euSign.IsInitialized();
			}
			if (euSign.DoesNeedSetSettings() == true)
			{
				if(confirm("Параметри модулю ЕЦП не встановлені. Чи бажаєте встановити параметри за замовчуванням"))
				{
// Якщо в реєстрі немає необхідного розділу, то встановлюються параметри за замовчуванням
//	Встановлення параметрів файлового сховища за замовчуванням
					regFormUtils_DefaultFileSettings();

//	Встановлення(перезапис) параметрів сервера OCSP. У даному випадку використовуватиметься сервер OCSP Центрального засвідчувального органу
					var OCSPSettings = euSign.CreateOCSPSettings();
					OCSPSettings.SetUseOCSP(true);
					OCSPSettings.SetBeforeStore(false);
					OCSPSettings.SetAddress("czo.gov.ua/services/ocsp");
					OCSPSettings.SetPort("80");
					euSign.SetOCSPSettings(OCSPSettings);

//	Створити порожній параметр
					var LDAPSettings = euSign.CreateLDAPSettings();
					euSign.SetLDAPSettings(LDAPSettings);

//	Створити порожній параметр налаштувань сервера міток часу. Цей параметр повинен бути визначений у наступних кроках налаштування
					var TSPSettings = euSign.CreateTSPSettings();
					euSign.SetTSPSettings(TSPSettings);
		
//	Створити порожній параметр. Цей параметр може бути визначений у наступних кроках налаштування
					var CMPSettings = euSign.CreateCMPSettings();
					euSign.SetCMPSettings(CMPSettings);
					var ProxySettings;
					try {
						ProxySettings = euSign.CreateProxySettings();
						ProxySettings = euSign.GetProxySettings();
						document.getElementById('ProxyUse').checked = ProxySettings.GetUseProxy();
						Use_Proxy_Check();
						if (ProxySettings.GetUseProxy()==true) {
							document.getElementById('ProxyName').value = ProxySettings.GetAddress();
							document.getElementById('ProxyPort').value = ProxySettings.GetPort();
							document.getElementById('ProxyAnonymous').checked = !ProxySettings.GetAnonymous();
							Use_Proxypas_Check();
//				if (!ProxySettings.GetAnonymous()) {
							if (document.getElementById('ProxyAnonymous').checked){
								document.getElementById('ProxyUser').value = ProxySettings.GetUser();
								document.getElementById('ProxyPass').value = ProxySettings.GetPassword();
							}
						}
//Цей параметр не функціонує належним чином, тому відключений (todo: перевірити вплив на функціонування)
//					document.getElementById('ProxySavePass').checked = ProxySettings.GetSavePassword();
					} catch(e) { // Помилка при зчитуванні параметрів проксі-сервера. Зберігаємо пусті параметри
						try {
							ProxySettings = euSign.CreateProxySettings();
							euSign.SetProxySettings(ProxySettings);
						} catch(e) {
							showException(e); alert("Помилка при встановленні початкових параметрів. Перевірте, чи запущений програмний модуль Java. "+euSign.GetLastError()); return;
						}
					}
//	Спроба зчитування збережених параметрів файлового сховища
					try {
						var settings = euSign.CreateFileStoreSettings();
						settings = euSign.GetFileStoreSettings();
						document.getElementById('OwnCertPath').value = settings.GetPath();
//	Додати перевірку на можливість запису нових файлів, якщо немає сертифікатів користувачів
					} catch(e) {
						try {
							regFormUtils_DefaultFileSettings();
							var settings1 = euSign.CreateFileStoreSettings();
							settings1 = euSign.GetFileStoreSettings();
							document.getElementById('OwnCertPath').value = settings1.GetPath();
						} catch(e) {showException(e); alert("Помилка створення параметрів файлового сховища. Оберіть іншу директорію для збереження сертифікатів. "+euSign.GetLastError()); euSign.Finalize(); return;}
					}
				}
			}
			
		} catch(e) {

			if (confirm("Помилка при запуску Java-аплету. Можливо, Вам необхідно дозволити браузеру запуск Java. Чи бажаєти перейти на сторінку перевірки Java?")) {
				window.location="http://www.java.com/ru/download/testjava.jsp";
			}
			return;
		}
	}
	
	if (curStepNumber == 3) {	// Якщо перехід здійснюється з вкладки налаштувань проксі-сервера - то зберегти налаштування, введені користувачем перед переходом
		authForm_SetProxy();
	}
	
//	Скрити поточну вкладку та показати вкладку, на яку необхідно перейти
	$(".services-page.tabs-block").hide();
	$("#tbStep0"+goStepNumber).show();
	$("#Step0"+goStepNumber).parent().children("li.step").removeClass("active");
	$("#Step0"+goStepNumber).addClass("active");
			
	
	if (goStepNumber == 2){	// При переході на вкладку налаштувань сертифікатів та файлового сховища перевірити всі сертифікати, які знаходяться у ньому. Це може зайняти деякий час
		GenCertTable();
		if (euSign.GetEndUserCertificatesCount() <= 0)
			document.getElementById('btnImportOwnCertificate').focus();
	}
		
	if (goStepNumber == 3){	//	При переході на вкладку налаштувань проксі-сервера заповнити всі поля поточними налаштуваннями
		authForm_GetProxy();
	}
}
	
function showException(e) {
	if (e.description) {
		alert(e.description.replace("java.lang.Exception:",""));
	} else {
		alert(e);
	}
}		


//	Допоміжна функція створення заголовку таблиці сертифікатів
function startOwnCertTableInnerHTML() {
	var content = '<table id="OwnCertTable" class="table table-bordered">';
	content += '<tr><th>Прізвище, ім\'я, по батькові</th>';
	content += '<th>Найменування центра сертифікації ключів</th>';
	content += '<th>Серійний номер</th>';
	content += '<th>Чинність</th></tr>';
	return content;
}

//	Допоміжна функція завершення таблиці сертифікатів
function endOwnCertTableInnerHTML(content) {
	content += '</table>';
	return content;
}

//	Допоміжна функція будування таблиці сертифікатів файлового сховища (додавання нового рядку до таблиці у варіанті, який функціонує як на MSIE так і на інших браузерах)
function add4RowOwnCertTableInnerHTML(content, c1, c2, c3, c4, c4color) {
	content += '<tr><td>' + c1 + '</td>';
	content += '<td>' + c2 + '</td>';
	content += '<td>' + c3 + '</td>';
	content += '<td style="background-color: ' + c4color + '">' + c4 + '</td></tr>';
	return content;
}

//	Функція, яка виводить інформацію про відсутність сертифікатів у сховищі
function emptyOwnCertTableInnerHTML() {
	var content = '<table id="OwnCertTable" class="table table-bordered">';
	content += '<tr><td><div style="font-size: 17px; color: red">Немає сертифікатів. Вам необхідно імпортувати свій сертифікат з файлу</div></td></tr></table>';
	return content;
}

//	Функція наповнення таблиці про сертифікати користувачів у файловому сховищі
function GenCertTable()
{
	if (euSign.IsInitialized() == false)
		euSign.Initialize();
	try {
		if (euSign.GetEndUserCertificatesCount() <= 0) {	// Немає сертифікатів користувача
			document.getElementById('divOwnCertTable').innerHTML = emptyOwnCertTableInnerHTML();
			document.getElementById('btnImportOwnCertificate').focus();
		} else {
			var table = startOwnCertTableInnerHTML();
			for(var i=0;i<euSign.GetEndUserCertificatesCount();i++)
			{
				var certInfo = euSign.EnumEndUserCertificatesCount(i);
				var td1=certInfo.GetSubjCN();	// ПІБ користувача
				var td2=certInfo.GetIssuerCN();	// Найменування ЦСК
				var td3=certInfo.GetSerial();	// Серійний номер
				var td4="";						// Комірка таблиці для інформації про чинність сертифікату
				var td4col="";					// Колір комірки таблиці про чинність (зелений - чинний, жовний - проблеми)
		
				try {
//	Отримання розширеной інформації про сертифікат для здійснення його перевірки на сервері ЦЗО
					var certInfoEx = euSign.GetCertificateInfoEx(certInfo.GetIssuer(), certInfo.GetSerial());
					var certDate = certInfoEx.GetCertEndTime();
//	CertDate - для відображення строку чинності сертифіката
					certDate = certDate.toLocaleString();
					delete certInfoEx;
					var certBytes = euSign.GetCertificate(certInfo.GetIssuer(), certInfo.GetSerial());
					try {
//	Функція перевірки статусу сертифіката. Якщо є проблеми, то перехід до гілки catch, функція euSign.GetLastError() повертає опис помилки, euSign.GetLastErrorCode() - код помилки
						euSign.CheckCertificate(certBytes);
						delete certBytes;
						var errorCode = euSign.GetLastErrorCode();
						if (errorCode == "0") //сертифікат чинний
						{
							td4 = certDate;
							td4col = "#A2D507";
						}
					} catch(e) {
						if (euSign.GetLastErrorCode() == "51") //Сертифікат не знайдено
						{
							td4 = "Не визначено";
						}
						if (euSign.GetLastErrorCode() == "8")	//EU_ERROR_PROXY_NOT_AUTHORIZED
						{
							alert("Вам необхідно ввести логін та пароль до проксі-сервера");
							showStep(3);
							return;
						}
						td4col = "#D5A207";
					}
				} catch(e) {
					showException(e); alert("Виникли проблеми перевірки статусу сертифікатів у файловому сховищі. "+euSign.GetLastError()); euSign.Finalize(); euSign.Initialize(); return;
				}
		
//	Додавання до таблиці рядку з черговим перевіреним сертифікатом
				table = add4RowOwnCertTableInnerHTML(table, td1, td2, td3, td4, td4col);
			}
			document.getElementById('divOwnCertTable').innerHTML = endOwnCertTableInnerHTML(table);
			euSign.Finalize();
			euSign.Initialize();
		}
	} catch(e) {
		if (euSign.GetLastErrorCode() == 49)
		{
			if(confirm("Параметри файлового сховища не встановлені або не вірні. Чи бажаєте встановити стандартні параметри за замовчуванням?"))
			{
				regFormUtils_DefaultFileSettings();
				alert("Перезавантажте сторінку");
			}
			else return;
		}
		alert("Помилка при створенні переліку сертифікатів користувачів. Код помилки: "+euSign.GetLastErrorCode());
	}
}

//	Функція імпорту сертифіката користувача
function importOwnCertificate() {
		try {
			var errorCode;
			var error;
//	Вибір файлу через інтерфейс Java-модулю. Є проблеми з директоріями з кирилічними символами
			var fileName = euSign.SelectFile(true, "");
			if(fileName == "")
				return;
			var certData = euSign.ReadFile(fileName);
//	Перевірити обраний файл як сертифікат. Якщо сертифікат пошкоджений або перевірити його не вдалось - він не імпортується до сховища.
//	Це є мірою обережності, щоб користувач не використовував хибні сертифікати
			euSign.CheckCertificate(certData);
			errorCode = euSign.GetLastErrorCode();
			if (errorCode == "0")
			{
//	Зберегти обраний файл як файл сертифікату у файлове сховище з іменем, яке співпадає з серійним номером сертифіката
				euSign.SaveCertificate(certData);
//	Відновити таблицю сертифікатів
				GenCertTable();
				document.getElementById('btnStep02').focus();
			}
		} catch(e) {
			errorCode = euSign.GetLastErrorCode();
			error = euSign.GetLastError(); 
			if (errorCode == "51") {
				alert("Сертифікат не вдалось перевірити, не вдалось здійснити підключення до сервера ЦЗО або сертифікат не є чинним. Перевірте параметри доступу до мережі Інтернет");
			} if (errorCode =="33") {
				alert("Обраний файл не має невідомий формат (або не є сертифікатом)");
			} else
				alert("Помилка при імпорті власного сертифікату користувача. Код помилки: "+errorCode);
		}

}

//	Функція збереження шляху до файлового сховища сертифікатів
function authForm_SetPath() {
try {
  var newPath = "";
  newPath = euSign.SelectFolder();
  if (newPath != "") {
		document.getElementById('OwnCertPath').value = newPath;


//	Перевірити, чи встановлений каталог файлового сховища сертифікатів
	try {
		var oldFilePath; var newFilePath = document.getElementById('OwnCertPath').value;
		var FileSettings = euSign.CreateFileStoreSettings();
		FileSettings = euSign.GetFileStoreSettings();
		
		if (FileSettings.GetPath() != "") {
			if (FileSettings.GetPath() != oldFilePath) {
				oldFilePath = FileSettings.GetPath();
				FileSettings.SetPath(newFilePath);
				euSign.CreateFolder(newFilePath);
			
//	Створити тестовий масив для перевірки можливості запису сертифікатів до файлового сховища
				var r3_02 = [1,2];
				r3_02[0] = 48; r3_02[1] = 49;
//	Спроба створення файлу у сховищі
				try {
					euSign.WriteFile(FileSettings.GetPath() + "\\delete.me", r3_02);
					euSign.SetFileStoreSettings(FileSettings);
//					console.log("Каталог з сертифікатами налаштован вірно");
				} catch(e) {
					try {
//	Новий файлових шлях недійсний, спробувати запис з використанням старого файлового шляху
						FileSettings.SetPath(oldFilePath);
						euSign.WriteFile(FileSettings.GetPath() + "\\delete.me", r3_02);
						if(!confirm("Неможливо використовувати новий файловий шлях до сертифікатів. Чи бажаєти використовувати раніше встановлений " + oldFilePath + "?")){
							return;
						}
					} catch(e) {
//	Старий файловий шлях недійсний, спробувати перевстановити параметри за замовчуванням
						regFormUtils_DefaultFileSettings();
					}
//	Встановити безпечний тимчасовий шлях до файлового сховища euSign.GetInstallPath()
//			showException(e); regFormStep02_Settings(); return;
				}
			}
		}
			
	} catch(e) {
		showException(e);
		alert("Крок 2. ПОМИЛКА. Не виконано команду euSign.GetFileStoreSettings(). "+euSign.GetLastError());
		return;
	}	
	GenCertTable();
  }
} catch(e) { showException(e); alert("Виникла помилка при виборі нового шляху. Рекомендується обрати іншу директорію або залишити встановлене значення"); }

}


function authForm_SetProxy() {
// Налаштування проксі-сервера, якщо користувач вказав його наявність
	var euSign = document.getElementById("euSign");
        try {
		var euisinit = euSign.IsInitialized();
		if (euisinit == true) {euSign.Finalize(); }
		euSign.SetCharset("UTF-16LE");
		euSign.SetUIMode(false);
		euSign.Initialize();
		euSign.width = "1px";
		euSign.SetUIMode(false);
	} catch(e) {
		if (confirm("Помилка при запуску Java-аплету. Можливо, Вам необхідно дозволити браузеру запуск Java. Чи бажаєти перейти на сторінку перевірки інсталяції Java?")) {
			window.location="http://www.java.com/ru/download/testjava.jsp";
		}
		return false;
	}
	try {
		var ProxySettings = euSign.CreateProxySettings();
		ProxySettings = euSign.GetProxySettings();
		
		
		var bProxyUse = document.getElementById('ProxyUse').checked;
		ProxySettings.SetUseProxy(bProxyUse);
		if (bProxyUse) {
			ProxySettings.SetAddress(document.getElementById('ProxyName').value);
			ProxySettings.SetPort(document.getElementById('ProxyPort').value);
			ProxySettings.SetAnonymous(!document.getElementById('ProxyAnonymous').checked);
			if (ProxySettings.GetAnonymous() == false) {
				ProxySettings.SetUser(document.getElementById('ProxyUser').value);
				ProxySettings.SetPassword(document.getElementById('ProxyPass').value);
//Цей параметр перевірити не вдалось, тому він відключений
//					document.getElementById('ProxySavePass').checked = ProxySettings.GetSavePassword();			
			}
		} else {
			ProxySettings.SetAnonymous(true);
			ProxySettings.SetUser("");
			ProxySettings.SetPassword("");
		}
		euSign.SetProxySettings(ProxySettings);
	} catch(e) {
		ProxySettings = euSign.CreateProxySettings();
		euSign.SetProxySettings(ProxySettings);
		showException(e); alert("Помилка при встановленні параметрів проксі-сервера. Перезапустіть програмний модуль Java та/або інтернет браузер. "+euSign.GetLastError()); return;
	}
}


function authForm_GetProxy() {
//	Спроба зчитування збережених параметрів проксі-сервера
		var ProxySettings;
		try {
			ProxySettings = euSign.CreateProxySettings();
			ProxySettings = euSign.GetProxySettings();
			document.getElementById('ProxyUse').checked = ProxySettings.GetUseProxy();
			Use_Proxy_Check();
			if (ProxySettings.GetUseProxy()==true) {
				document.getElementById('ProxyName').value = ProxySettings.GetAddress();
				document.getElementById('ProxyPort').value = ProxySettings.GetPort();
				document.getElementById('ProxyAnonymous').checked = !ProxySettings.GetAnonymous();
				Use_Proxypas_Check();
				if (document.getElementById('ProxyAnonymous').checked){
					document.getElementById('ProxyUser').value = ProxySettings.GetUser();
					document.getElementById('ProxyPass').value = ProxySettings.GetPassword();
				}
			}
//Цей параметр перевірити не вдалось, тому відключений (todo: перевірити вплив на функціонування)
//					document.getElementById('ProxySavePass').checked = ProxySettings.GetSavePassword();
	
		} catch(e) { // Помилка при зчитуванні параметрів проксі-сервера. Зберігаємо пусті параметри
			try {
				ProxySettings = euSign.CreateProxySettings();
				euSign.SetProxySettings(ProxySettings);
			} catch(e) {
				showException(e); alert("Помилка при встановленні початкових параметрів. Перевірте, чи запущений програмний модуль Java. "+euSign.GetLastError()); return;
			}
		}
}

//	Функція по натисканню кнопки Увійти за ЕЦП на вкладці налаштувань проксі-сервера
function authForm_SetProxyAndSignIn() {
	authForm_SetProxy();
	authForm_SignIn();
	return false;
}






//	Параметри функціонування плагіну відображення малюнку очікування завершення операції.
//	Не працює належним чином.
var spinopts = {
  lines: 13, // The number of lines to draw
  length: 20, // The length of each line
  width: 10, // The line thickness
  radius: 30, // The radius of the inner circle
  corners: 1, // Corner roundness (0..1)
  rotate: 0, // The rotation offset
  direction: 1, // 1: clockwise, -1: counterclockwise
  color: '#000', // #rgb or #rrggbb or array of colors
  speed: 1, // Rounds per second
  trail: 60, // Afterglow percentage
  shadow: false, // Whether to render a shadow
  hwaccel: false, // Whether to use hardware acceleration
  className: 'spinner', // The CSS class to assign to the spinner
  zIndex: 2e9, // The z-index (defaults to 2000000000)
//  top: 'auto', // Top position relative to parent in px
//  left: 'auto' // Left position relative to parent in px
  top: '30', // Top position relative to parent in px
  left: '40' // Left position relative to parent in px
};
var spintarget = document.getElementById('wait_popup');
//var spinner = new Spinner(spinopts).spin(spintarget);
//spinner.stop();
function waitShow(){
	document.getElementById('wait_parent_popup').style.display='block';

//	waitCreateForm();
//	timeoutHandle = setTimeout(function (){waitCloseForm()},15000);
}

function waitCreateForm(){
//	var cont='<p align="center"><img id="wait_gif" src="/auth/processing_wheel.gif" alt="Очікуйте завершення процесу" /></p>';
//	cont +=  '<p align="center">Будь-ласка дочекайтесь завершення операції</p>';
//	document.getElementById('wait_popup').innerHTML = cont;
//	spinner.spin(spintarget);
	document.getElementById('wait_parent_popup').style.display='block';
//	document.getElementById('wait_gif').style.display='block';
}

function waitCloseForm(){
//	document.getElementById('wait_gif').style.display='none';
//	document.getElementById('wait_popup').innerHTML = "";
//	spinner.stop();
	document.getElementById('wait_parent_popup').style.display='none';
//	clearTimeout(timeoutHandle);
}


//	Відправлення POST-запиту
function post(path, params, method) {
    method = method || "post"; // Set method to post by default if not specified.

    // The rest of this code assumes you are not using a library.
    // It can be made less wordy if you use one.
    var form = document.createElement("form");
    form.setAttribute("method", method);
    form.setAttribute("action", path);
    form.setAttribute("id", "AuthForm");
    form.setAttribute("name", "AuthForm");

    for(var key in params) {
        if(params.hasOwnProperty(key)) {
            var hiddenField = document.createElement("input");
            hiddenField.setAttribute("type", "hidden");
            hiddenField.setAttribute("name", key);
            hiddenField.setAttribute("value", params[key]);

            form.appendChild(hiddenField);
         }
    }
    var subm = document.createElement("input");
    subm.setAttribute("value", "Send");
    subm.setAttribute("type", "submit");
    subm.setAttribute("name", "AuthForm");
    form.appendChild(subm);
    document.body.appendChild(form);
    document.forms["AuthForm"].submit();
//    form.submit();
}
