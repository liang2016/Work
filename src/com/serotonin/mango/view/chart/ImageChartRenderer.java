/*
    LssclM2M - http://www.lsscl.com
    Copyright (C) 2006-2011 Lsscl ES Technologies Inc.
     
    
     
     
     
     

     
     
     
     

     
    
 */
package com.serotonin.mango.view.chart;

import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.Map;

import com.serotonin.json.JsonRemoteEntity;
import com.serotonin.mango.DataTypes;
import com.serotonin.mango.view.ImplDefinition;
import com.serotonin.mango.vo.DataPointVO;

@JsonRemoteEntity
public class ImageChartRenderer extends TimePeriodChartRenderer {
    private static ImplDefinition definition = new ImplDefinition("chartRendererImage", "IMAGE", "chartRenderer.image",
            new int[] { DataTypes.BINARY, DataTypes.MULTISTATE, DataTypes.NUMERIC });

    public static ImplDefinition getDefinition() {
        return definition;
    }

    public String getTypeName() {
        return definition.getName();
    }

    public ImageChartRenderer() {
        // no op
    }

    public ImageChartRenderer(int timePeriod, int numberOfPeriods) {
        super(timePeriod, numberOfPeriods);
    }

    public void addDataToModel(Map<String, Object> model, DataPointVO point) {
        // Nothing to do.
    }

    public ImplDefinition getDef() {
        return definition;
    }

    //
    // /
    // / Serialization
    // /
    //
    private static final long serialVersionUID = -1;
    private static final int version = 1;

    private void writeObject(ObjectOutputStream out) throws IOException {
        out.writeInt(version);
    }

    private void readObject(ObjectInputStream in) throws IOException {
        in.readInt();
    }
}