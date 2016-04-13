<%-- 
    Document   : addSignature
    Created on : Apr 12, 2016, 3:18:30 PM
    Author     : focke
--%>

<%@tag description="Add a (unsigned) record to the signature table" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="inputPatternId" required="true"%>
<%@attribute name="signerRequest" required="true"%>

<sql:update>
    insert into SignatureResultManual set
    activityId=?<sql:param value="${activityId}"/>,
    inputPatternId=?<sql:param value="${inputPatternId}"/>,
    signerRequest=?<sql:param value="${signerRequest}"/>,
    createdBy=?<sql:param value="${userName}"/>,
    creationTS=utc_timestamp();
</sql:update>
