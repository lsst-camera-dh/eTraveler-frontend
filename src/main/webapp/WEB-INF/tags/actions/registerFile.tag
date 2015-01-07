<%-- 
    Document   : registerFile
    Created on : Dec 11, 2014, 12:32:17 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib uri="/tlds/dcTagLibrary.tld" prefix="dc"%>

<%@attribute name="filePath" required="true"%>
<%@attribute name="lsstId" required="true"%>

<c:set var="pathComponents" value="${fn:split(filePath, '/')}"/>
<c:set var="fnComponents" value="${fn:split(pathComponents[fn:length(pathComponents)], '.')}"/>
<c:set var="fileExt" value="${fnComponents[fn:length(fnComponents)]}"/>

<c:set var="name" value="${lsstId}"/>
<c:set var="fileFormat" value="${fileExt}"/>
<c:set var="dataType" value="LSSTSENSORTEST"/>
<c:set var="logicalFolderPath" value="/LSST/eTravelerTest/T01"/>
<c:set var="groupName" value="sensorImages"/>
<c:set var="site" value="BNL"/>
<c:set var="location" value="${filePath}"/>
<c:set var="replaceExisting" value="false"/>

<dc:dcRegister name="${filePath}" fileFormat="${fileFormat}" dataType="${dataType}"
               logicalFolderPath="${logicalFolderPath}" groupName="${groupName}"
               site="${site}" location="${location}" replaceExisting="${replaceExisting}"/>
