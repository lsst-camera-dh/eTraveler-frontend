
package eTraveler;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.srs.vfs.PathUtils;

/**
 *
 * @author focke
 */
public class JhParser extends SimpleTagSupport {
    private String jhName;
    private String varPath;
    private String varName;
    
    @Override
    public void doTag() throws JspException {
        JspContext context = getJspContext();
        try {
            jhName = PathUtils.normalize(jhName);
            String path = PathUtils.getParentPath(jhName);
            context.setAttribute(varPath, path);
            String name = PathUtils.getFileName(jhName);
            context.setAttribute(varName, name);
        } catch (Exception ex) {
            throw new JspException("Error in jhParser tag", ex);
        }
    }

    public void setJhName(String name) {
        jhName = name;
    }

    public void setVarPath(String name) {
        varPath = name;
    }

    public void setVarName(String name) {
        varName = name;
    }
}
