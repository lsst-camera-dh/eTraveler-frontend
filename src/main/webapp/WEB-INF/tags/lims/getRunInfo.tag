<%-- 
    Document   : getRunInfo
    Created on : Sep 29, 2016, 2:32:13 PM
    Author     : focke
--%>

<%@tag description="get run number via API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<traveler:findRun varRun="runNumber" varTraveler="rootActivityId" activityId="${inputs.activityId}"/>

{
    "runNumber": "${runNumber}",
    "rootActivityId": "${rootActivityId}",
    "acknowledge": null
}
