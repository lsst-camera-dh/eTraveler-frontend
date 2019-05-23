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
<%@attribute name="limsMetadata" type="java.util.Map"%>
<%@attribute name="mode" required="true"%>
<%@attribute name="varBase" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="varBase" alias="baseName" scope="AT_BEGIN"%>
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
	P.jobname as processJobname,
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

<c:set var="dcMetadata" value="<%=new java.util.HashMap()%>"/>
<traveler:mapAdd theMap="${dcMetadata}" key="ActivityId" value="${activityId}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="ProcessId" value="${activity.processId}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="ProcessName" value="${activity.processName}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="HardwareId" value="${activity.hardwareId}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="LsstId" value="${activity.lsstId}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="HardwareTypeId" value="${activity.hardwareTypeId}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="HardwareTypeName" value="${activity.hardwareTypeName}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="HardwareGroupId" value="${activity.hardwareGroupId}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="HardwareGroupName" value="${activity.hardwareGroupName}"/>
<traveler:mapAdd theMap="${dcMetadata}" key="DataSourceMode" value="${appVariables.dataSourceMode}"/>
<c:if test="${mode == 'harnessed' && ! empty limsMetadata}">
    <c:forEach var="metaItem" items="${limsMetadata}">
        <traveler:mapAdd theMap="${dcMetadata}" key="${metaItem.key}" value="${metaItem.value}"/>
    </c:forEach>
</c:if>

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
        <c:choose>
            <c:when test="${fn:contains(name, '/')}">
                <upload:jhParser jhName="${name}" varPath="jhSubPath" varName="name"/>
            </c:when>
            <c:otherwise>
                <c:set var="jhSubPath" value=""/>
            </c:otherwise>
        </c:choose>
<c:set var="baseName" value="${name}"/>
<c:set var="fnComponents" value="${fn:split(name, '.')}"/>
<c:set var="fileExt" value="${fn:toLowerCase(fnComponents[fn:length(fnComponents)-1])}"/>
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

<c:choose>
    <c:when test="${mode == 'harnessed'}">
        <sql:query var="jhSiteQ">
select S.name as siteName, JH.jhOutputRoot from 
Activity A
inner join JobHarness JH on JH.id=A.jobHarnessId
inner join Site S on S.id=JH.siteId
where A.id=?<sql:param value="${activityId}"/>
;
        </sql:query>
        <c:choose>
            <c:when test="${! empty jhSiteQ.rows}">
                <c:set var="site" value="${jhSiteQ.rows[0]}"/>
                <c:set var="siteName" value="${site.siteName}"/>
                <c:set var="jhOutputRoot" value="${site.jhOutputRoot}"/>
            </c:when>
            <c:otherwise>
                <traveler:error message="Cannot resolve Job Harness info."/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:set var="siteName" value="SLAC"/>
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
        <c:set var="dataSourceFolder" value="prod"/>
    </c:when>
    <c:when test="${'Dev' == appVariables.dataSourceMode}">
        <c:set var="dataSourceFolder" value="test"/>
    </c:when>
    <c:otherwise>
        <c:set var="dataSourceFolder" value="noise"/>
    </c:otherwise>
</c:choose>

<c:set var="dcHead" value="${appVariables.etravelerDatacatRoot}/${modePath}/${siteName}-${dataSourceFolder}/${dataSourceFolder}"/>

<traveler:findRun varRun="runNumber" varTraveler="runTraveler" activityId="${activityId}"/>

<c:choose>
    <c:when test="${mode == 'harnessed'}">
        <c:set var="commonPath" value=
"${activity.hardwareTypeName}/${activity.lsstId}/${runNumber}/${activity.processJobname}${processVersion}/${activityId}" />
    </c:when>
    <c:otherwise>
        <c:set var="commonPath" value=
"${activity.hardwareTypeName}/${activity.lsstId}/${runNumber}/${activity.processName}${processVersion}/${activityId}" />
    </c:otherwise>
</c:choose>
<c:if test="${mode == 'harnessed' && ! empty jhSubPath}">
    <c:set var="commonPath" value="${commonPath}/${jhSubPath}"/>
</c:if>


<c:set var="logicalFolderPath" value="${dcHead}/${commonPath}"/>

<%-- groupName --%>
<c:set var="groupName" value="null"/>

<%-- site, fullFsPath --%>
<c:set var="dcSite" value="${siteName}"/>
<c:choose>
    <c:when test="${mode=='harnessed'}">
        <c:set var="fsHead" value="${site.jhOutputRoot}"/>
    </c:when>
    <c:when test="${mode=='manual'}">
        <c:set var="fsHead" value="${appVariables.etravelerFileStore}/${initParam['eTravelerFileSubfolder']}/${dataSourceFolder}/${siteName}"/>
    </c:when>
</c:choose>
<c:set var="fullFsPath" value="${fsHead}/${commonPath}/${name}"/>

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
</c:if>
<c:if test="${doRegister}">
    <c:if test="${mode == 'manual'}">
        <c:catch var="ex">
            <upload:uploadSaver path="${fullFsPath}" fileItem="${fileItem}"/>
        </c:catch>
        <c:if test="${!empty ex}">
            <traveler:error message="Couldn't save file ${fullFsPath}."/>
        </c:if>
    </c:if>
<%--    <c:catch var="ex">--%>
        <dc:dcRegister 
            name="${name}" fileFormat="${fileFormat}" dataType="${dataType}"
            logicalFolderPath="${logicalFolderPath}" 
            site="${dcSite}" location="${fullFsPath}" 
            var="dcPk" metadata="${dcMetadata}"/>
<%--    </c:catch>>--%>
    <c:if test="${!empty ex}">
        <traveler:error message="Couldn't register file ${fullFsPath}.<br>
Perhaps the file format (${fileFormat}) is not on the data catalog's list?<br>
Check <a href='https://srs.slac.stanford.edu/DataCatalog/datasetfileformat.jsp' target='_'>here</a>.
${ex} ${ex.cause}"/>
    </c:if>
</c:if>
<c:set var="fullVirtualPath" value="${logicalFolderPath}/${name}"/>
