<%@tag description="header decorator" pageEncoding="UTF-8"%>
<%@taglib prefix="srs_utils" uri="http://srs.slac.stanford.edu/utils" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<table>
    <tr valign="bottom" align="right">
        <td align="right" valign="bottom">
            <srs_utils:conditonalLink name="Welcome" url="welcome.jsp" iswelcome="true"/> | 
            <srs_utils:conditonalLink name="List Hardware Types" url="listHardwareTypes.jsp" /> |
            <srs_utils:conditonalLink name="List Hardware" url="listHardware.jsp" /> |
            <c:url var="newHwLink" value="selectHardwareType.jsp">
                <c:param name="target" value="registerHardware.jsp"/>
            </c:url>
            <srs_utils:conditonalLink name="Register Hardware" url="${newHwLink}" /> |
            <srs_utils:conditonalLink name="List Traveler Types" url="listTravelerTypes.jsp" /> |
            <srs_utils:conditonalLink name="List Travelers" url="listTravelers.jsp" /> |
            <c:url var="newTravLink" value="selectHardwareType.jsp">
                <c:param name="target" value="initiateTraveler.jsp"/>
            </c:url>
            <srs_utils:conditonalLink name="Initiate Traveler" url="${newTravLink}" /> |
            <srs_utils:conditonalLink name="Admin" url="admin.jsp" />
        </td>
    </tr>
</table>
