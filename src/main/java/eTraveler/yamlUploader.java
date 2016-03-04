package eTraveler;

import java.util.Map;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;
import javax.servlet.http.HttpServletRequest;

import org.lsst.camera.etraveler.backend.node.Traveler;

/**
 *
 * @author focke
 */
public class yamlUploader extends SimpleTagSupport {
    private String var;
    private Map<String, String> parms;

    @Override
    public void doTag() throws JspException {
        PageContext context = (PageContext) getJspContext();
        HttpServletRequest req = (HttpServletRequest) context.getRequest();
        Map<String, String> resMap = Traveler.ingest(req, parms);
        context.setAttribute(var, resMap);
    }
    
    public void setParms(Map<String, String> parms) {
        this.parms = parms;
    }
    
    public void setVar(String var) {
        this.var = var;
    }
}
