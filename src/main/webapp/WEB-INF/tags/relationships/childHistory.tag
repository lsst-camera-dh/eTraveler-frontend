<%-- 
    Document   : childHistory
    Created on : Jun 9, 2016, 11:12:02 AM
    Author     : focke
--%>

<%@tag description="put the tag description here" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@taglib prefix="relationships" tagdir="/WEB-INF/tags/relationships"%>

<%@attribute name="hardwareId" required="true"%>

    <sql:query var="slotsQ">
select MRT.id as mrtId, MRST.id as mrstId, MRS.id as mrsId
from MultiRelationshipSlot MRS
inner join MultiRelationshipSlotType MRST on MRST.id = MRS.multiRelationshipSlotTypeId
inner join MultiRelationshipType MRT on MRT.id = MRST.multiRelationshipTypeId
where MRS.hardwareId = ?<sql:param value="${hardwareId}"/>
order by mrtId, MRST.id, MRS.id;
    </sql:query>

<c:if test="${! empty slotsQ.rows}">
    <h2>Components</h2>
    <c:forEach var="slot" items="${slotsQ.rows}">
        <relationships:showSlotHistory slotId="${slot.mrsId}"/>
    </c:forEach>
</c:if>
