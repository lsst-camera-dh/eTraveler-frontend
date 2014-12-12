<%-- 
    Document   : registerFile
    Created on : Dec 11, 2014, 12:32:17 PM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib uri="/tlds/dcTagLibrary.tld" prefix="dc"%>

<%@attribute name="filePath" required="true"%>

<dc:dcRegister name="${filePath}"/>
