/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.lsst.camera.eclLib;

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

    @Override
    public void doTag() throws JspException {
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
}
