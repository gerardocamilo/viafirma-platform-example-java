<%-- <%@page import="org.viafirma.cliente.util.PolicyParams"%> --%>
<%@page import="org.viafirma.cliente.firma.Policy"%>
<%@page import="org.viafirma.cliente.firma.TypeSign"%>
<%@page import="org.viafirma.cliente.util.PolicyParams"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%-- <%@page import="org.viafirma.cliente.firma.TypeSign"%> --%>
<%@page import="org.viafirma.cliente.firma.TypeFormatSign"%>
<%@page import="org.viafirma.cliente.vo.Documento"%>
<%-- <%@page import="org.viafirma.cliente.firma.Policy"%> --%>
<%@page import="java.util.Date"%>
<%@page import="com.viafirma.examples.util.BenchMarkTimeUtils"%>
<%@page import="java.awt.Rectangle"%>
<%@page import="org.viafirma.cliente.util.Constantes"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@page import="org.viafirma.cliente.ViafirmaClientFactory"%>
<%@page import="org.viafirma.cliente.ViafirmaClient"%>
<%@page import="org.viafirma.cliente.firma.TypeFile"%>
<%@page import="org.apache.commons.io.IOUtils"%>
<%@page import="com.viafirma.examples.util.ConfigureUtil"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
		<title>Viafirma - Kit para desarrolladores</title>
		
		<link rel="stylesheet" href="../../css/framework.css" type="text/css" media="screen" />
		<link rel="stylesheet" href="../../css/styles.css" type="text/css" media="screen" />
	</head>
	<body>
		<div id="wrapper">
			<h1 id="header"><a href="../../"><img src="../../images/content/logo.png" alt="Viafirma" /></a></h1>
			
			<div id="content">
				<h2>Firmar de documento pdf con filtro de certificado</h2>
			
				<div class="group">
					<div class="col width-58 append-02">
						<div class="box">
							<h3 class="box-title">Firma de documento pdf sellado con Viafirma</h3>
							
							<div class="box-content">
								<p>En este ejemplo implementa la firma de un documento pdf sellado haciendo uso del applet de Viafirma.</p>
								
								<p class="button">
									<a href="?firmar">Firmar documento pdf de ejemplo ?no_filter</a>
								</p>
								<p class="button">
									<a href="?firmar&filter={equals}">Firmar documento pdf de ejemplo ?firmar&filter={equals}</a>
								</p>
								<p class="button">
									<a href="?firmar&filter={contains}">Firmar documento pdf de ejemplo ?firmar&filter={contains}</a>
								</p>
								<p class="button">
									<a href="?firmar&filter={starts_with}">Firmar documento pdf de ejemplo ?firmar&filter={starts_with}</a>
								</p>
								<p class="button">
									<a href="?firmar&filter={ends_with}">Firmar documento pdf de ejemplo ?firmar&filter={ends_with}</a>
								</p>
								

							</div>
						</div>
					</div>
					
					<%
									if (request.getParameter("firmar") != null) {
										ConfigureUtil.init();
										
										ViafirmaClient viafirmaClient = ViafirmaClientFactory.getInstance();
										
										// Datos documento a firmar
										byte[] datosAFirmar = IOUtils.toByteArray(getClass().getResourceAsStream("/exampleSign.pdf"));	
										byte[] logoStamp = IOUtils.toByteArray(getClass().getResourceAsStream("/stamperWatermark.png"));
										//Creamos el documento
										Documento doc = new Documento("exampleSign.pdf",datosAFirmar,TypeFile.PDF,TypeFormatSign.PAdES_BASIC);
										
										//Seteamos la politica
										Policy policy = new Policy();
										policy.setTypeFormatSign(TypeFormatSign.PAdES_BASIC);
										policy.setTypeSign(TypeSign.ATTACHED);
										policy.addParameter(PolicyParams.FILTER_CA_NAME.getKey(), "Avansi;FNMT;Catcert");
										String filterOp = request.getParameter("filter");
										if(filterOp!=null){
										    filterOp += ";";
										}else{
										    filterOp = "";
										}
										policy.addParameter(PolicyParams.FILTER_NUMBER_USER_ID.getKey(), filterOp + "53276575");
										
										// Indicamos a la plataforma que deseamos firmar el fichero
										String idFirma = viafirmaClient.prepareSignWithPolicy(policy, doc);	
										
										// Iniciamos la firma enviando al usuario a Viafirma indicando la uri de retorno.
										viafirmaClient.solicitarFirma(idFirma,request, response,"/viafirmaClientResponseServlet");
									}
								%>
					
					<div class="col width-35">
						<div class="box">
							<h3 class="box-title">Parámetros utilizados</h3>
							
							<div class="box-content">
								<ul>
									<li>TypeFormatSign</li>
									<li>TypeSign</li>
									<li>FILTER_CA_NAME</li>
									<li>FILTER_NUMBER_USER_ID</li>
								</ul>
							</div>
						</div>
					</div>
				</div>
					
				<p>
					<a href="../firmaPolicy.jsp">&larr; Volver</a>
				</p>
			
			<div id="footer">
				<p class="left">
					Acceda a <a href="http://www.viafirma.com">Viafirma</a> o consulte más información técnica en <a href="http://developers.viafirma.com/">Viafirma Developers</a> 
				</p>
				<p>
					<a href="../apiExamples/">Listado de métodos</a> - <small>2.14.1</small>
				</p>
			</div>
		</div>
	</body>
</html>