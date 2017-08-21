<%--
	Document   : getResults
	Created on : Mar 21, 2017, 3:45 PM
	Author     : jrb
--%>

<%@tag description="Call java function to get harnessed data for a run" pageEncoding="US-ASCII"%>
<%@taglib prefix="results" uri="/tlds/resultsLibrary.tld"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- inputs are in a map called 'inputs' --%>

<%--
Invokes doTag for simple tag support class which
  Uses 'function' entry in inputs map to determine which GetHarnessed
     (or, perhaps someday, GetManual) function to call
  Unpacks arguments
  Uses JspContext to get an appropriate db connection
  Creates a new GetHarnessedData or other object and makes the call
  ..encodes results using an ObjectMapper and stickes in
  variable as requested.

Return little map as is done in getHardwareHierarchy.tag:
--%>

<results:getResultsWrapper outputVariable="resultsStr" inputs="${inputs}" />

<c:choose>
  <c:when test="${empty acknowledge}">
{ "acknowledge": null,
  </c:when>
  <c:otherwise>
{ "acknowledge": "${acknowledge}",      
  </c:otherwise>
</c:choose>
<c:choose>
  <c:when test="${empty resultsStr}">
  "results" : null }
  </c:when>
  <c:otherwise>
  "results": ${resultsStr} }
  </c:otherwise>
</c:choose>

