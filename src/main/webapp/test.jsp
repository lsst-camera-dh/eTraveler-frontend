<%-- 
    Document   : test
    Created on : Oct 2, 2013, 3:53:56 PM
    Author     : focke
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="gm" uri="http://srs.slac.stanford.edu/GroupManager"%>
<%@taglib prefix="preferences" uri="http://srs.slac.stanford.edu/preferences"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="ecl" uri="/tlds/eclTagLibrary.tld"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Test Page</title>
    </head>
    <body>
        <traveler:test/>
        <c:set var="map" value="<%= new java.util.HashMap<String, String>() %>"/>
        <traveler:mapAdd theMap="${map}" key="one" value="1"/>
        <traveler:mapAdd theMap="${map}" key="two" value="arglebartgle"/>
        ${map}
        <lims:encode var="str" input="${map}"/>
        ${str}
        ${response}
    </body>
</html>
