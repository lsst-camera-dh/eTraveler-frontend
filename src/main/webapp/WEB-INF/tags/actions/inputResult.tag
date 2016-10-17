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
<%@attribute name="value" required="true"%>

    <sql:query var="semanticsQ">
select ISm.name, ISm.tableName
from InputPattern IP
inner join InputSemantics ISm on ISm.id = IP.inputSemanticsId
where IP.id = ?<sql:param value="${inputPatternId}"/>;
    </sql:query>
<c:set var="tableName" value="${semanticsQ.rows[0].tableName}"/>
    
<c:if test="${tableName == 'FilepathResultManual'}">
    <ta:registerFile activityId="${activityId}" fileItem="${fileItems.value}" mode="manual" 
                     varBase="baseName" varFsPath="fsPath" varDcPath="dcPath" varDcPk="dcPk"/>
    <%-- fileItems is put in the request by the multipart filter --%>
    <%-- File is saved in registerFile.
    Which also sets uploadedFileSize and uploadDigest at request scope
    --%>
</c:if>

    <sql:update>
insert into ${tableName} set
inputPatternId=?<sql:param value="${inputPatternId}"/>,
activityId=?<sql:param value="${activityId}"/>,
<c:choose>
    <c:when test="${tableName == 'FilepathResultManual'}">
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

