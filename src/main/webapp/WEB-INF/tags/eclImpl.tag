<%-- 
    Document   : eclWidget
    Created on : Apr 1, 2014, 3:03:22 PM
    Author     : focke
--%>

<%@tag description="eLog stuff" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib uri="/tlds/eclTagLibrary.tld" prefix="ecl"%>

<%@attribute name="author" required="true"%>
<%@attribute name="hardwareTypeId"%>
<%@attribute name="hardwareGroupId"%>
<%@attribute name="hardwareId"%>
<%@attribute name="processId"%>
<%@attribute name="activityId"%>

<traveler:fullRequestString var="thisPage"/>

<h2>Electronic Logbook</h2>

<ecl:eclCategories var="categories" version="${appVariables.etravelerELogVersion}" url="${appVariables.etravelerELogUrl}"/>
<ecl:eclTags var="tags" version="${appVariables.etravelerELogVersion}" url="${appVariables.etravelerELogUrl}"/>

<c:set var="version" value="${appVariables.etravelerELogVersion}"/>
<c:set var="eLogHome" value="${appVariables.etravelerELogUrl}"/>
<c:set var="eLogSearchPath" value="E/search"/>
<c:set var="eLogShowPath" value="E/show"/>

<c:set var="activityField" value="activityId${! empty activityId ? activityId : 0}"/>
<c:set var="processField" value="processId${! empty processId ? processId : 0}"/>
<c:set var="hardwareField" value="hardwareId${! empty hardwareId ? hardwareId : 0}"/>
<c:set var="hardwareTypeField" value="hardwareTypeId${! empty hardwareTypeId ? hardwareTypeId : 0}"/>
<c:set var="hardwareGroupField" value="hardwareGroupId${! empty hardwareGroupId ? hardwareGroupId : 0}"/>

<c:choose>
    <c:when test="${! empty activityId}">
        <c:set var="page" value="displayActivity.jsp"/>
        <c:set var="paramName" value="activityId"/>
        <c:set var="paramValue" value="${activityId}"/>
        <c:set var="searchField" value="${activityField}"/>
    </c:when>
    <c:when test="${! empty processId}">
        <c:set var="page" value="displayProcess.jsp"/>
        <c:set var="paramName" value="processPath"/>
        <c:set var="paramValue" value="${processId}"/>
        <c:set var="searchField" value="${processField}"/>
    </c:when>
    <c:when test="${! empty hardwareGroupId}">
        <c:set var="page" value="displayHardwareGroup.jsp"/>            
        <c:set var="paramName" value="hardwareGroupId"/>
        <c:set var="paramValue" value="${hardwareGroupId}"/>
        <c:set var="searchField" value="${hardwareGroupField}"/>
    </c:when>
    <c:when test="${! empty hardwareId}">
        <c:set var="page" value="displayHardware.jsp"/>
        <c:set var="paramName" value="hardwareId"/>
        <c:set var="paramValue" value="${hardwareId}"/>
        <c:set var="searchField" value="${hardwareField}"/>
   </c:when>
    <c:when test="${! empty hardwareTypeId}">
        <c:set var="page" value="displayHardwareType.jsp"/>            
        <c:set var="paramName" value="hardwareTypeId"/>
        <c:set var="paramValue" value="${hardwareTypeId}"/>
        <c:set var="searchField" value="${hardwareTypeField}"/>
    </c:when>
    <c:otherwise>
        <traveler:error message="Bug 098653" bug="true"/>
    </c:otherwise>
</c:choose>

<traveler:fullContext var="fullContext"/>
<c:url var="displayUrl" value="${fullContext}/${page}">
    <c:param name="${paramName}" value="${paramValue}"/>
    <c:param name="dataSourceMode" value="${appVariables.dataSourceMode}"/>
</c:url>
<c:set var="displayLink" value="<a href='${displayUrl}' target='_blank'>eTraveler</a>"/>

<table border="1">
  <%--      Get rid of general eLog search, requiring log-in  --%>

<%--  The next section looks up relevant entries in eLog and displays them --%>
<ecl:eclSearch var="entries" version="${appVariables.etravelerELogVersion}" url="${appVariables.etravelerELogUrl}"
               query="si=${searchField}"/>

<c:forEach var="entry" items="${entries}">
    <c:set var="text" value="${fn:replace(entry.text, displayLink, '')}"/>
    <c:url var="entryLink" value="${eLogHome}/${eLogShowPath}">
        <c:param name="e" value="${entry.id}"/>
    </c:url>
    <tr>
        <td>
    <a href="${entryLink}" target='_blank'>${entry.timestamp} ${entry.author}</a>:
    ${text}
        </td>
    </tr>
</c:forEach>

<%-- Final section was for posting new comments.  Get rid of it  --%>
</table>
