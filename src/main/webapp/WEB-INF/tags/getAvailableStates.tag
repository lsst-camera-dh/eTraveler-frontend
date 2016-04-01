<%-- 
    Document   : getAvailableStates
    Created on : Mar 31, 2016, 12:27:01 PM
    Author     : focke
--%>

<%@tag description="get the states that are available to a component" pageEncoding="UTF-8"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="hardwareId" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="statesQ" scope="AT_BEGIN"%>

<sql:query var="statesQ" >
    select * 
    from HardwareStatus 
    where name!='NEW'
    and id!=(select HSH.hardwareStatusId from HardwareStatusHistory HSH 
            inner join HardwareStatus HS on HS.id=HSH.hardwareStatusId
            where HSH.hardwareId=?<sql:param value="${hardwareId}"/> 
            and HS.isStatusValue=1 
            order by HSH.id desc limit 1)
    and isStatusValue=1
    order by name;
</sql:query>
