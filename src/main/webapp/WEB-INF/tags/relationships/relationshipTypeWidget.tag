<%-- 
    Document   : relationshipTypeWidget
    Created on : Nov 1, 2016, 2:56:14 PM
    Author     : focke
--%>

<%@tag description="aggregate relationshipType admin stuff" pageEncoding="UTF-8"%>
<%@taglib prefix="filter" uri="http://srs.slac.stanford.edu/filter"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<filter:filterTable>
    <filter:filterInput var="relTypeName" title="Name:"/>
    <filter:filterInput var="assTypeName" title="Assembly Type:"/>
    <filter:filterInput var="compTypeName" title="Component Type:"/>
</filter:filterTable>

<relationships:newRelationshipTypeForm assTypeName="${assTypeName}" 
                                       compTypeName="${compTypeName}"/>

<relationships:relationshipTypeList relTypeName="${relTypeName}" 
                                    assTypeName="${assTypeName}" 
                                    compTypeName="${compTypeName}"/>
