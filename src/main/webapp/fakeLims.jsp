<%-- 
    Document   : fakeLims
    Created on : Oct 2, 2013, 2:40:55 PM
    Author     : focke
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<%-- for all: check if jobid matches an active JH Actifity --%>

<c:choose>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/requestID')}">
        <%-- get prereqs, return them --%>
{
    "jobid": null,
    "error": "requestID doesn't work yet."
}
    </c:when>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/update')}">
        <%-- stick a record in JobStepHistory --%>
{
    "acknowledge": "update doesn't work yet."
}
    </c:when>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/ingest')}">
        <%-- ??? --%>
{
    "acknowledge": "ingest doesn't work yet."        
}
    </c:when>
    <c:when test="${fn:endsWith(pageContext.request.requestURI, '/status')}">
{
    "error": "status doesn't work yet."
}
    </c:when>
    <c:otherwise>
Bad command
    </c:otherwise>
</c:choose>
