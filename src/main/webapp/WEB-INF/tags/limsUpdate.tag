<%-- 
    Document   : limsUpdate
    Created on : Nov 12, 2013, 1:23:10 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<c:set var="allOk" value="true"/>
<c:set var="message" value="Huh. That wasn't supposed to happen."/>

<%-- check step is correct next one --%>
<%-- stick a record in JobStepHistory --%>

<sql:query var="stepQ" dataSource="jdbc/rd-lsst-cam">
    select id from JobHarnessStep where name=?<sql:param value="${inputs.step}"/>
</sql:query>
<c:if test="${empty stepQ.rows}">
    <c:set var="allOk" value="false"/>
    <c:set var="message" value="Bad Step."/>         
</c:if>

<c:if test="${allOk}">
    <sql:query var="activityQ" dataSource="jdbc/rd-lsst-cam">
        select A.id 
        from Activity A
        inner join Process P on P.id=A.processId
        where A.id=?<sql:param value="${inputs.jobid}"/>
        and P.travelerActionMask&(select maskBit from InternalAction where name='harnessedJob')!=0;
    </sql:query>
    <c:if test="${empty activityQ.rows}">
        <c:set var="allOk" value="false"/>
        <c:set var="message" value="No Record found."/> 
    </c:if>
</c:if>

<c:if test="${allOk}">
    <sql:update dataSource="jdbc/rd-lsst-cam">
        insert into JobStepHistory set
        jobHarnessStepId=(select id from JobHarnessStep where name=?<sql:param value="${inputs.step}"/>),
        activityId=?<sql:param value="${inputs.jobid}"/>,
        errorString=?<sql:param value="${inputs.status}"/>,
        createdBy=?<sql:param value="${userName}"/>,
        creationTS=now();
    </sql:update>
</c:if>

<c:if test="${! allOk}">
    <%-- fail --%>
</c:if>
<c:if test="${! empty inputs.status}">
    <%-- fail --%>
    <c:set var="allOk" value="false"/>
    <c:set var="message" value="${inputs.status}"/>    
</c:if>

<c:choose>
    <c:when test="${allOk}">
        {
            "acknowledge": null
        }
    </c:when>
    <c:otherwise>
        {
            "acknowledge": "${message}"
        }
    </c:otherwise>
</c:choose>