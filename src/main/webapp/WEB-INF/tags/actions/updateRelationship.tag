<%-- 
    Document   : updateHardwareRelationship
    Created on : Jul 28, 2015, 5:31:05 PM
    Author     : focke
--%>

<%@tag description="Add to the history of a HardwareRelationship" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="parentId" required="true"%>
<%@attribute name="childId" required="true"%>
<%@attribute name="action" required="true"%>