<%-- 
    Document   : scriptWidget
    Created on : Aug 8, 2014, 12:14:59 PM
    Author     : focke
--%>

<%@tag description="Stuff for scriptable steps" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>

Now enter the following command:<br>
lcatr-iterator --container-id=${activityId}<br>
