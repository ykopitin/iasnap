<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output method="html" />
    <xsl:strip-space elements="formff_field_initeds"/>
    <xsl:template match="/">    
<xsl:copy-of select="//div[@id='formff_fieldvalue_initeds']" />    
<form enctype="multipart/form-data" id="formff_form" method="post">
<xsl:attribute name="action" >
	<xsl:value-of select="//form/@action"/>
</xsl:attribute>
<input name="FFModel[id]" id="FFModel_id" type="hidden" />
<table border="0" width="100%" id="table1" cellspacing="3" cellpadding="8">
	<tr>
		<td>
		<table border="0" width="100%" id="table2">
			<tr>
				<td width="130">
				<p align="left"><font face="Arial" size="2"><span lang="uk">
					<xsl:value-of select="//div[@id='formff_fieldlabel_service']/label" />
				</span></font></p></td>
				<td><font face="Arial" size="2"><span lang="uk">
					<xsl:copy-of select="//div[@id='formff_fieldvalue_service']" />
				</span></font></td>
			</tr>
		</table>
		</td>
	</tr>
		<tr>
		<td><table border="0" width="100%" id="table7" cellspacing="0" cellpadding="0">
			<tr>
				<td></td>
			</tr>
			<tr>
				<td><font face="Arial" size="2"><p ><b>Дата та номер</b></p></font></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" width="100%" id="table3" cellspacing="0" cellpadding="8" bgcolor="#E9E9E9" style="border: 1px solid #808080; border-radius:8px; padding: 1px">
			<tr>
				<td width="33%" valign="top">
				<table width="100%" id="table4" >
					<tr>
						<td width="100"><font face="Arial" size="2">№ з/п, дата:</font></td>
						<td width="30%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_regnum']" /></font></td>
						<td width="30%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_regdate']" />
						</font></td>
					</tr>
					<tr>
						<td width="100"><font face="Arial" size="2">Вих. №, 
						дата:</font></td>
						<td width="30%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_outnum']" />
						</font></td>
						<td width="30%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_outdate']" />
						</font></td>
					</tr>
					<tr>
						<td width="100"> </td>
						<td width="30%"><font face="Arial" size="2">Знято з 
						контролю:</font></td>
						<td width="30%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_factdate']" />
						</font></td>
					</tr>
				</table>
				</td>
				<td width="33%" valign="top">
				<table border="0" width="100%" id="table5">
					<tr>
						<td width="130"><font face="Arial" size="2">Контрольна 
						дата:</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_plandate']" />
						</font></td>
					</tr>
					<tr>
						<td width="130"><font face="Arial" size="2">Продовжено 
						до:</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_renewal_date']" />
						</font></td>
					</tr>
				</table>
				</td>
				<td width="33%" valign="top">
				<table border="0" width="100%" id="table6">
					<tr>
						<td width="100"><font face="Arial" size="2">Доставлено:</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_delivery']" />
						</font></td>
					</tr>
					<tr>
						<td width="100"><font face="Arial" size="2">Трек-номер:</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_tracknumber']" />
						</font></td>
					</tr>
					<tr>
						<td width="100"><font face="Arial" size="2">Аркушів:</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_number_of_pages']" />
						</font></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" width="100%" id="table8" cellspacing="0" cellpadding="0">
			<tr>
				<td></td>
			</tr>
			<tr>
				<td><p style="margin-bottom: -15px; margin-left: 5px;"><b><font face="Arial" size="2">Кореспондент</font></b></p></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" width="100%" id="table9" bgcolor="#E9E9E9" style="border: 1px solid #808080;  border-radius:8px; padding: 1px">
			<tr>
				<td>
				<table border="0" width="100%" id="table10">
					<tr>
						<td width="33%" valign="top">
						<table border="0" width="100%" id="table11">
							<tr>
								<td><font face="Arial" size="2">
									<xsl:copy-of select="//div[@id='formff_fieldvalue_legal_personality']" />
								</font></td>
							</tr>
							<tr>
								<td> </td>
							</tr>
							<tr>
								<td> </td>
							</tr>
							<tr>
								<td> </td>
							</tr>
							<tr>
								<td><font face="Arial" size="2">
									<xsl:copy-of select="//div[@id='formff_fieldvalue_its_autority']" />
									<xsl:copy-of select="//div[@id='formff_fieldlabel_its_autority']" />
								</font></td>
							</tr>
						</table>
						</td>
						<td width="33%" valign="top">
						<table border="0" width="100%" id="table12">
							<tr>
								<td>
								<table border="0" width="100%" id="table13">
									<tr>
										<td width="90">
										<font face="Arial" size="2">Організація:</font></td>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_organization_name']" />
										</font></td>
									</tr>
								</table>
								</td>
							</tr>
							<tr>
								<td>
								<table border="0" width="100%" id="table14">
									<tr>
										<td><font face="Arial" size="2">ПІБ:</font></td>
									</tr>
									<tr>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_person_name']" />
										</font></td>
									</tr>
									<tr>
										<td><font face="Arial" size="2">ПІБ:</font></td>
									</tr>
									<tr>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_autority_person_name']" />
										</font></td>
									</tr>
								</table>
								</td>
							</tr>
						</table>
						</td>
						<td width="33%" valign="top">
						<table border="0" id="table15" style='width:"100%" height:"100%"'>
							<tr>
								<td width="110"><font face="Arial" size="2">Код 
								ЄДРПОУ:</font></td>
								<td><font face="Arial" size="2">
									<xsl:copy-of select="//div[@id='formff_fieldvalue_organization_edrpou']" />
								</font></td>
							</tr>
							<tr>
								<td width="110"><font face="Arial" size="2">Код 
								ДРФО:</font></td>
								<td><font face="Arial" size="2">
									<xsl:copy-of select="//div[@id='formff_fieldvalue_person_drfo']" />							
								</font></td>
							</tr>
							<tr>
								<td width="110"><font face="Arial" size="2">№ 
								довіреності:</font></td>
								<td><font face="Arial" size="2">
									<xsl:copy-of select="//div[@id='formff_fieldvalue_autority_person_number']" />
								</font></td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table border="0" width="100%" id="table16">
					<tr>
						<td><font face="Arial" size="2">Контактна адреса для 
						надання відповіді:</font></td>
					</tr>
					<tr>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_address']" />
						</font></td>
					</tr>
				</table>
				</td>
			</tr>
			<tr>
				<td>
				<table border="0" width="100%" id="table17">
					<tr>
						<td width="25%"><font face="Arial" size="2">Телефон №1:</font></td>
						<td width="25%"><font face="Arial" size="2">Телефон №2:</font></td>
						<td width="25%"><font face="Arial" size="2">
						<span lang="en-us">e-mail:</span></font></td>
						<td width="25%"><font face="Arial" size="2">Форма 
						надання відповіді:</font></td>
					</tr>
					<tr>
						<td width="25%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_phone1']" />
						</font></td>
						<td width="25%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_phone2']" />
						</font></td>
						<td width="25%"><font face="Arial" size="2">
						<span lang="en-us">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_email']" />
						</span></font></td>
						<td width="25%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_delivery_reply']" />
						</font></td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" width="100%" id="table18" cellspacing="0" cellpadding="0">
			<tr>
				<td></td>
			</tr>
			<tr>
				<td><p style="margin-bottom: -15px; margin-left: 5px;"><b><font face="Arial" size="2">Файли вхідні</font></b></p></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" width="100%" id="table19" bgcolor="#E9E9E9" style="border: 1px solid #808080;  border-radius:8px; padding: 1px">
			<tr>
				<td>
				<div align="left">
					<table border="0" width="80%" id="table20">
						<tr>
							<td width="250"><font face="Arial" size="2">Заява на отримання послуги</font></td>
							<td align="center">
								<xsl:copy-of select="//div[@id='formff_fieldvalue_file_petition']" />
							</td>
						</tr>					
					</table>
				</div>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" width="100%" id="table21" cellspacing="0" cellpadding="0">
			<tr>
				<td></td>
			</tr>
			<tr>
				<td><p style="margin-bottom: -15px; margin-left: 5px;"><b><font face="Arial" size="2">Відомості про виконання 
				заявки</font></b></p></td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td>
		<table border="0" width="100%" id="table24" bgcolor="#E9E9E9" style="border: 1px solid #808080; border-radius:8px;  padding: 1px">
			<tr>
				<td>
				<table border="0" width="100%" id="table25">
					<tr>
						<td>
		<table border="0" width="100%" id="table27">
			<tr>
				<td width="130">
				<p align="left"><font face="Arial" size="2"><span lang="uk">
				Заява оброблена:</span></font></p></td>
				<td><font face="Arial" size="2">
					<xsl:copy-of select="//div[@id='formff_fieldvalue_authorities']" />
				</font></td>
			</tr>
		</table>
						</td>
					</tr>
					<tr>
						<td>
						<table border="0" width="100%" id="table26">
							<tr>
								<td width="50%" align="left" style="vertical-align:top">
								<table border="0" width="100%" id="table28" >
									<tr>
										<td width="200">
										<font face="Arial" size="2">Виконавець 
										(посада, ПІБ):</font></td>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_executor_post']" />
										</font></td>
									</tr>
									<tr>
										<td width="200">
										<font face="Arial" size="2">Результати 
										розгляду:</font></td>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_reply']" />
										</font></td>
									</tr>
									<tr>
										<td width="200"> </td>
										<td> </td>
									</tr>
									<tr>
										<td width="200">
										<font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_result_delivery']" />
											<xsl:copy-of select="//div[@id='formff_fieldlabel_result_delivery']" />
										</font></td>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_result_date_delivery']" />
										</font></td>
									</tr>
								</table>
								</td>
								<td width="50%" style="vertical-align:top">
								<table border="0" width="100%" id="table29">
									<tr>
										<td align="left" valign="top">
										<table border="0" width="100%" id="table30">
											<tr>
												<td><font face="Arial" size="2">
													<xsl:copy-of select="//div[@id='formff_fieldvalue_executor']" />
												</font></td>
												<td><font face="Arial" size="2">Дата виконання:
													
												</font></td>
												<td><font face="Arial" size="2">  
													<xsl:copy-of select="//div[@id='formff_fieldvalue_exec_date']" />
												</font></td>
											</tr>
										</table>
										</td>
									</tr>
									<tr>
										<td align="left" valign="top">
										<font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_reason']" />
										</font></td>
									</tr>
									<tr>
										<td>
										<table border="0" width="100%" id="table31">
											<tr>
												<td><font face="Arial" size="2">
												Файл результату</font></td>
												<td><font face="Arial" size="2">
													<xsl:copy-of select="//div[@id='formff_fieldvalue_file_result']" />
												</font></td>
											</tr>
										</table>
										</td>
									</tr>
								</table>
								</td>
							</tr>
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>
		</table>
		</td>
	</tr>
	<tr>
		<td> </td>
	</tr>
</table>
<xsl:copy-of select="//div[@class='hiddenItems']" />
</form>
</xsl:template>
</xsl:stylesheet>