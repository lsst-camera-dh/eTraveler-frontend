<%-- 
    Document   : closeoutRelation
    Created on : Aug 17, 2015, 5:11:26 PM
    Author     : focke
--%>

<%@tag 
    description="This does not (neccessarily) end a MultiRelationship. It does whatever MR action is needed at Activity closeout" 
    pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="activityId" required="true"%>

<relationships:findUndoneActions var="actionsQ" activityId="${activityId}"/>

<c:forEach var="action" items="${actionsQ.rows}">
    <relationships:getSlotStatus var="status" varId="minorId" slotId="${action.slotId}"/>
    <c:if test="${action.name == 'assign' || status == 'free'}">
        <traveler:error message="Relationship closeout error: nothing assigned." bug="true"/>
    </c:if>
    <relationships:updateRelationship slotId="${action.slotId}" 
                                      minorId="${minorId}" 
                                      action="${action.name}" 
                                      activityId="${activityId}"/>
</c:forEach>