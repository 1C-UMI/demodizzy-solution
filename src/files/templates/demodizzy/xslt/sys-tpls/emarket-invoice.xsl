<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE xsl:stylesheet [ <!ENTITY nbsp "&#160;"> ]>

<xsl:stylesheet	version="1.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:php="http://php.net/xsl"
		xsl:extension-element-prefixes="php"
		exclude-result-prefixes="php">

	<xsl:output encoding="utf-8" method="html" indent="yes"/>

	<xsl:template match="/">
		<xsl:variable name="payment" select="document(concat('uobject://', //property[@name='payment_id']/value/item/@id))/udata/object" />
		<xsl:variable name="person" select="document(concat('uobject://', //property[@name='legal_person']/value/item/@id))/udata/object" />

		<html>
			<head>
			<style type="text/css">
				table td td{
					border: 1px solid black;
				}
				.table_caption {
					text-align: center;
					margin: 0;
					font-size: 13px;
				}
			</style>
			<style type="text/css" media="print">
				@page {
					size: auto;
					margin: 7mm;
				}
			</style>
			</head>
			<body id="invoice">
			<div style="width:620px;"><!--hr/--></div>
			<table bgcolor="#FFFFFF" width="620" cellpadding="1" cellspacing="0">
				<tr>
					<td align="left" valign="top" style="font-family:Arial;font-size:13px;">
						<u><b><xsl:value-of select="$payment//property[@name='name']/value" /></b></u>
						<br/><br/>
						<b>Адрес: <xsl:value-of select="$payment//property[@name='legal_address']/value" />, тел.: <xsl:value-of select="$payment//property[@name='phone_number']/value" /></b>
						<br/><br/>
						<h4 class="table_caption">Образец заполнения платежного поручения</h4>
						<table class="tbl" width="620" cellpadding="2" cellspacing="0" border="0" bordercolor="#000000" style="font-family:Arial;font-size:13px;">
							<tr>
								<td width="175" align="left" valign="top">ИНН <xsl:value-of select="$payment//property[@name='inn']/value" /></td>
								<td width="175" align="left" valign="top">КПП <xsl:value-of select="$payment//property[@name='kpp']/value" /></td>
								<td width="54" align="center" valign="bottom" rowspan="2">Сч. №</td>
								<td width="216" align="left" valign="bottom" rowspan="2"><xsl:value-of select="$payment//property[@name='account']/value" /></td>
							</tr>
							<tr>
								<td width="350" align="left" valign="top" colspan="2">
									Получатель
									<br/>
									<xsl:value-of select="$payment//property[@name='name']/value" />
								</td>
							</tr>
							<tr>
								<td align="left" valign="top" rowspan="2" colspan="2">
									Банк получателя
									<br/>
									<xsl:value-of select="$payment//property[@name='bank']/value" />

								</td>
								<td align="center" valign="top">БИК</td>
								<td align="left" valign="top" style="border-bottom-width:0px;"><xsl:value-of select="$payment//property[@name='bik']/value" /></td>
							</tr>
							<tr>
								<td align="center" valign="top">Сч. №</td>
								<td align="left" valign="top" style="border-top-width:0px;"><xsl:value-of select="$payment//property[@name='bank_account']/value" /></td>
							</tr>
						</table>
						<br/><br/>
						<center style="font:16 Arial;font-weight:bold;">СЧЕТ № И/<xsl:value-of select="/udata/object/@id" />/П от <xsl:value-of select="php:function('dateToString', number(//property[@name='order_date']/value/@unix-timestamp))" />.</center>
						<br/><br/>
						<p>
							<xsl:text>Покупатель: ИНН </xsl:text><xsl:value-of select="$person//property[@name='inn']/value" />
							<xsl:text>, КПП </xsl:text><xsl:value-of select="$person//property[@name='kpp']/value" />
							<xsl:if test="$person//property[@name='name']/value">
							<xsl:text>, </xsl:text><xsl:value-of select="$person//property[@name='name']/value" />
							</xsl:if>
							<xsl:if test="$person//property[@name='legal_address']/value">
							<xsl:text>, </xsl:text><xsl:value-of select="$person//property[@name='legal_address']/value" />
							</xsl:if>
							<xsl:if test="$person//property[@name='phone_number']/value">
							<xsl:text>, тел: </xsl:text><xsl:value-of select="$person//property[@name='phone_number']/value" />
							</xsl:if>
							<xsl:if test="$person//property[@name='fax']/value">
							<xsl:text>, факс: </xsl:text><xsl:value-of select="$person//property[@name='fax']/value" />
							</xsl:if>
						</p>
						<table class="tbl" width="620" cellpadding="3" cellspacing="0" border="0" bordercolor="#000000" style="font-family:Arial;font-size:13px;">
							<tr>
								<td width="20" align="center" valign="middle">№</td>
								<td width="300" align="center" valign="middle">Наименование товара</td>
								<td width="65" align="center" valign="middle">Количество</td>
								<td width="65" align="center" valign="middle">Единица измерения</td>
								<td width="85" align="center" valign="middle">Цена</td>
								<td width="85" align="center" valign="middle">Сумма</td>
							</tr>

							<xsl:apply-templates select="//property[@name='order_items']/value/item" mode="order-items" />

							<xsl:variable name="total_original_price" select="//property[@name='total_original_price']/value" />
							<xsl:variable name="total_price" select="//property[@name='total_price']/value" />
							<xsl:variable name="delivery" select="//property[@name='delivery_price']/value" />
							<xsl:variable name="discount" select="$total_original_price + $delivery - $total_price" />

							<xsl:if test="$discount &gt; 0">
							<tr>
									<td align="right" valign="top" colspan="5"><b>Скидка:</b></td>
									<td align="right" valign="top">
											<xsl:value-of select="format-number($discount, '#.00')" />
									</td>
								</tr>
							</xsl:if>

							<xsl:apply-templates select="//property[@name='delivery_price']/value" mode="delivery" />

							<tr>
								<td align="right" valign="top" colspan="5" style="border-left: 0; border-bottom: 0;border-top:0" ><b>Итого:</b></td>
								<td align="right" valign="bottom"><xsl:value-of select="format-number(//property[@name='total_price']/value, '#.00')" /></td>
							</tr>
							<tr>
								<td colspan="5" align="right" valign="bottom" style="border-left: 0; border-bottom: 0;border-top:0"><b>Без налога (НДС).</b></td>
								<td align="right" valign="bottom">-</td>
							</tr>
							<tr>
								<td colspan="5" align="right" valign="bottom" style="border-left: 0; border-bottom: 0;border-top:0"><b>Всего к оплате:</b></td>
								<td align="right" valign="bottom"><xsl:value-of select="format-number(//property[@name='total_price']/value, '#.00')" /></td>
							</tr>
						</table>
						<br/><br/>
						<p style="font-family:Arial;font-size:13px;">
							Всего наименований <xsl:value-of select="//property[@name='total_amount']/value" />, на сумму <xsl:value-of select="format-number(//property[@name='total_price']/value, '0.00')" /> руб.
							<br/>
							<b>(<xsl:value-of select="php:function('sumToString', number(//property[@name='total_price']/value), 1, 'рубль', 'рубля', 'рублей', 0)" />)</b>
						</p>

						<img>
							<xsl:if test="$payment//property[@name='sign_image']/value">
								<xsl:attribute name="src">
									<xsl:value-of select="$payment//property[@name='sign_image']/value" />
								</xsl:attribute>
							</xsl:if>
						</img>
					</td>
				</tr>
			</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="item" mode="order-items">
		<xsl:variable name="object" select="document(concat('uobject://', @id))/udata/object" />
		<tr>
			<td width="20" align="center" valign="top"><xsl:value-of select="position()" /></td>
			<td width="300" align="left" valign="middle"><xsl:value-of select="$object/@name" /></td>
			<td width="65" align="right" valign="bottom"><xsl:value-of select="$object//property[@name='item_amount']/value" /></td>
			<td width="65" align="center" valign="bottom">шт.</td>
			<td width="85" align="right" valign="bottom"><xsl:value-of select="format-number($object//property[@name='item_price']/value, '#.00')" /></td>
			<td width="85" align="right" valign="bottom"><xsl:value-of select="format-number($object//property[@name='item_total_price']/value, '#.00')" /></td>
		</tr>
	</xsl:template>

	<xsl:template match="value[.='0']" mode="delivery" />
	<xsl:template match="value" mode="delivery">
		<tr>
			<td align="right" valign="bottom" colspan="5" style="border-left: 0; border-bottom: 0"><b>Доставка:</b></td>
			<td align="right" valign="bottom">
					<xsl:value-of select="format-number(., '#.00')" />
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>