<%-- 
    Document   : dcLinks
    Created on : Oct 17, 2017, 4:13:16 PM
    Author     : focke
--%>

<%@tag description="Provide data catalog links for file results" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@attribute name="datasetPk" required="true"%>
<%@attribute name="localPath" required="true"%>

<c:url var="dcLink" value="http://srs.slac.stanford.edu/DataCatalog/dataset.jsp">
    <c:param name="dataset" value="${datasetPk}"/>
    <c:param name="experiment" value="${appVariables.experiment}"/>
</c:url>
<a href="${dcLink}" target="_blank">${localPath}</a>
<br>
<c:url var="dlLink" value="http://srs.slac.stanford.edu/DataCatalog/get">
    <c:param name="dataset" value="${datasetPk}"/>
    <c:param name="experiment" value="${appVariables.experiment}"/>
</c:url>
<a href="${dlLink}">Download</a>
