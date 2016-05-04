<%-- 
    Document   : closeoutRelation
    Created on : Aug 17, 2015, 5:11:26 PM
    Author     : focke
--%>

<%@tag 
    description="This does not (neccessarily) end a MultiRelationship. It does whatever MR action is needed at Activity closeout" 
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

<traveler:getActivitySlots activityId="${activityId}" var="slotList"/>

<c:forEach var="slot" items="${slotList}">
    <c:if test="${(slot.intName == 'install') || (slot.intName == 'uninstall')}">
        <ta:updateRelationship slotId="${slot.mrsId}" action="${slot.intName}" activityId="${activityId}"/>
    </c:if>
</c:forEach>