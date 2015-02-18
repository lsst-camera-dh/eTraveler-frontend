<%-- 
    Document   : datacatPath
    Created on : Jan 26, 2015, 4:15:20 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib uri="/tlds/dcTagLibrary.tld" prefix="dc"%>

<%@attribute name="resultId" required="true"%>
<%@attribute name="mode" required="true"%>

<c:choose>
    <c:when test="${mode == 'manual'}">
        <c:set var="resultTable" value="FilepathResultManual"/>
        <c:set var="modePath" value="eTravelerFiles"/>
    </c:when>
    <c:when test="${mode == 'harnessed'}">
        <c:set var="resultTable" value="FilepathResultHarnessed"/>
        <c:set var="modePath" value="mirror"/>
    </c:when>
    <c:otherwise>
        AAAaaack!!!! #220560
    </c:otherwise>
</c:choose>

<sql:query var="resultQ">
    select
        R.value as fileName,
        A.id as activityId,
        P.name as processName, P.userVersionString,
        H.id as hardwareId, H.lsstId, 
        HT.name as hardwareTypeName
    from
        ${resultTable} as R
        inner join Activity A on A.id=R.activityId
        inner join Process P on P.id=A.processId
        inner join Hardware H on H.id=A.hardwareId
        inner join HardwareType HT on HT.id=H.hardwareTypeId
    where
        R.id=?<sql:param value="${resultId}"/>
    ;
</sql:query>
<c:set var="result" value="${resultQ.rows[0]}"/>

<%-- dataCatalogDb --%>
<c:set var="dataCatalogDb" value="${appVariables.dataCatalogDb}"/>

<%-- name --%>
<c:set var="name" value="${result.fileName}"/>

<%-- fileFormat --%>
<c:set var="fnComponents" value="${fn:split(name, '.')}"/>
<c:set var="fileExt" value="${fnComponents[fn:length(fnComponents)-1]}"/>
<c:set var="fileFormat" value="${fileExt == name ? 'UNKNOWN' : fileExt}"/>

<%-- dataType --%>
<c:set var="dataType" value="LSSTSENSORTEST"/>

<%-- logicalFolderPath --%>

<sql:query var="hwSiteQ">
    select S.name as siteName, S.jhOutputRoot from 
    Hardware H
    inner join HardwareLocationHistory HLH on HLH.hardwareId=H.id
    inner join Location L on L.id=HLH.locationId
    inner join Site S on S.id=L.siteId
    where H.id=?<sql:param value="${result.hardwareId}"/>
    order by HLH.creationTS desc limit 1;
</sql:query>
<c:choose>
    <c:when test="${! empty hwSiteQ.rows}">
        <c:set var="site" value="${hwSiteQ.rows[0]}"/>
        <c:set var="siteName" value="${site.siteName}"/>
        <c:set var="jhOutputRoot" value="${site.jhOutputRoot}"/>
    </c:when>
</c:choose>
<sql:query var="userSiteQ">
    select S.jhOutputRoot from Site S where S.name=?<sql:param value="${siteName}"/>
</sql:query>
<c:if test="${empty siteName}">
    <c:set var="siteName" value="broeknSite"/>
    <c:url var="errorPage" value="error.jsp">
        <c:param name="message" value="The component has no location and user ${userName} has no site."/>
    </c:url>
</c:if>

<%-- <c:set var="version" value="${empty result.userVersionString ? '' : '/' + result.userVersionString}"/> --%>
<c:choose>
    <c:when test="${empty result.userVersionString}">
        <c:set var="processVersion" value=""/>
    </c:when>
    <c:otherwise>
        <c:set var="processVersion" value="/${result.userVersionString}"/>
    </c:otherwise>
</c:choose>

<c:set var="dcHead" value="/LSST/${modePath}/${siteName}"/>

<c:set var="commonPath" value=
"${result.hardwareTypeName}/${result.lsstId}/${result.processName}${processVersion}/${result.activityId}"
/>

<c:set var="logicalFolderPath" value="${dcHead}/${commonPath}"/>

<%-- groupName --%>
<c:set var="groupName" value="null"/>

<%-- site, location --%>
<c:choose>
    <c:when test="${mode=='harnessed'}">
        <c:set var="dcSite" value="${siteName}"/>
        <c:set var="fsHead" value="${site.jhOutputRoot}"/>
    </c:when>
    <c:when test="${mode=='manual'}">
        <c:set var="dcSite" value="SLAC"/>
        <c:set var="fsHead" value="${initParam['eTravelerFileStore']}/${modePath}/${siteName}"/>
    </c:when>
</c:choose>
<c:set var="location" value="${fsHead}/${commonPath}/${result.fileName}"/>

<%-- replaceExisting --%>
<c:set var="replaceExisting" value="false"/>

<c:if test="${not param.terse}">
<br>
dataCatalogDb: <c:out value="${dataCatalogDb}"/><br>
name: <c:out value="${name}"/><br>
fileFormat: <c:out value="${fileFormat}"/><br>
dataType: <c:out value="${dataType}"/><br>
logicalFolderPath: <c:out value="${logicalFolderPath}"/><br>
groupName: <c:out value="${groupName}"/><br>
site: <c:out value="${dcSite}"/><br>
location: <c:out value="${location}"/><br>
replaceExisting: <c:out value="${replaceExisting}"/><br>
</c:if>
<c:if test="${param.xxx}">
<dc:dcRegister dataCatalogDb="${dataCatalogDb}"
    name="${filePath}" fileFormat="${fileFormat}" dataType="${dataType}"
               logicalFolderPath="${logicalFolderPath}" groupName="${groupName}"
               site="${dcSite}" location="${location}" replaceExisting="${replaceExisting}"/>
</c:if>

