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

/**
 *
 * @author focke
 */
public class eclPost extends SimpleTagSupport {
    private String text;
    private String author;
    private int hardwareTypeId;
    private int hardwareId;
    private int processId;
    private int activityId;

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

            out.println("Author: " + author + "<br>");
            out.println("Activity: " + activityId + "<br>");
            out.println("Process: " + processId + "<br>");
            out.println("Component: " + hardwareId + "<br>");
            out.println("Component Type: " + hardwareTypeId + "<br>");
            out.println("Text: " + text + "<br>");
            
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
    public void setHardwareTypeId(int hardwareTypeId) {
        this.hardwareTypeId = hardwareTypeId;
    }
    public void setHardwareId(int hardwareId) {
        this.hardwareId = hardwareId;
    }
    public void setProcessId(int processId) {
        this.processId = processId;
    }
    public void setActivityId(int activityId) {
        this.activityId = activityId;
    }
    
}
