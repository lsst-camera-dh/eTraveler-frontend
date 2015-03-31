/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package org.lsst.camera.formResults;

/**
 *
 * @author focke
 */
public class inputResult {
    
    int activityId;
    int inputPatternId;
    String isName;
    String value;
    
    public void setActivityId(int value)
    {
        activityId = value;
    }
    public int getActivityId() {return activityId;}
    
    public void setInputPatternId(int value)
    {
        inputPatternId = value;
    }
    public int getInputPatternId() {return inputPatternId;}
    
    public void setIsName(String value)
    {
        isName = value;
    }
    public String getIsName() {return isName;}
    
    public void setValue(String value)
    {
        this.value = value;
    }
    public String getValue() {return value;}
}
