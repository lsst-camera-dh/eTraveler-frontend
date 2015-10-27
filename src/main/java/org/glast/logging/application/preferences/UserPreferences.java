package org.glast.logging.application.preferences;

import org.srs.base.application.Application;
import org.srs.base.application.preferences.ApplicationPreferences;

/**
 *
 * @author The FreeHEP team @ SLAC.
 */
public class UserPreferences implements ApplicationPreferences {
    
    public String writeable = "true";
    public String siteName = "SLAC";
    public String jhName = "UNSET";
    public String idAuthName = "null";
    public int pageLength = 10;
    public int componentHeight = 99;
    public int componentDepth = 1;
    public String showFilteredColumns = "false";

    public String getWriteable() {
        return writeable;
    }
    public void setWriteable(String writeable) {
        this.writeable = writeable;
    }    

    public String getSiteName() {
        return siteName;
    }
    public void setSiteName(String siteName) {
        this.siteName = siteName;    
    }

    public String getJhName() {
        return jhName;
    }
    public void setJhName(String jhName) {
        this.jhName = jhName;    
    }

    public String getIdAuthName() {
        return idAuthName;
    }
    public void setIdAuthName(String idAuthName) {
        this.idAuthName = idAuthName;    
    }

    public int getPageLength() {
        return pageLength;
    }
    public void setPageLength(int pageLength) {
        this.pageLength = pageLength;
    }

    public int getComponentHeight() {
        return componentHeight;
    }
    public void setComponentHeight(int componentHeight) {
        this.componentHeight = componentHeight;
    }

    public int getComponentDepth() {
        return componentDepth;
    }
    public void setComponentDepth(int componentDepth) {
        this.componentDepth = componentDepth;
    }

    public String getShowFilteredColumns() {
        return showFilteredColumns;
    }
    public void setShowFilteredColumns(String showFilteredColumns) {
        this.showFilteredColumns = showFilteredColumns;
    }

    public void synchronizeWithApplication(Application app, ApplicationPreferences oldPreferences) {
    }


}
