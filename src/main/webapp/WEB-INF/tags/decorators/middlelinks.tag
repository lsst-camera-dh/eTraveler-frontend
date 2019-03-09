<%@tag description="header decorator" pageEncoding="UTF-8"%>
<%@taglib prefix="srs_utils" uri="http://srs.slac.stanford.edu/utils"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>

    <sql:query var="dbReleaseQ">
select major, minor, patch, id from DbRelease where status='CURRENT' order by id desc limit 1;
    </sql:query>
<c:set var="dbRelease" value="${dbReleaseQ.rows[0]}"/>
    
<table>
    <tr valign="bottom" align="right">
        <td align="right" valign="bottom">
            Database: [ <srs_utils:modeChooser mode="dataSourceMode" href="welcome.jsp"/> ],
            Schema version ${dbRelease.major}.${dbRelease.minor}.${dbRelease.patch}
        </td>
    </tr>
</table>
