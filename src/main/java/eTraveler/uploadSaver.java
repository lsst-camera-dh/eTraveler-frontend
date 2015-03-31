
package eTraveler;

import java.io.File;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.SimpleTagSupport;

import org.apache.commons.fileupload.FileItem;

public class uploadSaver extends SimpleTagSupport {
    private FileItem fileItem;
    private String path;

    @Override
    public void doTag() throws JspException {
        JspWriter out = getJspContext().getOut();

        try {
            out.write(path);
            File uploadedFile = new File(path);
            File directory = new File(uploadedFile.getParentFile().getAbsolutePath());
            boolean mdOk = directory.mkdirs();
            if (directory.exists()) {
                fileItem.write(uploadedFile);
            } else {
                out.write("couldn't make directory");
            }
        } catch (Exception ex) {
            throw new JspException("Error in uploadSaver tag", ex);
        }
    }

    public void setFileItem(FileItem item) {
        fileItem = item;
    }
    public void setPath(String path) {
        this.path = path;
    }
}
