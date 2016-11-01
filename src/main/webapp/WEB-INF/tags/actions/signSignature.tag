<%-- 
    Document   : signSignature
    Created on : Apr 13, 2016, 9:39:10 AM
    Author     : focke
--%>

<%@tag description="SIgn off a Signature record" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="signatureId" required="true"%>
<%@attribute name="comment"%>

    <sql:update>
update SignatureResultManual set
signerValue = ?<sql:param value="${userName}"/>,
signerComment = ?<sql:param value="${comment}"/>,
signatureTS = utc_timestamp()
where id = ?<sql:param value="${signatureId}"/>
;
    </sql:update>