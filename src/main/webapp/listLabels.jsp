<%@page contentType="text/html"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

    <sql:query var="labelableQ">
select name from Labelable order by name;
    </sql:query>

    <sql:query var="labelGroupQ">
select name from LabelGroup order by name;
    </sql:query>

    <sql:query var="hardwareGroupQ">
select name from HardwareGroup order by name;
    </sql:query>

    <sql:query var="subsysQ">
select name from Subsystem order by name;
    </sql:query>

<!DOCTYPE html>
<html>
    <head>
        <title>Label List</title>
    </head>
    <body>
    <%--
        <c:choose>
            <c:when test="${! empty param.status}">
                <c:set var="theStatus" value="${param.status}"/>
            </c:when>
            <c:otherwise>
                <c:set var="theStatus" value="any"/>
            </c:otherwise>
        </c:choose>
     --%>
	
    <filter:filterTable>
       <filter:filterInput var="name" title="Label name (substring search)"/>

       <filter:filterSelection title="Subsystem" var="subsystem" defaultValue="any">
         <filter:filterOption value="${preferences.subsystem}">User Pref</filter:filterOption>
         <filter:filterOption value="any">Any</filter:filterOption>
         <c:forEach var="subsystem" items="${subsysQ.rows}">
           <filter:filterOption value="${subsystem.name}">
             <c:out value="${subsystem.name}"/></filter:filterOption>
         </c:forEach>                
       </filter:filterSelection>

       <filter:filterSelection title="Labelable object" var="objectType" defaultValue='hardware'>
         <filter:filterOption value="any">Any</filter:filterOption>
         <c:forEach var="objectType" items="${labelableQ.rows}">
           <filter:filterOption value="${objectType.name}"><c:out value="${objectType.name}"/></filter:filterOption>
         </c:forEach>
       </filter:filterSelection>
       <filter:filterSelection title="Label group" var="labelGroup"
                               defaultValue="any">
         <filter:filterOption value="any">Any</filter:filterOption>
         <c:forEach var="labelGroup" items="${labelGroupQ.rows}">
           <filter:filterOption value="${labelGroup.name}">
             <c:out value="${labelGroup.name}" />
           </filter:filterOption>
         </c:forEach>
       </filter:filterSelection>
        <filter:filterSelection title="Hardware group" var="hardwareGroup"
                               defaultValue="any">
         <filter:filterOption value="any">Any</filter:filterOption>
         <c:forEach var="hardwareGroup" items="${hardwareGroupQ.rows}">
           <filter:filterOption value="${hardwareGroup.name}">
             <c:out value="${hardwareGroup.name}" />
           </filter:filterOption>
         </c:forEach>
       </filter:filterSelection>

    </filter:filterTable>
    <traveler:labelList labelGroupId="${param.labelGroupId}"
                        labelGroupName="${labelGroup}"
                        labelableId="{param.labelableId}"
                        labelableObject="${objectType}"
                        name="${name}"
                        hardwareGroupName="${hardwareGroup}"
                        subsystemId="${param.subsystemId}"
                        subsystemName="${subsystem}"/>
    </body>
</html>
