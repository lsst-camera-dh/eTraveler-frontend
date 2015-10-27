package org.lsst.camera.eclLib ;
/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

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
    private String hardwareTypeId;
    private String hardwareId;
    private String processId;
    private String activityId;
    private String version;
    
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
        JspWriter out = getJspContext().getOut();
        try {
            // TODO: insert code to write html before writing the body content.
            // e.g.:
            //
            // out.println("<strong>" + attribute_1 + "</strong>");
            // out.println("    <blockquote>");
/**
            out.println("Author: " + author + "<br>");
            out.println("Activity: " + activityId + "<br>");
            out.println("Process: " + processId + "<br>");
            out.println("Component: " + hardwareId + "<br>");
            out.println("Component Type: " + hardwareTypeId + "<br>");
            out.println("Text: " + text + "<br>");
**/
            conn = new ELogConnectionUtils();
            entry = new ElogEntry();
            entry.setAuthor(author);
            entry.setCategory("Testing");
            entry.setFormName("eTraveler entry");
            entry.setFormField("Author", author);
            entry.setFormField("ActivityId", activityId);
            entry.setFormField("ProcessId", processId);
            entry.setFormField("ComponentId", hardwareId);
            entry.setFormField("HardwareTypeId", hardwareTypeId);
            entry.setFormField("text", text);
            result = conn.postEntryToElog(entry, version);

            JspFragment f = getJspBody();
            if (f != null) {
                f.invoke(out);
            }

            // TODO: insert code to write html after writing the body content.
            // e.g.:
            //
            // out.println("    </blockquote>");
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
    public void setHardwareTypeId(String hardwareTypeId) {
        this.hardwareTypeId = hardwareTypeId;
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
    public void setVersion(String version) {
        this.version = version;
    }
}
