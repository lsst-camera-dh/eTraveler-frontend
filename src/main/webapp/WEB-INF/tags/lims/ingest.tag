<%-- 
    Document   : limsIngest
    Created on : Jan 21, 2014, 3:23:06 PM
    Author     : focke
--%>

<%@tag description="Ingest result summarys from the job harness" pageEncoding="UTF-8"%>
<%@tag import="com.fasterxml.jackson.databind.ObjectMapper,com.fasterxml.jackson.core.JsonParser,java.util.Map"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<c:set var="allOk" value="true"/>

<c:set var="tables" value="<%=new java.util.HashMap<String, String>()%>"/>
<traveler:mapAdd theMap="${tables}" key="java.lang.Double" value="FloatResultHarnessed"/>
<traveler:mapAdd theMap="${tables}" key="java.lang.Integer" value="IntResultHarnessed"/>
<traveler:mapAdd theMap="${tables}" key="java.lang.Boolean" value="IntResultHarnessed"/>
<traveler:mapAdd theMap="${tables}" key="java.lang.String" value="StringResultHarnessed"/>
<%
    java.util.Map<String, Integer> instances = new java.util.HashMap<String, Integer>();
    jspContext.setAttribute("instances", instances);
%>

<c:if test="${allOk}">
<%--<c:catch var="didntWork">--%>

<c:forEach var="summary" items="${inputs.result}">
    <c:set var="schemaTag" value="${summary.schema_name} v${summary.schema_version}"/>
    <%
        String sTag = jspContext.getAttribute("schemaTag").toString();
        instances.put(sTag, (instances.containsKey(sTag) ? instances.get(sTag) + 1 : 1));
    %>
    <c:choose>

        <c:when test="${summary.schema_name == 'fileref'}">
            <c:if test="${! empty summary.metadata}">
                <c:set var="mdStr" value="${summary.metadata}"/>
<%
    ObjectMapper mapper = new ObjectMapper();
    mapper.configure(JsonParser.Feature.ALLOW_NON_NUMERIC_NUMBERS, true);
    String jo = jspContext.getAttribute("mdStr").toString();
    Map<String, Object> metadata = mapper.readValue(jo, Map.class);
    jspContext.setAttribute("metadata", metadata);
%>                
            </c:if>
            
            <ta:registerFile activityId="${inputs.jobid}" name="${summary.path}" mode="harnessed" 
                             dataType="${summary.datatype}" limsMetadata="${metadata}"
                             varFsPath="fsPath" varBase="baseName" varDcPath="dcPath" varDcPk="dcPk"/>            
            <sql:update>
insert into FilepathResultHarnessed set
name='path',
value=?<sql:param value="${fsPath}"/>,
basename=?<sql:param value="${baseName}"/>,
size=?<sql:param value="${summary.size}"/>,
sha1=?<sql:param value="${summary.sha1}"/>,
virtualPath=?<sql:param value="${dcPath}"/>,
catalogKey=?<sql:param value="${dcPk}"/>,
datatype=?<sql:param value="${summary.datatype}"/>,
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

<ta:closeoutActivity activityId="${inputs.jobid}"/>

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
