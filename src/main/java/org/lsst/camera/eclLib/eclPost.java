package org.lsst.camera.eclLib ;

import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.JspFragment;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.lsst.ccs.elog.ELogConnectionUtils;
import org.lsst.ccs.elog.ElogEntry;
import org.lsst.ccs.elog.ElogTransactionResult;

/**
 *
 * @author focke
 */
public class eclPost extends SimpleTagSupport {
    private String text;
    private String author;
    private String dataSourceMode;
    private String hardwareTypeId;
    private String hardwareGroupId;
    private String hardwareId;
    private String processId;
    private String activityId;
    private String category;
    private String version;
    private String url;
    
    private ELogConnectionUtils conn;
    private ElogEntry entry;
    private ElogTransactionResult result;

    /**
     * Called by the container to invoke this tag. The implementation of this
     * method is provided by the tag library developer, and handles all tag
     * processing, body iteration, etc.
     * @throws javax.servlet.jsp.JspException
     */
    @Override
    public void doTag() throws JspException {
        System.setProperty("org.lsst.ccs.elog.xml.url", url);
        JspWriter out = getJspContext().getOut();
        try {
/**
            out.println("Author: " + author + "<br>");
            out.println("DataSourceMode: " + dataSourceMode + "<br>");
            out.println("Activity: " + activityId + "<br>");
            out.println("Process: " + processId + "<br>");
            out.println("Component: " + hardwareId + "<br>");
            out.println("Component Type: " + hardwareTypeId + "<br>");
            out.println("Category: " + category + "<br>");
            out.println("Component Group: " + hardwareGroupId + "<br>");
            out.println("Text: " + text + "<br>");
**/
            conn = new ELogConnectionUtils();
            entry = new ElogEntry();
            entry.setAuthor(author);
            entry.setCategory(category);
            entry.setFormName("eTraveler entry");
            entry.setFormField("Author", author);
            entry.setFormField("DataSourceMode", dataSourceMode);
            entry.setFormField("ActivityId", activityId);
            entry.setFormField("ProcessId", processId);
            entry.setFormField("ComponentId", hardwareId);
            entry.setFormField("HardwareTypeId", hardwareTypeId);
            entry.setFormField("HardwareGroupId", hardwareGroupId);
            entry.setFormField("text", text);
            result = conn.postEntryToElog(entry, version);

            JspFragment f = getJspBody();
            if (f != null) {
                f.invoke(out);
            }

        } catch (java.io.IOException ex) {
            throw new JspException("Error in eclPost tag", ex);
        }
    }

    public void setText(String text) {
        this.text = text;
    }
    public void setAuthor(String author) {
        this.author = author;
    }
    public void setDataSourceMode(String dataSourceMode) {
        this.dataSourceMode = dataSourceMode;
    }
    public void setHardwareTypeId(String hardwareTypeId) {
        this.hardwareTypeId = hardwareTypeId;
    }
    public void setHardwareGroupId(String hardwareGroupId) {
        this.hardwareGroupId = hardwareGroupId;
    }
    public void setHardwareId(String hardwareId) {
        this.hardwareId = hardwareId;
    }
    public void setProcessId(String processId) {
        this.processId = processId;
    }
    public void setActivityId(String activityId) {
        this.activityId = activityId;
    }
    public void setCategory(String category) {
        this.category = category;
    }
    public void setVersion(String version) {
        this.version = version;
    }
    public void setUrl(String url) {
        this.url = url;
    }
}
