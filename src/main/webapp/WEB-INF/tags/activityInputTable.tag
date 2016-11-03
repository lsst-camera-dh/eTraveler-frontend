<%-- 
    Document   : activityInputWidget
    Created on : Dec 12, 2013, 10:53:20 AM
    Author     : focke
--%>

<%@tag description="Handle manual inputs for an Activity" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="optional" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="resultsFiled" scope="AT_BEGIN"%>

<traveler:fullRequestString var="thisPage"/>
<traveler:checkMask var="mayOperate" activityId="${activityId}"/>

<traveler:getActivityStatus var="status" varFinal="isFinal" activityId="${activityId}"/>

<c:choose>
    <c:when test="${status == 'inProgress'}">
        <c:set var="resultsFiled" value="true"/> <%-- will get set to false if any are not --%>
    </c:when>
    <c:otherwise>
        <c:set var="resultsFiled" value="false"/>
    </c:otherwise>
</c:choose>

    <sql:query var="inputQ" >
select A.begin, A.end, IP.*,
    ISm.name as ISName, ISm.tableName
from Activity A
inner join InputPattern IP on IP.processId=A.processId
inner join InputSemantics ISm on ISm.id=IP.inputSemanticsId
where A.id=?<sql:param value="${activityId}"/>
and ISm.name != 'signature'
and isOptional = ?<sql:param value="${optional}"/>
order by IP.id;
    </sql:query>

<c:set var="nInputs" value="0"/>

<c:if test="${! empty inputQ.rows}">
    <h3><c:choose><c:when test="${optional == 0}">Required</c:when><c:otherwise>Optional</c:otherwise></c:choose>:</h3>

    <form method="post" action="operator/inputResult.jsp" enctype="multipart/form-data">
<%--    <form method="post" action="test.jsp" enctype="multipart/form-data">--%>
        <input type="hidden" name="freshnessToken" value="${freshnessToken}">
        <input type="hidden" name="referringPage" value="${thisPage}">
        <input type="hidden" name="activityId" value="${activityId}">

    <display:table name="${inputQ.rows}" id="row" class="datatable">
        <display:column property="label" title="Name" sortable="true" headerClass="sortable"/>
        <display:column property="description" sortable="true" headerClass="sortable"/>
        <display:column title="Type">
            <c:if test="${! empty row.minV or ! empty row.maxV}">${row.minV} - ${row.maxV}</c:if>
            <c:if test="${! empty row.units}">${row.units}</c:if>
            ${row.ISName}
        </display:column>
        <display:column title="Value">
            <sql:query var="valueQ">
select createdBy, creationTS,
<c:if test="${row.ISName == 'filepath'}">
    catalogKey,
</c:if>
<c:choose>
    <c:when test="${row.ISName == 'boolean'}">
        if(value is not null, if(value=0,'False','True'), null) as value
    </c:when>
    <c:otherwise>
        value
    </c:otherwise>
</c:choose>
from ${row.tableName} 
where inputPatternId = ?<sql:param value="${row.id}"/>
and activityId = ?<sql:param value="${activityId}"/>
order by id desc limit 1;
            </sql:query>
            <c:choose>
                <c:when test="${! empty valueQ.rows}">
                    <c:set var="value" value="${valueQ.rows[0]}"/>
                    <c:choose>
                        <c:when test="${(row.ISName == 'filepath') && (! empty value.catalogKey)}">
                            <c:url var="dcLink" value="http://srs.slac.stanford.edu/DataCatalog/">
                                <c:param name="dataset" value="${value.catalogKey}"/>
                                <c:param name="experiment" value="${appVariables.experiment}"/>
                            </c:url>
                            <a href="${dcLink}" target="_blank"><c:out value="${value.value}"/></a>
                        </c:when>
                        <c:otherwise>
                            <c:out value="${value.value}"/>
                        </c:otherwise>
                    </c:choose>
                </c:when>
                <c:when test="${status == 'skipped'}">
                    Too late
                </c:when>
                <c:when test="${(empty row.begin) || status == 'paused' || status == 'stopped'}">
                    Not yet
                </c:when>
                <c:when test="${! empty row.end && row.isOptional == 0}">
                    ERROR: no value found
                </c:when>
                <c:when test="${! empty row.end && row.isOptional != 0}">
                    No value supplied
                </c:when>
                <c:otherwise>
                    <c:set var="inputName" value="inputPatternId${nInputs}"/>
                    <c:set var="valueName" value="value${nInputs}"/>
                    ${inputName} ${valueName}
                    <c:if test="${row.isOptional == 0}">
                        <c:set var="resultsFiled" value="false"/>
                    </c:if>
                    <c:choose>
                        <c:when test="${row.ISName == 'string'}">
                            <c:set var="inputType" value="text"/>
                        </c:when>
                        <c:when test="${row.ISName == 'filepath'}">
                            <c:set var="inputType" value="file"/>
                        </c:when>
                        <c:otherwise>
                            <c:set var="inputType" value="number"/>
                        </c:otherwise>
                    </c:choose>
                        <input type="hidden" name="${inputName}" value="${row.id}">
                        <c:choose>
                            <c:when test="${row.ISName == 'boolean'}">
                                <label>True<input type="radio" name="${valueName}" value="1" 
                                                  <c:if test="${row.isOptional == 0}">required</c:if>></label>
                                <label>False<input type="radio" name="${valueName}" value="0"
                                                   <c:if test="${row.isOptional == 0}">required</c:if>></label>
                            </c:when>
                            <c:when test="${row.ISName == 'text'}">
                                <textarea name="${valueName}"></textarea>
                            </c:when>
                            <c:otherwise>
                                <c:if test="${row.isOptional == 0}">*</c:if><input type="${inputType}" name="${valueName}" 
                                        <c:if test="${row.isOptional == 0}">required</c:if>
                                        <c:if test="${row.ISName=='float'}">step="any"</c:if>
                                        <c:if test="${!empty row.minV}">min="<c:out value="${row.minV}"/>"</c:if>
                                        <c:if test="${!empty row.maxV}">max="<c:out value="${row.maxV}"/>"</c:if>
                                        >
                            </c:otherwise>
                        </c:choose>
                        <c:set var="nInputs" value="${nInputs + 1}"/>
                </c:otherwise>
            </c:choose>
        </display:column>
        <display:column title="Who" sortable="true" headerClass="sortable">
            ${valueQ.rows[0].createdBy}
        </display:column>
        <display:column title="When" sortable="true" headerClass="sortable">
            ${valueQ.rows[0].creationTS}
        </display:column>
    </display:table>

        <input type="hidden" name="nInputs" value="${nInputs}">
        <input type="submit" value="Record Results"
            <c:if test="${! mayOperate}">disabled</c:if>>
    </form>

</c:if>
