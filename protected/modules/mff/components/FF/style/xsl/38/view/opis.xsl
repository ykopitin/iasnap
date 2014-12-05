<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output method="html" />
    <xsl:template match="/">

        <div id="page1" style="page-break-after: xalways;">
            <center>
                <span style="font-size:14pt;">
                    <big>ОПИС</big>
                    <br/>
                        <br/>
                            № &#160; <u><xsl:copy-of select="//div[@id='formff_fieldvalue_regnum']" /></u>
                            від <u><xsl:copy-of select="//div[@id='formff_fieldvalue_regdate']" /></u>
                </span>
                <br/>
                    <span class="cell_hdr">вхідного пакету документів на отримання адміністративної послуги
                    </span>

            </center>
            <p>
                <span class="cell_hdr"> Cуб’єкт звернення:</span>
                <span class="cell_under">
                    <xsl:copy-of select="//div[@id='formff_fieldvalue_organization_name']" />, <xsl:copy-of select="//div[@id='formff_fieldvalue_person_name']" />, <xsl:copy-of select="//div[@id='formff_fieldvalue_address']" />, <xsl:copy-of select="//div[@id='formff_fieldvalue_phone1']" />, <xsl:copy-of select="//div[@id='formff_fieldvalue_phone2']" />, ІНН <xsl:copy-of select="//div[@id='formff_fieldvalue_person_drfo']" />, </span>
            </p>
            <p>
                <span class="cell_hdr"> Суб’єкт надання адміністративних послуг</span>
                <span class="cell_under"><xsl:value-of select="//div[@id='formff_fieldvalue_executor']/select/option[@selected]" /></span>
            </p>
            <p>
                <span class="cell_hdr">Назва адміністративної послуги</span>
                <span class="cell_under">
                    <xsl:copy-of select="//div[@id='formff_fieldvalue_service']" />
                </span>
            </p>
            <p>
                <span class="cell_hdr">Адреса об'єкта</span>
                <span class="cell_under">________________________________</span>
            </p>
            <p>
                <span class="cell_hdr">Термін розгляду звернення</span>
                <span class="cell_under">  <xsl:copy-of select="//div[@id='formff_fieldvalue_plandate']" /></span>
            </p>
            <p>
                <span class="cell_hdr">Опис документів щодо отримання адміністративної послуги</span>
                <span class="cell"></span>
            </p>
            <ul>
                <li><xsl:copy-of select="//div[@id='formff_fieldlabel_file_petition']" />
                </li>

            </ul>
            <p></p>
            <br/>
                <table border="0" cellpadding="4" cellspacing="0" width="80%">
                    <tbody>
                        <tr>
                            <td>
                                <span class="cell_hdr">Адміністратор </span>
                            </td>
                            <td>
                                <span>
                                    <b><xsl:value-of select="//div[@id='formff_fieldvalue_administrator']/select/option[@selected]" /></b>
                                </span>
                                <br/>
                                    <hr class="line" noshade="" width="100%" size="1"/>
                                        <br/>
                            </td>
                            <td width="30%" align="center">
                                <br/>
                                    <hr class="line" noshade="" width="100%" size="1"/>
                                        <span class="subtitle">Дата, Підпис</span>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="3">
                                <br/>
                            </td>
                            <td>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <span class="cell_hdr">Суб'єкт звернення </span>
                            </td>
                            <td>
                                <b> <xsl:copy-of select="//div[@id='formff_fieldvalue_person_name']" /> </b>
                                <br/>
                                    <hr class="line" noshade="" width="100%" size="1"/>
                                        <br/>
                            </td>
                            <td width="30%" align="center">
                                <br/>
                                    <hr class="line" noshade="" width="100%" size="1"/>
                                        <span class="subtitle">Дата, Підпис</span>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <p>
                    <span class="cell_hdr">Спосіб отримання суб’єктом  звернення  вихідного пакету документів:</span>
                </p>
                <table border="0" align="center" width="80%">
                    <tbody>
                        <tr>
                            <td align="left">
                                <table border="0">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <span style="font-size:20pt;">□</span>
                                            </td>
                                            <td> особисто</td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="font-size:20pt;">□</span>
                                            </td>
                                            <td>пошта </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                <span style="font-size:20pt;">□</span>
                                            </td>
                                            <td>телефон </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </td>
                            <td align="right">
                                <xsl:copy-of select="//div[@id='formff_fieldvalue_tracknumber']" />
                            </td>
                        </tr>
                    </tbody>
                </table>
                <p></p>
        </div>
    </xsl:template>
</xsl:stylesheet>
