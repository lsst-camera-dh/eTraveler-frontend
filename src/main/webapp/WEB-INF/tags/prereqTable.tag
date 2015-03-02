<%-- 
    Document   : prereqTable
    Created on : Aug 2, 2013, 12:42:20 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="display" uri="http://displaytag.sf.net" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="prereqTypeName" required="true"%>
<%@attribute name="activityId"%>
<%@attribute name="processId"%>

<sql:query var="prereqQ" >
    select PP.*<c:if test="${! empty activityId}">, PI.creationTS as satisfaction</c:if>
    from PrerequisitePattern PP
    <c:choose>
        <c:when test="${! empty activityId}">
            inner join Activity A on A.processId=PP.processId
            left join Prerequisite PI on PI.activityId=A.id and PI.prerequisitePatternId=PP.id
            where A.id=?<sql:param value="${activityId}"/>
        </c:when>
        <c:otherwise>
            where PP.processId=?<sql:param value="${processId}"/>
        </c:otherwise>
    </c:choose>
    and PP.prerequisiteTypeId=(select id from PrerequisiteType where name=?<sql:param value="${prereqTypeName}"/>)
</sql:query>
<c:if test="${! empty prereqQ.rows}">
    <h2>Required <c:out value="${prereqTypeName}"/>s</h2>
    <display:table name="${prereqQ.rows}" id="row" class="datatable">
        <display:column property="name"/>
        <display:column property="description"/>
        <display:column property="quantity"/>
        <c:if test="${! empty activityId}">
            <display:column title="satisfaction">
                <c:choose>
                    <c:when test="${! empty row.satisfaction}">
                        <c:out value="${row.satisfaction}"/>
                    </c:when>
                    <c:otherwise>
                        <form method="get" action="fh/satisfyPrereq.jsp">
                            <input type="hidden" name="prerequisitePatternId" value="${row.id}">
                            <input type="hidden" name="activityId" value="${activityId}">
                            <input type="submit" value="Done">
                        </form>
                    </c:otherwise>
                </c:choose>
            </display:column>
        </c:if>
    </display:table>
</c:if>
