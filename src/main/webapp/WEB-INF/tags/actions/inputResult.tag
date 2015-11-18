<%-- 
    Document   : inputResult
    Created on : Nov 17, 2015, 4:53:26 PM
    Author     : focke
--%>

<%@tag description="Input Activity results" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="inputPatternId" required="true"%>
<%@attribute name="isName" required="true"%>
<%@attribute name="value" required="true"%>

<c:choose>
    <c:when test="${isName == 'float'}">
        <c:set var="tableName" value="FloatResultManual"/>
    </c:when>
    <c:when test="${isName == 'string'}">
        <c:set var="tableName" value="StringResultManual"/>
    </c:when>
    <c:when test="${isName == 'filepath'}">
        <c:set var="tableName" value="FilepathResultManual"/>

        <ta:registerFile activityId="${activityId}" fileItem="${fileItems.value}" mode="manual" 
                         varFsPath="fsPath" varDcPath="dcPath" varDcPk="dcPk"/>
        <%-- fileItems is put in the request by the multipart filter --%>
        <%-- File is saved in registerFile.
        Which also sets uploadedFileSize and uploadDigest at request scope
        --%>
    </c:when>                   
    <c:otherwise>
        <c:set var="tableName" value="IntResultManual"/>
    </c:otherwise>
</c:choose>
    <sql:update>
insert into ${tableName} set
inputPatternId=?<sql:param value="${inputPatternId}"/>,
activityId=?<sql:param value="${activityId}"/>,
<c:choose>
    <c:when test="${isName == 'filepath'}">
value=?<sql:param value="${fsPath}"/>,
virtualPath=?<sql:param value="${dcPath}"/>,
catalogKey=?<sql:param value="${dcPk}"/>,
size=?<sql:param value="${uploadedFileSize}"/>,
sha1=?<sql:param value="${uploadDigest}"/>,
    </c:when>
    <c:otherwise>
value=?<sql:param value="${value}"/>,
    </c:otherwise>
</c:choose>
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
    </sql:update>

