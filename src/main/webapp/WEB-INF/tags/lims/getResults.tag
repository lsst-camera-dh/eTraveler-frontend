<%--
	Document   : getResults
	Created on : Mar 21, 2017, 3:45 PM
	Author     : jrb
--%>

<%@tag description="Call java function to get harnessed data for a run" pageEncoding="US-ASCII"%>
<%@taglib prefix="results" uri="/tlds/resultsLibrary.tld"%>
<%@taglib prefix="lims" tagdir="/WEB-INF/tags/lims"%>

<%-- inputs are in a map called 'inputs' --%>

<%--
Invokes doTag for simple tag support class which
  Uses 'function' entry in inputs map to determine which GetHarnessed
     (or, perhaps someday, GetManual) function to call
  Unpacks arguments
  Uses JspContext to get an appropriate db connection
  Creates a new GetHarnessedData object and makes the call
  ..sticks results in an appropriate variable

Then use <lims:encode to store encoded results in another variable
Return little map as is done in getHardwareHierarchy.tag:
--%>
<results:getResultsWrapper outputVariable="resultsMap" inputs="${inputs}" /> 
  


  <lims:encode var="resultsStr" input="${resultsMap}"/>

{ "acknowledge": ${acknowledge},
  "results": ${resultsStr} }
  

