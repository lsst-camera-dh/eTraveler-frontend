<%-- 
    Document   : webbify
    Created on : Nov 29, 2016, 11:32:41 AM
    Author     : focke
--%>

<%@tag description="format user-entered input for web" pageEncoding="UTF-8"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@attribute name="input"%>

${fn:replace(input, '
', '<br>')}
