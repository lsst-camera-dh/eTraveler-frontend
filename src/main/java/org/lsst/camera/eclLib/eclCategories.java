package org.lsst.camera.eclLib;

import java.lang.System;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.lsst.ccs.elog.ELogConnectionUtils;

/**
 *
 * @author focke
 */
public class eclCategories extends SimpleTagSupport {
    private String var;
    private String version;
    private String url;

    @Override
    public void doTag() throws JspException {
        System.setProperty("org.lsst.ccs.elog.xml.url", url);
        JspContext context = getJspContext();
        try {
            java.util.List categories = ELogConnectionUtils.getCategories(version);
            context.setAttribute(var, categories);

        } catch (java.io.IOException ex) {
            throw new JspException("Error in eclCategories tag", ex);
        }
    }
    
    public void setVar(String var) {
        this.var = var;
    }
    
    public void setVersion(String version) {
        this.version = version;
    }
    
    public void setUrl(String url) {
        this.url = url;
    }
}
