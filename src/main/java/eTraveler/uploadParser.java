
package eTraveler;

import java.security.MessageDigest;

import javax.servlet.jsp.JspException;
import javax.servlet.jsp.JspContext;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.fileupload.FileItem;
import org.apache.commons.codec.binary.Hex;

public class uploadParser extends SimpleTagSupport {
    private FileItem fileItem;
    private String varName;
    private String varFormat;
    private String varSize;
    private String varSha1;

    @Override
    public void doTag() throws JspException {
        JspContext context = getJspContext();
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-1");
            String inputName = fileItem.getName();
            String fileName = FilenameUtils.getName(inputName);
            context.setAttribute(varName, fileName);
            String extension = FilenameUtils.getExtension(inputName);
            context.setAttribute(varFormat, extension);
            Long size = fileItem.getSize();
            context.setAttribute(varSize, size);
            md.update(fileItem.get());
            String digest = new String(Hex.encodeHex(md.digest()));
            context.setAttribute(varSha1, digest);
        } catch (Exception ex) {
            throw new JspException("Error in uploadParser tag", ex);
        }
    }

    public void setFileItem(FileItem item) {
        fileItem = item;
    }
    public void setVarName(String name) {
        varName = name;
    }
    public void setVarFormat(String format) {
        varFormat = format;
    }
    public void setVarSize(String vs) {
        varSize = vs;
    }
    public void setVarSha1(String name) {
        varSha1 = name;
    }
}
