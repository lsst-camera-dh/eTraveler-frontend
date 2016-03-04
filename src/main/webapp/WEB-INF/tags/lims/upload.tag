<%-- 
    Document   : upload
    Created on : Mar 3, 2016, 11:03:11 AM
    Author     : focke
--%>

<%@tag description="ingest a yaml traveler description" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>
<%@taglib prefix="upload" uri="/tlds/uploads.tld"%>

<c:catch var="ex">
    <upload:yamlUploader var="resMap" parms="${inputs}"/>
    <lims:encode var="resp" input="${resMap}"/>
</c:catch>
<c:if test="${! empty ex}">
    <traveler:error message="upload error"/>
</c:if>

${resp}
