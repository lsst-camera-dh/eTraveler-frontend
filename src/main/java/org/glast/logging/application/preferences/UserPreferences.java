package org.glast.logging.application.preferences;

import java.util.List;
import java.util.Map;
import org.srs.base.application.Application;
import org.srs.base.application.preferences.ApplicationPreferences;
import org.srs.web.base.utils.HistoryList;
import org.srs.web.base.utils.HistoryMap;

/**
 *
 * @author The FreeHEP team @ SLAC.
 */
public class UserPreferences implements ApplicationPreferences {
    
    private static final int SIZE = 64;
    
    public List eventSelectionHistory = new HistoryList(SIZE);
    public List userSelectionHistory = new HistoryList(SIZE);
    public List programSelectionHistory = new HistoryList(SIZE);
    public List gidSelectionHistory = new HistoryList(SIZE);
    public List tgtSelectionHistory = new HistoryList(SIZE);
    public List hostSelectionHistory = new HistoryList(SIZE);
    public Map configurationMap = new HistoryMap(SIZE);
    public String tableColumns = "Event Time,Posted Time,Level,Event,Message,Host,Target,Link";
    
    public String eventTimeColumnWidth = "";
    public String postedTimeColumnWidth = "";
    public String levelColumnWidth = "";
    public String eventColumnWidth = "";
    public String messageColumnWidth = "";
    public String hostColumnWidth = "";
    public String targetColumnWidth = "";
    public String programColumnWidth = "";
    public String userColumnWidth = "";
    public String gidColumnWidth = "";
    public String pidColumnWidth = "";
    public String scidColumnWidth = "";
    public String linkColumnWidth = "";
    

    public String getEventTimeColumnWidth() {
        return eventTimeColumnWidth;
    }
        
    public void setEventTimeColumnWidth(String colWidth) {
        eventTimeColumnWidth = colWidth;
    }    

    public String getPostedTimeColumnWidth() {
        return postedTimeColumnWidth;
    }
        
    public void setPostedTimeColumnWidth(String colWidth) {
        postedTimeColumnWidth = colWidth;    
    }

    public String getLevelColumnWidth() {
        return levelColumnWidth;
    }
        
    public void setLevelColumnWidth(String colWidth) {
        levelColumnWidth = colWidth;    
    }
    
    public String getEventColumnWidth() {
        return eventColumnWidth;
    }
        
    public void setEventColumnWidth(String colWidth) {
        eventColumnWidth = colWidth;    
    }
    
    public String getMessageColumnWidth() {
        return messageColumnWidth;
    }
        
    public void setMessageColumnWidth(String colWidth) {
        messageColumnWidth = colWidth;    
    }
    
    public String getHostColumnWidth() {
        return hostColumnWidth;
    }
        
    public void setHostColumnWidth(String colWidth) {
        hostColumnWidth = colWidth;    
    }

    public String getTargetColumnWidth() {
        return targetColumnWidth;
    }
        
    public void setTargetColumnWidth(String colWidth) {
        targetColumnWidth = colWidth;    
    }

    public String getProgramColumnWidth() {
        return programColumnWidth;
    }
        
    public void setProgramColumnWidth(String colWidth) {
        programColumnWidth = colWidth;    
    }
    
    public String getUserColumnWidth() {
        return userColumnWidth;
    }
        
    public void setUserColumnWidth(String colWidth) {
        userColumnWidth = colWidth;    
    }
    
    public String getGidColumnWidth() {
        return gidColumnWidth;
    }
        
    public void setGidColumnWidth(String colWidth) {
        gidColumnWidth = colWidth;    
    }
    
    public String getPidColumnWidth() {
        return pidColumnWidth;
    }
        
    public void setPidColumnWidth(String colWidth) {
        pidColumnWidth = colWidth;    
    }
    
    public String getScidColumnWidth() {
        return scidColumnWidth;
    }
        
    public void setScidColumnWidth(String colWidth) {
        scidColumnWidth = colWidth;    
    }    

    public String getLinkColumnWidth() {
        return linkColumnWidth;
    }
        
    public void setLinkColumnWidth(String colWidth) {
        linkColumnWidth = colWidth;    
    }    
    
    public String getTableColumns() {
        return tableColumns;
    }
        
    public void setTableColumns(String tableColumns) {
        this.tableColumns = tableColumns;
    }
    
    public List getEventSelection() {
        return eventSelectionHistory;
    }
    
    public void setEventSelection(List list) {
        eventSelectionHistory = list;
    }

    public List getHostSelection() {
        return hostSelectionHistory;
    }
    
    public void setHostSelection(List list) {
        hostSelectionHistory = list;
    }
    
    public List getTgtSelection() {
        return tgtSelectionHistory;
    }
    
    public void setTgtSelection(List list) {
        tgtSelectionHistory = list;
    }

    public List getGidSelection() {
        return gidSelectionHistory;
    }
    
    public void setGidSelection(List list) {
        gidSelectionHistory = list;
    }

    public List getUsrSelection() {
        return userSelectionHistory;
    }
    
    public void setUsrSelection(List list) {
        userSelectionHistory = list;
    }

    public List getProgSelection() {
        return programSelectionHistory;
    }
    
    public void setProgSelection(List list) {
        programSelectionHistory = list;
    }

    public void addToConfiguration(String configuration, String value) {
        configurationMap.put(configuration,value);
    }
    
    public Map getConfiguration() {
        return configurationMap;
    }
    
    public void setConfiguration(Map configurationMap) {
        this.configurationMap = configurationMap;
    }
    

    public void synchronizeWithApplication(Application app, ApplicationPreferences oldPreferences) {
    }


}
