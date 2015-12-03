<%-- 
    Document   : error.json
    Created on : Nov 18, 2015, 10:55:38 AM
    Author     : focke
--%>

<%@page contentType="application/json" pageEncoding="UTF-8"%>

{
    "error": "${param.message}",
    "acknowledge": "${param.message}",
    "bug": ${param.bug}
}
