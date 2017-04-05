<%-- 
    Document   : test
    Created on : Oct 2, 2013, 3:53:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="ecl" uri="/tlds/eclTagLibrary.tld"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Page</title>
    </head>
    <body>
        <relationships:showSlotHistory slotId="12"/>
        <traveler:test/>


<traveler:lastInPath var="processId" processPath="${param.processPath}"/>
<traveler:checkId table="Process" id="${processId}"/>
[${param.processPath}] [${processId}]
<sql:query var="processQ" >
    select P.*, TT.id as travelerTypeId, HG.name as hgName,
    SS.id as subsystemId, SS.name as subsystemName
    from Process P
    inner join HardwareGroup HG on HG.id=P.hardwareGroupId
    left join TravelerType TT on TT.rootProcessId=P.id
    left join Subsystem SS on SS.id=TT.subsystemId
    where P.id=?<sql:param value="${processId}"/>;
</sql:query>
<c:set var="process" value="${processQ.rows[0]}"/>
[${process.id}]
    </body>
</html>
