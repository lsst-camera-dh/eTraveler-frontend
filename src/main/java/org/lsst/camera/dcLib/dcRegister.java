
package org.lsst.camera.dcLib;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import java.sql.Connection;
import java.util.Map;

import org.srs.web.base.db.ConnectionManager;
import org.srs.datacat.client.DataCatClient;
import org.srs.datacat.client.sql.Dataset;
import org.srs.datacat.client.sql.NewDataset;

/**
 *
 * @author focke
 */
public class dcRegister extends SimpleTagSupport {
    private String dataCatalogDb;
    private String name;
    private String fileFormat;
    private String dataType;
    private String logicalFolderPath;
    private String groupName=null;
    private String site;
    private String location;
    private boolean replaceExisting;
    private String var;

    @Override
    public void doTag() throws JspException {
        long dsPk;
        
        Connection conn = ConnectionManager.getConnection(dataCatalogDb);
        try {
            DataCatClient c = new DataCatClient(conn, "WebApp");
            NewDataset nds = c.newDataset(name, fileFormat, dataType, logicalFolderPath, groupName, site, location);
            Map<String,Object> metadata = null;
            Dataset ret = c.registerDataset( nds, metadata, replaceExisting );
            dsPk = ret.getPK();
            c.commit();
            getJspContext().setAttribute(var, dsPk);
        } catch (Exception ex) {
            throw new JspException("Error in dcRegister tag", ex);
        } finally {
            try {
                conn.close();
            } catch (Exception ex) {
                throw new JspException("Error in dcRegister tag", ex);
            }
        }
    }
    
    public void setDataCatalogDb(String dataCatalogDb) {
        this.dataCatalogDb = dataCatalogDb;
    }
    public void setName(String name) {
        this.name = name;
    }
    public void setFileFormat(String fileFormat) {
        this.fileFormat = fileFormat;
    }
    public void setDataType(String dataType) {
        this.dataType = dataType;
    }
    public void setLogicalFolderPath(String logicalFolderPath) {
        this.logicalFolderPath = logicalFolderPath;
    }
    public void setGroupName(String groupName) {
        this.groupName = groupName;
    }
    public void setSite(String site) {
        this.site = site;
    }
    public void setLocation(String location) {
        this.location = location;
    }
    public void setReplaceExisting(boolean replaceExisting) {
        this.replaceExisting = replaceExisting;
    }
    public void setVar(String var) {
        this.var = var;
    }
}
