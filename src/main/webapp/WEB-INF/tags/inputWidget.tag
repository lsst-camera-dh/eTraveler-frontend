<%-- 
    Document   : inputWidget
    Created on : Dec 12, 2013, 10:53:20 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>

<%-- The list of normal or fragment attributes can be specified here: --%>
<%@attribute name="processId" required="true"%>
<%@attribute name="activityId"%>

<sql:query var="inputQ" >
    select IP.*, RM.value, IS.name as ISName
    from InputPattern IP
    left join FloatResultManual RM on RM.inputPatternId=IP.id
    inner join InputSemantics IS on IS.id=IP.inputSemanticsId
    where IP.processId=?<sql:param value="${processId}"/>
    and RM.activityId=?<sql:param value="${activityId}"/>
    union
    select IP.*, RM.value, IS.name as ISName
    from InputPattern IP
    left join IntResultManual RM on RM.inputPatternId=IP.id
    inner join InputSemantics IS on IS.id=IP.inputSemanticsId
    where IP.processId=?<sql:param value="${processId}"/>
    and RM.activityId=?<sql:param value="${activityId}"/>
    union
    select IP.*, RM.value, IS.name as ISName
    from InputPattern IP
    left join StringResultManual RM on RM.inputPatternId=IP.id
    inner join InputSemantics IS on IS.id=IP.inputSemanticsId
    where IP.processId=?<sql:param value="${processId}"/>
    and RM.activityId=?<sql:param value="${activityId}"/>
    union
    select IP.*, RM.value, IS.name as ISName
    from InputPattern IP
    left join FilepathResultManual RM on RM.inputPatternId=IP.id
    inner join InputSemantics IS on IS.id=IP.inputSemanticsId
    where IP.processId=?<sql:param value="${processId}"/>
    and RM.activityId=?<sql:param value="${activityId}"/>;
</sql:query>