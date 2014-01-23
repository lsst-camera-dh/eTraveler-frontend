<%-- 
    Document   : limsIngest
    Created on : Jan 21, 2014, 3:23:06 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%
    Integer thisInst;
    java.util.Map<String, Integer> instances = new java.util.HashMap();
    request.setAttribute("instances", instances);
%>

<c:forEach var="summary" items="${inputs.result}">
    <c:set var="instanceTag" value="${summary.schema_name} v${summary.schema_version}" scope="request"/>
    <%
        String iTag = request.getAttribute("instanceTag").toString();
        if (instances.containsKey(iTag)) {
            thisInst = instances.get(iTag) + 1;
        } else {
            thisInst = 1;       
        }
        instances.put(iTag, thisInst);
    %>
    <c:choose>
        <c:when test="${summary.schema_name == 'fileref'}">
            <sql:update>
insert into FilepathResultHarnessed set
name='path',
value=?<sql:param value="${summary.path}"/>,
size=?<sql:param value="${summary.size}"/>,
sha1=?<sql:param value="${summary.sha1}"/>,
schemaName=?<sql:param value="${summary.schema_name}"/>,
schemaVersion=?<sql:param value="${summary.schema_version}"/>,
schemaInstance=?<sql:param value="${instances[instanceTag]}"/>,
activityId=?<sql:param value="${inputs.jobid}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=NOW();
            </sql:update>
        </c:when>
        <c:otherwise>
            <c:forEach var="fieldName" items="${summary.keySet()}">
                <c:set var="fieldValue" value="${summary.get(fieldName)}"/>
                <c:set var="fieldType" value="${fieldValue.getClass().getName()}"/>
                <c:choose>
                    <c:when test="${fieldName == 'schema_name' || fieldName == 'schema_version'}">
                        <%-- nothing --%>
                    </c:when>
                    <c:otherwise>
                        <c:choose>
                            <c:when test="${fieldType == 'java.lang.Double'}">
                                <c:set var="table" value="FloatResultHarnessed"/>
                            </c:when>
                            <c:when test="${fieldType == 'java.lang.Integer'}">
                                <c:set var="table" value="IntResultHarnessed"/>
                            </c:when>
                            <c:when test="${fieldType == 'java.lang.String'}">
                                <c:set var="table" value="StringResultHarnessed"/>
                            </c:when>
                        </c:choose>
                        <sql:update>
insert into ${table} set
name=?<sql:param value="${fieldName}"/>,
value=?<sql:param value="${fieldValue}"/>,
schemaName=?<sql:param value="${summary.schema_name}"/>,
schemaVersion=?<sql:param value="${summary.schema_version}"/>,
schemaInstance=?<sql:param value="${instances[instanceTag]}"/>,
activityId=?<sql:param value="${inputs.jobid}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=NOW();
                        </sql:update>
                    </c:otherwise>
                </c:choose>
            </c:forEach> <%-- field --%>
                </c:otherwise>
    </c:choose>
</c:forEach> <%-- summary --%>
{"acknowledge": null}
