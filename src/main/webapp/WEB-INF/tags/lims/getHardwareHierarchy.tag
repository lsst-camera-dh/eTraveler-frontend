<%-- 
    Document   : getHardwareHierarchy
    Created on : Mar 25, 2016, 4:45:14 PM
    Author     : focke
--%>

<%@tag description="get hardware tree via API" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<traveler:findComponent var="hardwareId" serial="${inputs.experimentSN}" typeName="${inputs.hardwareTypeName}"/>

<traveler:childComponentList var="compList" hardwareId="${hardwareId}" noBatched="${inputs.noBatched}"/>

<lims:encode var="clStr" input="${compList}"/>

{ "acknowledge": null,
  "hierarchy": ${clStr} }
                 