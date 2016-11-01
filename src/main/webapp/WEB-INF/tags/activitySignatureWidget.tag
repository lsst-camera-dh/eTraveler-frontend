<%-- 
    Document   : activitySignatureWidget
    Created on : Apr 12, 2016, 1:58:11 PM
    Author     : focke
--%>

<%@tag description="handle signatures for activities" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@taglib prefix="ta" tagdir="/WEB-INF/tags/actions"%>
<%@taglib prefix="traveler" tagdir="/WEB-INF/tags"%>

<%@attribute name="activityId" required="true"%>
<%@attribute name="resultsFiled" required="true"%>
<%@attribute name="var" required="true" rtexprvalue="false"%>
<%@variable name-from-attribute="var" alias="signedOff" scope="AT_BEGIN"%>

<traveler:fullRequestString var="thisPage"/>

<traveler:getActivityStatus var="status" varFinal="isFinal" activityId="${activityId}"/>
<traveler:getSsName var="subsystemName" activityId="${activityId}"/>

<%-- Add static records to signature table --%>
<c:if test="${! isFinal}">
    <sql:query var="staticPatternsQ">
select IP.id, IP.label,
PG.name as role
from Activity A
inner join InputPattern IP on IP.processId = A.processId
inner join InputSemantics ISM on IP.inputSemanticsId = ISM.id
inner join PermissionGroup PG on PG.id = IP.permissionGroupId
left join SignatureResultManual SRM on SRM.inputPatternId = IP.id and SRM.activityId = A.id
where A.id = ?<sql:param value="${activityId}"/>
and ISM.name = 'signature'
and SRM.id is null
;
    </sql:query>
    <c:forEach var="sigPattern" items="${staticPatternsQ.rows}">
        <traveler:getPermGroup var="groupName" subsystem="${subsystemName}" role="${sigPattern.role}"/>
        <ta:addSignature activityId="${activityId}" 
                         inputPatternId="${sigPattern.id}" 
                         signerRequest="${groupName}"/>
    </c:forEach>

<%-- a form to add dynamics ones if requested --%>
    <sql:query var="dynamicPatternsQ">
select IP.id, IP.label
from Activity A
inner join InputPattern IP on IP.processId = A.processId
inner join InputSemantics ISM on IP.inputSemanticsId = ISM.id
where A.id = ?<sql:param value="${activityId}"/>
and ISM.name = 'signature'
and IP.permissionGroupId is null
;
    </sql:query>
    <c:if test="${! empty dynamicPatternsQ.rows}">
        <c:set var="sigPattern" value="${dynamicPatternsQ.rows[0]}"/>
        <sql:query var="rolesQ">
select * from PermissionGroup order by maskBit;
        </sql:query>
        <sql:query var="subSysQ">
select * from Subsystem where shortName not in ('Legacy', 'Default') order by name;
        </sql:query>
        <form action='operator/addSignature.jsp'>
<input type="hidden" name="freshnessToken" value="${freshnessToken}">
<input type="hidden" name="referringPage" value="${thisPage}">
<input type="hidden" name="activityId" value="${activityId}">
<input type="hidden" name="inputPatternId" value="${sigPattern.id}">
<%--
Username: <input type="text" name='sigUser'>
--%>
Role: <select name="sigRole">
    <option value="">Select Role</option>
    <c:forEach var="role" items="${rolesQ.rows}">
        <traveler:getPermGroup var="groupName" subsystem="${subsystemName}" role="${role.name}"/>
        <option value="${groupName}">${role.name}</option>
    </c:forEach>
</select>
Group: <select name="sigGroup">
    <option value="" selected>Select Group</option>
    <option value="NCR-CameraProjectManager">NCR-CameraProjectManager</option>
    <option value="NCR-CameraProjectScientist">NCR-CameraProjectScientist</option>
    <option value="NCR-ChiefElectricalEngineer">NCR-ChiefElectricalEngineer</option>
    <option value="NCR-ChiefMechanicalEngineer">NCR-ChiefMechanicalEngineer</option>
    <option value="NCR-CRScientist">NCR-CRScientist</option>
    <option value="NCR-IandTScientist">NCR-IandTScientist</option>
    <option value="NCR-LSSTProjectDirector">NCR-LSSTProjectDirector</option>
    <option value="NCR-QA">NCR-QA</option>
    <option value="NCR-Requirements">NCR-Requirements</option>
    <option value="NCR-Safety">NCR-Safety</option>
    <option value="NCR-SRScientist">NCR-SRScientist</option>
    <option value="NCR-SystemIntegration">NCR-SystemIntegration</option>
    <option value="EtravelerSubsystemManagers">Default Managers</option>
    <option value="EtravelerSubsystemManagers">Legacy Managers</option>
    <c:forEach var="subSys" items="${subSysQ.rows}">
        <option value="${subSys.shortName}_subsystemManager">${subSys.name} Managers</option>
    </c:forEach>
</select>
<input type='submit' value='Add Signature Requirement'>
        </form>
    </c:if>
</c:if>

<%-- display any signature records --%>
    <sql:query var="sigQ">
select SRM.*, IP.label
from SignatureResultManual SRM
inner join InputPattern IP on IP.id = SRM.inputPatternId
inner join InputSemantics ISM on ISM.id = IP.inputSemanticsId
where SRM.activityId = ?<sql:param value="${activityId}"/>
and ISM.name = "signature"
order by IP.id
;
    </sql:query>
<display:table name="${sigQ.rows}" id="sig" class="datatable">
    <display:column property="label" title="Label" sortable="true" headerClass="sortable"/>
    <display:column property="signerRequest" title="Group" sortable="true" headerClass="sortable"/>
    <display:column property="signerValue" title="Signed By" sortable="true" headerClass="sortable"/>
    <display:column property="signatureTS" title="Date" sortable="true" headerClass="sortable"/>
    <c:if test="${status == 'inProgress' and resultsFiled}">
        <display:column title="Sign/Comment Here">
            <c:choose>
                <c:when test="${empty sig.signatureTS}">
            <form action="operator/signSignature.jsp">
<input type="hidden" name="freshnessToken" value="${freshnessToken}">
<input type="hidden" name="referringPage" value="${thisPage}">
<input type="hidden" name="signatureId" value="${sig.id}">
<%--
<c:choose>
    <c:when test="${empty sig.name}">
        <c:set var="maySign" value="${sig.signerRequest == userName}"/>
    </c:when>
    <c:otherwise>
        <traveler:checkPerm var="maySign" groups="${sig.name}"/>
    </c:otherwise>
</c:choose>
--%>
<textarea name="comment" placeholder="Comment"></textarea>
<traveler:checkPerm var="maySign" groups="${sig.signerRequest}"/>
<input type='submit' value='Sign It!' <c:if test="${! maySign}">disabled</c:if>>
            </form>
                </c:when>
                <c:otherwise>
                    ${sig.signerComment}
                </c:otherwise>
            </c:choose>
        </display:column>
    </c:if>
</display:table>

<c:set var="signedOff" value="true"/>
<c:forEach var="sig" items="${sigQ.rows}">
    <c:if test="${empty sig.signatureTs}">
        <c:set var="signedOff" value="false"/>
    </c:if>
</c:forEach>
