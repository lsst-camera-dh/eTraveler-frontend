<%-- 
    Document   : showSlots
    Created on : Aug 18, 2015, 12:50:13 PM
    Author     : focke
--%>

<%@tag description="display slots" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="processId"%>
<%@attribute name="activityId"%>

<traveler:getSlots var="slotList" activityId="${activityId}" processId="${processId}"/>

<c:if test="${! empty slotList}">
    <display:table id="row" name="${slotList}"/>
</c:if>
