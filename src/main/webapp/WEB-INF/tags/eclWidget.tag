<%-- 
    Document   : eclWidget
    Created on : Apr 1, 2014, 3:03:22 PM
    Author     : focke
--%>

<%@tag description="eLog stuff" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<c:set var="version" value="${appVariables.etravelerELogVersion}"/>
<c:set var="eLogHome" value="${appVariables.etravelerELogUrl}"/>
<c:set var="eLogSearchPath" value="E/search"/>

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
    <tr>
        <td>
<c:url var="searchLink" value="${eLogHome}/${eLogSearchPath}">
    <c:param name="adv_text" value="${searchField}"/>
</c:url>
<a href="${searchLink}" target="_blank">Search eLog</a>
        </td>
    </tr>
    <tr>
        <td>
<form method="GET" action="fh/eclPost.jsp">
    <input type="hidden" name="referringPage" value="${thisPage}">
    <input type="hidden" name="displayLink" value="${displayLink}">
    <input type="hidden" name="author" value="${author}">
    <input type="hidden" name="hardwareTypeId" value="${hardwareTypeField}">
    <input type="hidden" name="hardwareGroupId" value="${hardwareGroupField}">
    <input type="hidden" name="hardwareId" value="${hardwareField}">
    <input type="hidden" name="processId" value="${processField}">
    <input type="hidden" name="activityId" value="${activityField}">
    <input type="hidden" name="version" value="${version}">
    <table>
        <tr>
            <td>
    <textarea name="text" required="true"></textarea>
            </td>
            <td>
                <table>
                    <tr>
                        <td>
    <select name="category" required="true">
        <option value="" selected disabled>Pick a category</option>
        <c:forEach var="category" items="${categories}">
            <option value="${category}">${category}</option>
        </c:forEach>
    </select>
                        </td>
                    </tr>
                    <tr>
                        <td>
    <input type="SUBMIT" value="Post a comment">
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</form>
        </td>
    </tr>
</table>