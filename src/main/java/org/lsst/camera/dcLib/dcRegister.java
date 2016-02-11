
package org.lsst.camera.dcLib;

import java.io.IOException;
import java.net.URISyntaxException;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import javax.servlet.jsp.PageContext;

import java.util.HashMap;
import java.util.Map;
import org.glassfish.jersey.filter.LoggingFilter;
import org.srs.datacat.client.Client;
import org.srs.datacat.client.ClientBuilder;
import org.srs.datacat.client.auth.HeaderFilter;
import org.srs.datacat.model.DatasetModel;
import org.srs.datacat.shared.Dataset;
import org.srs.datacat.shared.Provider;
import java.math.BigDecimal;
import org.srs.datacat.client.exception.DcClientException;
import org.srs.datacat.client.exception.DcRequestException;
import org.srs.datacat.model.DatasetContainer;
import org.srs.datacat.model.DatasetView;
import org.srs.vfs.PathUtils;

/**
 *
 * @author focke
 */
public class dcRegister extends SimpleTagSupport {
    private String name;
    private String fileFormat;
    private String dataType;
    private String logicalFolderPath;
    private String site;
    private String location;
    private Map<String,Object> metadata;
    private String var;
    
    public Client getClient() throws IOException{
        String datacatUrl = "http://srs.slac.stanford.edu/datacat-v0.4/r";
        try {
            
            Map<String, Object> headers = new HashMap<String, Object>();

            String srsClientId = ((PageContext)getJspContext()).getServletContext().getInitParameter("org.lsst.eTraveler.srs_client_id");
            String defaultUserName = ((PageContext)getJspContext()).getServletContext().getInitParameter("org.lsst.eTraveler.default_username");

            if(srsClientId != null){
                headers.put("x-client-id", srsClientId); // This web applications has a clientId which should be trusted
            }
            if(defaultUserName != null){
                headers.put("x-cas-username", defaultUserName); // This machine should be trusted (this won't work locally)
            }

            return ClientBuilder.newBuilder()
                    .setUrl(datacatUrl)
                    .addClientRequestFilter(new LoggingFilter())
                    .addClientRequestFilter(new HeaderFilter(headers))
                    .build();
        } catch(URISyntaxException ex) {
            throw new IOException(ex);
        }
    }


    @Override
    public void doTag() throws JspException {
        
        try {
            Client c = getClient();
            Provider provider = new Provider();
            
            if(!c.exists(logicalFolderPath)){
                String parentPath = PathUtils.getParentPath(logicalFolderPath);
                DatasetContainer newFolder = provider.getContainerBuilder()
                        .name(PathUtils.getFileName(logicalFolderPath)).build();
                c.createContainer(parentPath, newFolder, true);
            }
            
            Dataset.Builder builder = (Dataset.Builder) provider.getDatasetBuilder()
                    .name(name)
                    .fileFormat(fileFormat)
                    .dataType(dataType)
                    .site(site)
                    .resource(location)
                    .versionId(DatasetView.NEW_VER)
                    .versionMetadata(metadata);
            
            DatasetModel retDs = c.createDataset(logicalFolderPath, builder.build());
            getJspContext().setAttribute(var, retDs.getPk());
        } catch (DcRequestException ex) {
            System.out.println("Something went wrong communicating with the Datacat: " + ex);
            throw new JspException("Something went wrong communicating with the Datacat, "
                    + "check configuration and verify datacat is up: ", ex);
        } catch (DcClientException ex) {
            System.out.println("A Client Error occurred. Please check input: " + ex);
            throw new JspException("A Client Error occurred. Please check input", ex);
        } catch (Exception ex) {
            ex.printStackTrace();
            throw new JspException("Error in dcRegister tag", ex);
        }
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
    public void setSite(String site) {
        this.site = site;
    }
    public void setLocation(String location) {
        this.location = location;
    }

    public void setMetadata(Map<String,Object> metadata) {
        this.metadata = metadata;
        numerify();
    }
    
    public void setVar(String var) {
        this.var = var;
    }
    
    private void numerify() {
        for (String key : metadata.keySet()) {
            try {
                metadata.put(key, new BigDecimal(metadata.get(key).toString()));
            } catch (NumberFormatException ex) {
                // chill
            }
        }
    }
}
