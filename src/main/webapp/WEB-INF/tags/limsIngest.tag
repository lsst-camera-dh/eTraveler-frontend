<%-- 
    Document   : limsIngest
    Created on : Jan 21, 2014, 3:23:06 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%
    java.util.Map<String, String> tables = new java.util.HashMap<String, String>();
    tables.put("java.lang.Double", "FloatResultHarnessed");
    tables.put("java.lang.Integer", "IntResultHarnessed");
    tables.put("java.lang.String", "StringResultHarnessed");
    request.setAttribute("tables", tables);

    java.util.Map<String, Integer> instances = new java.util.HashMap<String, Integer>();
    request.setAttribute("instances", instances);
%>

<c:catch var="didntWork">
<sql:transaction>

<c:forEach var="summary" items="${inputs.result}">
    <c:set var="schemaTag" value="${summary.schema_name} v${summary.schema_version}" scope="request"/>
    <%
        String sTag = request.getAttribute("schemaTag").toString();
        instances.put(sTag, (instances.containsKey(sTag) ? instances.get(sTag) + 1 : 1));
    %>
    <c:choose>

        <c:when test="${summary.schema_name == 'fileref'}">
            <sql:update>
insert into FilepathResultHarnessed set
name='path',
value=?<sql:param value="${summary.path}"/>,
size=?<sql:param value="${summary.size}"/>,
sha1=?<sql:param value="${summary.sha1}"/>,
schemaName='fileref',
schemaVersion=?<sql:param value="${summary.schema_version}"/>,
schemaInstance=?<sql:param value="${instances[schemaTag]}"/>,
activityId=?<sql:param value="${inputs.jobid}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=NOW();
            </sql:update>
        </c:when>

        <c:otherwise>
            <c:forEach var="fieldName" items="${summary.keySet()}">
                <c:if test="${fieldName != 'schema_name' && fieldName != 'schema_version'}">
                    <c:set var="fieldValue" value="${summary.get(fieldName)}"/>
                    <c:set var="fieldType" value="${fieldValue.getClass().getName()}"/>
                    <sql:update>
insert into ${tables[fieldType]} set
name=?<sql:param value="${fieldName}"/>,
value=?<sql:param value="${fieldValue}"/>,
schemaName=?<sql:param value="${summary.schema_name}"/>,
schemaVersion=?<sql:param value="${summary.schema_version}"/>,
schemaInstance=?<sql:param value="${instances[schemaTag]}"/>,
activityId=?<sql:param value="${inputs.jobid}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=NOW();
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
    creationTS=now();
</sql:update>
<sql:update >
    update Activity set 
    activityFinalStatusId=(select id from ActivityFinalStatus where name='success'),
    end=now(), 
    closedBy=?<sql:param value="${userName}"/>
    where 
    id=?<sql:param value="${inputs.jobid}"/>;
</sql:update>

</sql:transaction>
</c:catch>

<c:choose>
    <c:when test="${empty didntWork}">
        {"acknowledge": null}
    </c:when>
    <c:otherwise>
        {"acknowledge": "Ingest error"}
    </c:otherwise>
</c:choose>
