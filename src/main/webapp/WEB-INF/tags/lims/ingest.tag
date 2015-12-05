<%-- 
    Document   : limsIngest
    Created on : Jan 21, 2014, 3:23:06 PM
    Author     : focke
--%>

<%@tag description="Ingest result summarys from the job harness" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<c:set var="allOk" value="true"/>

<%
    java.util.Map<String, String> tables = new java.util.HashMap<String, String>();
    tables.put("java.lang.Double", "FloatResultHarnessed");
    tables.put("java.lang.Integer", "IntResultHarnessed");
    tables.put("java.lang.Boolean", "IntResultHarnessed");
    tables.put("java.lang.String", "StringResultHarnessed");
    request.setAttribute("tables", tables);

    java.util.Map<String, Integer> instances = new java.util.HashMap<String, Integer>();
    request.setAttribute("instances", instances);
%>

<c:if test="${allOk}">
<%--<c:catch var="didntWork">--%>

<c:forEach var="summary" items="${inputs.result}">
    <c:set var="schemaTag" value="${summary.schema_name} v${summary.schema_version}" scope="request"/>
    <%
        String sTag = request.getAttribute("schemaTag").toString();
        instances.put(sTag, (instances.containsKey(sTag) ? instances.get(sTag) + 1 : 1));
    %>
    <c:choose>

        <c:when test="${summary.schema_name == 'fileref'}">
            <ta:registerFile activityId="${inputs.jobid}" name="${summary.path}" mode="harnessed" 
                             dataType="${summary.datatype}"
                             varFsPath="fsPath" varDcPath="dcPath" varDcPk="dcPk"/>            
            <sql:update>
insert into FilepathResultHarnessed set
name='path',
value=?<sql:param value="${fsPath}"/>,
size=?<sql:param value="${summary.size}"/>,
sha1=?<sql:param value="${summary.sha1}"/>,
virtualPath=?<sql:param value="${dcPath}"/>,
catalogKey=?<sql:param value="${dcPk}"/>,
schemaName='fileref',
schemaVersion=?<sql:param value="${summary.schema_version}"/>,
schemaInstance=?<sql:param value="${instances[schemaTag]}"/>,
activityId=?<sql:param value="${inputs.jobid}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
            </sql:update>
        </c:when>

        <c:otherwise>
            <c:forEach var="fieldName" items="${summary.keySet()}">
                <c:set var="goodData" value="true"/>
                <c:if test="${fieldName != 'schema_name' && fieldName != 'schema_version'}">
                    <c:set var="fieldValue" value="${summary.get(fieldName)}"/>
                    <c:set var="fieldType" value="${fieldValue.getClass().getName()}"/>
                    <c:if test="${fieldType == 'java.lang.Double' && fieldValue.isNaN()}">
                        <c:set var="goodData" value="false"/>
                    </c:if>
                    <c:if test="${! tables.containsKey(fieldType)}">
                        <traveler:error message="Invalid data type ${fieldType}"/>
                    </c:if>
                    <sql:update>
insert into ${tables[fieldType]} set
name=?<sql:param value="${fieldName}"/>,
<c:if test="${goodData}">
value=?<sql:param value="${fieldValue}"/>,
</c:if>
schemaName=?<sql:param value="${summary.schema_name}"/>,
schemaVersion=?<sql:param value="${summary.schema_version}"/>,
schemaInstance=?<sql:param value="${instances[schemaTag]}"/>,
activityId=?<sql:param value="${inputs.jobid}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=UTC_TIMESTAMP();
                    </sql:update>
                </c:if>
            </c:forEach> <%-- fieldName --%>
        </c:otherwise>

    </c:choose>
</c:forEach> <%-- summary --%>

<sql:update >
    insert into JobStepHistory set
    jobHarnessStepId=(select id from JobHarnessStep where name='ingested'),
    activityId=?<sql:param value="${inputs.jobid}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=UTC_TIMESTAMP();
</sql:update>

<ta:setActivityStatus activityId="${inputs.jobid}" status="success"/>

<%--</c:catch>--%>

</c:if>
    
<c:choose>
    <c:when test="${allOk && empty didntWork}">
        {"acknowledge": null}
    </c:when>
    <c:otherwise>
        {"acknowledge": "Ingest error"}
    </c:otherwise>
</c:choose>
