package org.glast.logging.application.preferences;

import org.srs.base.application.Application;
import org.srs.base.application.preferences.ApplicationPreferences;

/**
 *
 * @author The FreeHEP team @ SLAC.
 */
public class UserPreferences implements ApplicationPreferences {
    
    public String role = "spectator";
    public String siteName = "BNL";
    public String idAuthName = "SerialNumber";
    

    public String getRole() {
        return role;
    }
        
    public void setRole(String role) {
        this.role = role;
    }    

    public String getSiteName() {
        return siteName;
    }
        
    public void setSiteName(String siteName) {
        this.siteName = siteName;    
    }

    public String getIdAuthName() {
        return idAuthName;
    }
        
    public void setIdAuthName(String idAuthName) {
        this.idAuthName = idAuthName;    
    }
    
    public void synchronizeWithApplication(Application app, ApplicationPreferences oldPreferences) {
    }


}
