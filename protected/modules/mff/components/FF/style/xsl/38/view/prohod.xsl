<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    version="1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
    <xsl:output method="html" />
    <xsl:template match="/">

        <div>
            <center>
                <span class="hdr2">Лист-проходження <br/>етапів отримання адміністративної
                        послуги/документа дозвільного характеру</span>
                <br />
                (є невід'ємною частиною справи)
            </center>

            <p>
                <span class="hdr2">1. Відмітка про реєстрацію справи адміністратором/державним адміністратором
                </span>
                <br />

            </p>
            <table border="0" width="90%" align="center">
                <tbody>
                    <tr>
                        <td>
                            <xsl:copy-of select="//div[@id='formff_fieldvalue_regdate']" />
                        </td>
                        <td align="center">
                            <xsl:copy-of select="//div[@id='formff_fieldvalue_regnum']" />
                        </td>
                        <td align="right">
                            <xsl:value-of select="//div[@id='formff_fieldvalue_administrator']/select/option[@selected]" />/__________________</td>
                    </tr>
                    <tr>
                        <td>
                            <span class="subtitle">  дата </span>
                        </td>
                        <td align="center">
                            <span class="subtitle">  № реєстрації</span>
                        </td>
                        <td align="right">
                            <span class="subtitle">   ПІБ адміністратора  /  підпис            М.П.<br />(державного адміністратора)</span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p></p>

            <p>
            </p>
            <table>
                <tbody>
                    <tr>
                        <td valign="top">
                            <span class="hdr2">2. Відмітка про передачу справи до</span>
                        </td>
                        <td valign="top">
                            <table>
                                <tbody>
                                    <tr>
                                        <td>
                                            <i>
                                                <big>
                                                    <xsl:copy-of select="//div[@id='formff_fieldvalue_authorities']" />
                                                </big>
                                            </i>
                                            <hr class="line" noshade="" width="100%" size="1" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="center">
                                            <span class="subtitle">(назва суб'єкта надання адміністративної послуги / дозвільного органу)</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </td>
                    </tr>
                </tbody>
            </table>
            <table border="0" width="90%" align="center">
                <tbody>
                    <tr>
                        <td> _____________ </td>
                        <td align="center">
                            <xsl:copy-of select="//div[@id='formff_fieldvalue_factdate']" />
                        </td>
                        <td align="right">    <xsl:value-of select="//div[@id='formff_fieldvalue_executor']/select/option[@selected]" />/________________
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span class="subtitle">  дата </span>
                        </td>
                        <td align="center">
                            <span class="subtitle">  термін розгляду </span>
                        </td>
                        <td align="right">
                            <span class="subtitle">  ПІБ відповідальної особи  / підпис </span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p></p>

            <p>
                <span class="hdr2">3. Відмітка про розгляд справи посадовою особою суб'єкта надання адміністративної послуги (дозвільного органу)
                </span>
                <br/>

            </p>
            <table border="0" width="90%" align="center">
                <tbody>
                    <tr>
                        <td>______________________________  </td>
                        <td align="right">  <xsl:value-of select="//div[@id='formff_fieldvalue_executor']/select/option[@selected]" /></td>
                    </tr>
                    <tr>
                        <td>
                            <span class="subtitle"> дата отримання справи виконавцем</span>
                        </td>
                        <td align="right">
                            <span class="subtitle"> ПІБ виконавця, що розглядає справу</span>
                        </td>
                    </tr>
                    <tr>
                        <td>______________________________  </td>
                        <td align="right"><xsl:copy-of select="//div[@id='formff_fieldvalue_reply']" /></td>
                    </tr>
                    <tr>
                        <td>
                            <span class="subtitle"> дата та №  оформлення результату </span>
                        </td>
                        <td align="right">
                            <span class="subtitle">результат розгляду справи </span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p></p>

            <p>
                <span class="hdr2">4. Відмітка про передачу вихідного пакету документів до Центру надання адміністративних
                    послуг</span>
                <br />

            </p>
            <table border="0" width="90%" align="center">
                <tbody>
                    <tr>
                        <td>___________ </td>
                        <td align="right">
                            <xsl:value-of select="//div[@id='formff_fieldvalue_administrator']/select/option[@selected]" />/________________
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span class="subtitle">  дата </span>
                        </td>
                        <td align="right">
                            <span class="subtitle">  ПІБ адміністратора      / підпис   / М.П. <br />
                                    (державного адміністратора)
                            </span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p></p>



            <p>
                <span class="hdr2">5. Відмітка про отримання результату справи суб'єктом звернення
                </span>
                <br />
            </p>
            <table border="0" width="90%" align="center">
                <tbody>
                    <tr>
                        <td>___________ </td>
                        <td align="right">    ____________________/________________
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <span class="subtitle">  дата </span>
                        </td>
                        <td align="right">
                            <span class="subtitle">  ПІБ особи, яка отримала відповідь /               підпис  </span>
                        </td>
                    </tr>
                </tbody>
            </table>
            <p></p>
        </div>

    </xsl:template>
</xsl:stylesheet>
