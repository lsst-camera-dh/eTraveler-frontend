<%-- 
    Document   : listLabels.tag
    Created on : Dec. 7, 2016
    Author     : jrb
--%>

<%@tag description="Return all labels for specified labelable type" 
       pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

<%@attribute name="objectTypeName" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="labelQ" scope="AT_BEGIN"%>


<sql:query var="labelQ">
select concat(LG.name, ":", L.name) as fullname, L.id as labelId from Label L
    join LabelGroup LG on L.labelGroupId=LG.id
    join Labelable on LG.labelableId=Labelable.id
    where Labelable.name=?<sql:param value="${objectTypeName}" />
    order by fullname;
</sql:query>
