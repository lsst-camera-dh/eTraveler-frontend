<%-- 
    Document   : addSignature
    Created on : Apr 12, 2016, 3:18:30 PM
    Author     : focke
--%>

<%@tag description="Add a (unsigned) record to the signature table" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="inputPatternId" required="true"%>
<%@attribute name="signerRequest" required="true"%>

<sql:query var="sigsQ">
    select id 
    from SignatureResultManual 
    where activityId=?<sql:param value="${activityId}"/>
    and signerRequest=?<sql:param value="${signerRequest}"/>
    ;
</sql:query>
<c:if test="${! empty sigsQ.rows}">
    <traveler:error message="You are trying to add a signature requirement that already exists."/>
</c:if>

<sql:update>
    insert into SignatureResultManual set
    activityId=?<sql:param value="${activityId}"/>,
    inputPatternId=?<sql:param value="${inputPatternId}"/>,
    signerRequest=?<sql:param value="${signerRequest}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=utc_timestamp();
</sql:update>
