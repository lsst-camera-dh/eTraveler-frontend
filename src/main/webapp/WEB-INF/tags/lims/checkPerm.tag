<%-- 
    Document   : checkPerm
    Created on : Jun 23, 2017, 3:28:33 PM
    Author     : focke
--%>

<%@tag description="check permissions for API/LIMS" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<lims:checkUser var="isMagic"/>
<c:if test="${! isMagic}">
    <traveler:error message="You don't have permission for this."/>
</c:if>
