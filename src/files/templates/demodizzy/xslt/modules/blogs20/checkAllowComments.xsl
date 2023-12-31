<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE xsl:stylesheet SYSTEM	"ulang://i18n/constants.dtd:file">

<xsl:stylesheet	version="1.0"
				xmlns="http://www.w3.org/1999/xhtml"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:date="http://exslt.org/dates-and-times"
				xmlns:udt="http://umi-cms.ru/2007/UData/templates"
				exclude-result-prefixes="xsl date udt">

	<xsl:template match="udata[@module = 'blogs20'][@method = 'checkAllowComments']">
		<p>&comment-login;</p>
		<xsl:apply-templates select="document('udata://users/auth/')/udata" />
	</xsl:template>

	<xsl:template match="udata[@module = 'blogs20'][@method = 'checkAllowComments'][. = 1]">
		<form id="comment_add_form" name="frm_addblogmsg" method="post" action="/blogs20/commentAdd/{$document-page-id}/" onsubmit="return site.forms.data.check(this);">
			<div class="form_element">
				<a name="additem" />
				<label class="required">
					<span>&comment-title;:</span>
					<input type="text" name="title" class="textinputs" />
				</label>
			</div>
			<xsl:if test="$user-type = 'guest'">
				<div class="form_element">
					<label class="required">
						<span>&comment-you-name;:</span>
						<input type="text" name="nick" class="textinputs" />
					</label>
				</div>
				<div class="form_element">
					<label class="required">
						<span>&comment-you-email;:</span>
						<input type="text" name="email" class="textinputs" />
					</label>
				</div>
			</xsl:if>
			<div class="form_element">
				<label class="required">
					<span><xsl:text>&comment-body;:</xsl:text></span>
					<textarea name="content"></textarea>
				</label>
			</div>
			<div class="form_element">
				<xsl:apply-templates select="document('udata://system/captcha/')/udata" />
			</div>
			<div class="form_element">
				<input type="submit" class="button">
					<xsl:attribute name="value">&comment-submit;</xsl:attribute>
				</input>
			</div>
		</form>
	</xsl:template>

</xsl:stylesheet>