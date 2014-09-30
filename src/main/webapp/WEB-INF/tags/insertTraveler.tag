<%-- 
    Document   : expandTraveler
    Created on : Sep 18, 2014, 11:30:34 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="activityId" required="true"%>
<%@attribute name="theList" required="true" type="java.util.List"%>
<%@attribute name="startEdgePath"%>
<%@attribute name="startTime"%>
<%@attribute name="processSteps" type="java.util.List"%>

<c:if test="${empty processSteps}">
    <sql:query var="processQ">
        select processId from Activity where id=?<sql:param value="${activityId}"/>
    </sql:query>
    <traveler:stepList theId="${processQ.rows[0].processId}" mode="process" var="processSteps"/>
</c:if>
    
<c:set var="loopState" value="pre"/>
<c:forEach items="${processSteps}" var="stepRow">
    <c:if test="${loopState=='pre' && stepRow.edgePath==startEdgePath}">
        <c:set var="loopState" value="active"/>
    </c:if>
    <c:choose>
        <c:when test="${loopState=='pre'}"><%-- noop --%></c:when>
        <c:when test="${loopState=='active'}">
            <sql:query var="activityQ">
                select fields from table where condition;
            </sql:query>
            <c:choose>
                <c:when test="${empty activityQ.rows}">
<%
    ((java.util.List)jspContext.getAttribute("theList")).add(jspContext.getAttribute("stepRow"));
%>                    
                </c:when>
                <c:otherwise>
                    <c:forEach items="${activityQ.rows}" var="activityRow">
<%
    ((java.util.List)jspContext.getAttribute("theList")).add(jspContext.getAttribute("activityRow"));
%>                    
                        <c:if test="${! empty activityRow.exceptionId}">
                            <traveler:insertTraveler activityId="${activityRow.NCRActivityId}" 
                                                     theList="${theList}"/>
                            <traveler:insertTraveler activityId="${activityId}"
                                                     theList="${theList}"
                                                     startEdgePath="${activityRow.returnProcessPath}"
                                                     startTime="${activityRow.exceptionTS}"
                                                     processSteps="${processSteps}"/>
                            <c:set var="loopState" value="post"/>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:when test="${loopState=='post'}"><%-- noop --%></c:when>
        <c:otherwise>
            Error #964851
        </c:otherwise>
    </c:choose>
</c:forEach>
