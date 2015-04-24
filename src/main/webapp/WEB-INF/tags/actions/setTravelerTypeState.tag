<%-- 
    Document   : setTravelerTypeState
    Created on : Apr 6, 2015, 11:10:32 AM
    Author     : focke
--%>

<%@tag description="Change the state of a TravelerType" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="travelerTypeId" required="true"%>
<%@attribute name="stateId"%>
<%@attribute name="stateName"%>
<%@attribute name="reason"%>

<c:choose>
    <c:when test="${! empty stateName}">
        <sql:query var="sidQ">
select id from TravelerTypeState where name=?<sql:param value="${stateName}"/>;
        </sql:query>
        <c:choose>
            <c:when test="${! empty stateId}">
                <c:if test="${sidQ.rows[0].id != stateId}">
                    <traveler:error message="Inconsistent Traveler Type status! 593748" bug="true"/>
                </c:if>
            </c:when>
            <c:otherwise>
                <c:set var="stateId" value="${sidQ.rows[0].id}"/>
            </c:otherwise>
        </c:choose>
    </c:when>
    <c:otherwise>
        <c:choose>
             <c:when test="${! empty stateId}">
                <sql:query var="nameQ">
select name from TravelerTypeState where id=?<sql:param value="${stateId}"/>;
                </sql:query>
                <c:set var="stateName" value="${nameQ.rows[0].name}"/>
             </c:when>
            <c:otherwise>
                 <traveler:error message="No Traveler Type status! 341636" bug="true"/>
            </c:otherwise>
        </c:choose>
    </c:otherwise>
</c:choose>

<traveler:getTravelerTypeState var="oldState" travelerTypeId="${travelerTypeId}"/>

    <sql:update>
insert into TravelerTypeStateHistory set
reason=?<sql:param value="${reason}"/>,
travelerTypeId=?<sql:param value="${travelerTypeId}"/>,
travelerTypeStateId=?<sql:param value="${stateId}"/>,
createdBy=?<sql:param value="${userName}"/>,
creationTS=utc_timestamp();
    </sql:update>

<c:if test="${oldState == 'new' and stateName == 'active'}">
    <sql:query var="ttQ">
select
    P.name, P.version, P.hardwareGroupId
from
    TravelerType TT
    inner join Process P on P.id=TT.rootProcessId
where
    TT.id=?<sql:param value="${travelerTypeId}"/>
;    
    </sql:query>
    <c:set var="travelerType" value="${ttQ.rows[0]}"/>

    <sql:query var="oldVersionsQ">
select
    TT.id
from
    TravelerType TT
    inner join Process P on P.id=TT.rootProcessId
    inner join TravelerTypeStateHistory TTSH on 
        TTSH.travelerTypeId=TT.id 
        and TTSH.id=(select max(id) from TravelerTypeStateHistory where travelerTypeId=TT.id)
    inner join TravelerTypeState TTS on TTS.id=TTSH.travelerTypeStateId
where
    TT.id!=?<sql:param value="${travelerTypeId}"/>
    and P.name=?<sql:param value="${travelerType.name}"/>
    and P.hardwareGroupId=?<sql:param value="${travelerType.hardwareGroupId}"/>
    and TTS.name='active'
;
    </sql:query>

    <c:forEach var="oldVersion" items="${oldVersionsQ.rows}">
        <ta:setTravelerTypeState travelerTypeId="${oldVersion.id}" stateName="superseded" reason="Superseded by version ${travelerType.version}"/>
    </c:forEach>
</c:if>
