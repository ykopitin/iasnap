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
<xsl:copy-of select="//input[@id='FFModel_id']" />
<table>
	<tr>
		<td style="margin-bottom: -23px;">
		<table>
			<tr>
				<td width="100"><font face="Arial" size="2"><b>
					<xsl:value-of select="//div[@id='formff_fieldlabel_service']/label" /></b>
				</font></td>
				<td><font face="Arial" size="2">
					<xsl:copy-of select="//div[@id='formff_fieldvalue_service']" />
				</font></td>
			</tr>
		</table>
		</td>
	</tr>



		<tr>
		<td>
<font face="Arial" size="2"><b>Дата та номер</b></font></td>
			
	</tr>
	<tr>
		<td>
		<table border="0" bgcolor="#E9E9E9" height="0%" style="border: 1px solid #808080; border-radius:8px; padding: 1px">
			<tr>
				<td width="33%"  style="vertical-align: top;" >
				

<table width="100%" id="table4" >
					<tr>
						<td><font face="Arial" size="2">№&#160;з/п,&#160;дата:&#160;</font></td>
						<td ><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_regnum']" /></font></td>
						<td width="30%"><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_regdate']" />
						</font></td>
					</tr>
					<tr>
						<td><font face="Arial" size="2">Вих.&#160;№,&#160;дата:&#160;</font></td>
						<td ><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_outnum']" />
						</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_outdate']" />
						</font></td>
					</tr>
					<tr>
						<td> </td>
						<td  style="text-align: right;"><font face="Arial" size="2">Знято&#160;з&#160;контролю:&#160;</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_factdate']" />
						</font></td>
					</tr>
				</table>
				</td>
				




<td width="33%"  style="vertical-align: top;">
				<table border="0" width="100%" id="table5">
					<tr>
						<td width="130"><font face="Arial" size="2">Контрольна&#160;дата:&#160;</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_plandate']" />
						</font></td>
					</tr>
					<tr>
						<td width="130"><font face="Arial" size="2">Продовжено&#160;до:&#160;</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_renewal_date']" />
						</font></td>
					</tr>
				</table>
				</td>
				<td width="33%"  style="vertical-align: top;">
				<table border="0" width="100%" id="table6">
					<tr>
						<td width="100"><font face="Arial" size="2">Доставлено:&#160;</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_delivery']" />
						</font></td>
					</tr>
					<tr>
						<td width="100"><font face="Arial" size="2">Трек-номер:&#160;</font></td>
						<td><font face="Arial" size="2">
							<xsl:copy-of select="//div[@id='formff_fieldvalue_tracknumber']" />
						</font></td>
					</tr>
					<tr>
						<td width="100"><font face="Arial" size="2">Аркушів:&#160;</font></td>
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

<td><b><font face="Arial" size="2">Кореспондент</font></b></td></tr>



	<tr>
		<td>
		<table border="0" width="100%" id="table9" bgcolor="#E9E9E9" style="border: 1px solid #808080;  border-radius:8px; padding: 1px">
			<tr>
				<td>
				<table  width="100%" id="table10">
					<tr>
						


						<td width="33%"   style="vertical-align: top;">
						<font face="Arial" size="2">
									<xsl:copy-of select="//div[@id='formff_fieldvalue_legal_personality']" />
								</font>
						</td>
						


						<td width="33%"   style="vertical-align: top;">
						

								<table border="0" width="100%" id="table13">
									<tr>
										<td>
										<font face="Arial" size="2">Організація:</font></td>
										<td style="text-align: left;"><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_organization_name']" />
										</font></td>
									</tr>

									<tr>
										<td><font face="Arial" size="2">ПІБ:</font></td>
								
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_person_name']" />
										</font></td>
									</tr>
								</table>

						</td>
						



						<td width="33%"   style="vertical-align: top;">
						<table border="0" id="table15" style='width:"100%" '>
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
							
						</table>
						</td>
					</tr>
				</table>
				</td>
			</tr>

<tr>	<td>

<table>
<tr>
<td style="width:32%; text-align:left; ">


<table width="100%">
<tr>
<td style="width:5px; text-align:left; "><xsl:copy-of select="//div[@id='formff_fieldvalue_its_autority']" /></td>
<td style="text-align:left;"><font face="Arial" size="2"><xsl:copy-of select="//div[@id='formff_fieldlabel_its_autority']" /></font></td>
</tr>
</table>

</td>
<td style="width:35.2%; text-align:left; ">
<table>
<tr>
										<td><font face="Arial" size="2">&#160;ПІБ:</font></td>
								
										<td style="text-align:right;"><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_autority_person_name']" />
										</font></td>
									</tr>
</table></td>
<td><table><tr>
								<td width="110"><font face="Arial" size="2">№ 
								довіреності:</font></td>
								<td><font face="Arial" size="2">
									<xsl:copy-of select="//div[@id='formff_fieldvalue_autority_person_number']" />
								</font></td>
							</tr></table></td>
</tr></table>


</td></tr>
			<tr>
				<td>
				<table border="0" width="100%" id="table16">
					<tr>
						<td style="vertical-align: top;"><font face="Arial" size="2">Контактна адреса для 
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
						e-mail:</font></td>
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
						
							<xsl:copy-of select="//div[@id='formff_fieldvalue_email']" />
						</font></td>
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

				<td><b><font face="Arial" size="2">Файли вхідні</font></b></td>
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
		<b><font face="Arial" size="2">Відомості про виконання 
				заявки</font></b>
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
				<td width="130"><font face="Arial" size="2">Заява оброблена:</font></td>
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
										<td  style="width: 200px;">
										<font face="Arial" size="2">Виконавець 
										(посада, ПІБ):</font></td>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_executor_post']" />
										</font></td>
									</tr>
									<tr>
										<td  style="width: 200px;">
										<font face="Arial" size="2">Результати 
										розгляду:</font></td>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_reply']" />
										</font></td>
									</tr>
									<tr>
										<td  style="width: 200px;"> </td>
										<td><br /> </td>
									</tr>
									<tr>
										<td  style="width: 200px;"><table><tr>
										<td  style="width:5px; text-align:left; "><xsl:copy-of select="//div[@id='formff_fieldvalue_result_delivery']" /></td>
										<td  style="text-align:left; width: 200px;"><font face="Arial" size="2"><xsl:copy-of select="//div[@id='formff_fieldlabel_result_delivery']" /></font></td></tr></table>
										
											
											
										</td>
										<td><font face="Arial" size="2">
											<xsl:copy-of select="//div[@id='formff_fieldvalue_result_date_delivery']" />
										</font></td>
									</tr>
								</table>
								</td>
								<td width="50%" style="vertical-align:top">
								<table border="0" width="100%" id="table29">
									<tr>
										<td align="left"   style="vertical-align: top;">
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
										<td align="left"   style="vertical-align: top;">
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

</table>
<xsl:copy-of select="//div[@class='hiddenItems']" />
</form>
</xsl:template>
</xsl:stylesheet>