<%-- 
    Document   : hardwareRelationshipStatus
    Created on : Jul 28, 2015, 5:36:13 PM
    Author     : focke
--%>

<%@tag description="get the current status of a relationship" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="message"%>

    <sql:query var="rsQ">
select 
    MRH.*, MRA.name
from 
    MultiRelationship MR
    inner join MultiRelationshipHistory MRH on MRH.multiRelationshipId=MR.id
    inner join MultiRelationshipAction MRA on MRA.id=MRH.multiRelationshipActionId
where 
    uhh...
order by MRH.id desc limit 1;
    </sql:query>