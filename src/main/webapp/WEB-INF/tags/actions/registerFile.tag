<%-- 
    Document   : registerFile
    Created on : Jan 26, 2015, 4:15:20 PM
    Author     : focke
--%>

<%@tag description="Register a file in the data catalog" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="dc" uri="/tlds/dcTagLibrary.tld"%>
<%@taglib prefix="upload" uri="/tlds/uploads.tld"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="fileItem" type="org.apache.commons.fileupload.FileItem"%>
<%@attribute name="name"%>
<%@attribute name="mode" required="true"%>
<%@attribute name="varFsPath" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varFsPath" alias="fullFsPath" scope="AT_BEGIN"%>
<%@attribute name="varDcPath" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varDcPath" alias="fullVirtualPath" scope="AT_BEGIN"%>
<%@attribute name="varDcPk" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varDcPk" alias="dcPk" scope="AT_BEGIN"%>
<%@attribute name="dataType"%>

<c:choose>
    <c:when test="${mode == 'manual'}">
        <c:set var="modePath" value="${initParam['uploadedSubfolder']}"/>
    </c:when>
    <c:when test="${mode == 'harnessed'}">
        <c:set var="modePath" value="${initParam['mirroredSubfolder']}"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="AAAaaack!!!! #220560" bug="true"/>
    </c:otherwise>
</c:choose>

<sql:query var="activityQ">
    select
        A.id as activityId,
        P.id as processId, P.name as processName, P.userVersionString,
        H.id as hardwareId, H.lsstId, 
        HT.id as hardwareTypeId, HT.name as hardwareTypeName,
        HG.id as hardwareGroupId, HG.name as hardwareGroupName
    from
        Activity A
        inner join Process P on P.id=A.processId
        inner join Hardware H on H.id=A.hardwareId
        inner join HardwareType HT on HT.id=H.hardwareTypeId
        inner join HardwareGroup HG on HG.id=P.hardwareGroupId
    where
        A.id=?<sql:param value="${activityId}"/>
    ;
</sql:query>
<c:set var="activity" value="${activityQ.rows[0]}"/>

<%--
<traveler:mapCreate var="metaData"/>
<traveler:mapAdd theMap="${metaData}" key="nActivityId" value="${activityId}"/>
<traveler:mapAdd theMap="metaData" key="nProcessId" value="${activity.processId}"/>
<traveler:mapAdd theMap="metaData" key="" value=""/>
<traveler:mapAdd theMap="metaData" key="nHardwareId" value="${activity.hardwareId}"/>
<traveler:mapAdd theMap="metaData" key="" value=""/>
<traveler:mapAdd theMap="metaData" key="nHardwareTypeId" value="${activity.hardwareTypeId}"/>
<traveler:mapAdd theMap="metaData" key="" value=""/>
<traveler:mapAdd theMap="metaData" key="nHardwareGroupId" value="${activity.hardwareGroupId}"/>
<traveler:mapAdd theMap="metaData" key="" value=""/>
<traveler:mapAdd theMap="metaData" key="" value=""/>
--%>

<%-- dataCatalogDb --%>
<c:set var="dataCatalogDb" value="${appVariables.dataCatalogDb}"/>

<%-- file Name, Format --%>
<c:choose>
    <c:when test="${mode == 'manual'}">
<upload:uploadParser fileItem="${fileItem}" varName="name" varFormat="fileFormat" varSize="fs" varSha1="digest"/>
<c:if test="${empty fileFormat}"><c:set var="fileFormat" value="unspecified"/></c:if>
<c:set var="uploadedFileSize" value="${fs}" scope="request"/>
<c:set var="uploadDigest" value="${digest}" scope="request"/>
    </c:when>
    <c:when test="${mode == 'harnessed'}">
<c:set var="fnComponents" value="${fn:split(name, '.')}"/>
<c:set var="fileExt" value="${fnComponents[fn:length(fnComponents)-1]}"/>
<c:set var="fileFormat" value="${fileExt == name ? 'unspecified' : fileExt}"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="AAAaaack!!!! #220561" bug="true"/>
    </c:otherwise>
</c:choose>

<%-- dataType --%>
<c:if test="${empty dataType}">
    <c:set var="dataType" value="${initParam['defaultDataType']}"/>
</c:if>

<%-- logicalFolderPath --%>

<sql:query var="hwSiteQ">
    select S.name as siteName, S.jhOutputRoot from 
    Hardware H
    inner join HardwareLocationHistory HLH on HLH.hardwareId=H.id
    inner join Location L on L.id=HLH.locationId
    inner join Site S on S.id=L.siteId
    where H.id=?<sql:param value="${activity.hardwareId}"/>
    order by HLH.id desc limit 1;
</sql:query>
<c:choose>
    <c:when test="${! empty hwSiteQ.rows}">
        <c:set var="site" value="${hwSiteQ.rows[0]}"/>
        <c:set var="siteName" value="${site.siteName}"/>
        <c:set var="jhOutputRoot" value="${site.jhOutputRoot}"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="Component ${activity.lsstId} has no location."/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${empty activity.userVersionString}">
        <c:set var="processVersion" value=""/>
    </c:when>
    <c:otherwise>
        <c:set var="processVersion" value="/${activity.userVersionString}"/>
    </c:otherwise>
</c:choose>

<c:choose>
    <c:when test="${'Prod' == appVariables.dataSourceMode}">
        <c:set var="dataSourceFolder" value=""/>
    </c:when>
    <c:otherwise>
        <c:set var="dataSourceFolder" value="/${appVariables.dataSourceMode}"/>
    </c:otherwise>
</c:choose>

<c:set var="dcHead" value="${initParam['datacatFolder']}${dataSourceFolder}/${modePath}/${siteName}"/>

<c:set var="commonPath" value=
"${activity.hardwareTypeName}/${activity.lsstId}/${activity.processName}${processVersion}/${activityId}"
/>

<c:set var="logicalFolderPath" value="${dcHead}/${commonPath}"/>

<%-- groupName --%>
<c:set var="groupName" value="null"/>

<%-- site, fullFsPath --%>
<c:choose>
    <c:when test="${mode=='harnessed'}">
        <c:set var="dcSite" value="${siteName}"/>
        <c:set var="fsHead" value="${site.jhOutputRoot}"/>
    </c:when>
    <c:when test="${mode=='manual'}">
        <c:set var="dcSite" value="SLAC"/>
        <c:set var="fsHead" value="${initParam['eTravelerFileStore']}${dataSourceFolder}/${siteName}"/>
    </c:when>
</c:choose>
<c:set var="fullFsPath" value="${fsHead}/${commonPath}/${name}"/>

<%-- replaceExisting --%>
<c:set var="replaceExisting" value="false"/>

<c:set var="doRegister" value="true"/>
<c:if test="${not doRegister}">
<br>
dataCatalogDb: <c:out value="${dataCatalogDb}"/><br>
name: <c:out value="${name}"/><br>
fileFormat: <c:out value="${fileFormat}"/><br>
dataType: <c:out value="${dataType}"/><br>
logicalFolderPath: <c:out value="${logicalFolderPath}"/><br>
groupName: <c:out value="${groupName}"/><br>
site: <c:out value="${dcSite}"/><br>
location: <c:out value="${fullFsPath}"/><br>
replaceExisting: <c:out value="${replaceExisting}"/><br>
</c:if>
<c:if test="${doRegister}">
    <c:if test="${mode == 'manual'}">
        <upload:uploadSaver path="${fullFsPath}" fileItem="${fileItem}"/>
    </c:if>
    <dc:dcRegister dataCatalogDb="${dataCatalogDb}"
        name="${name}" fileFormat="${fileFormat}" dataType="${dataType}"
                   logicalFolderPath="${logicalFolderPath}" 
                   site="${dcSite}" location="${fullFsPath}" replaceExisting="${replaceExisting}"
                   var="dcPk"/>
</c:if>
<c:set var="fullVirtualPath" value="${logicalFolderPath}/${name}"/>
