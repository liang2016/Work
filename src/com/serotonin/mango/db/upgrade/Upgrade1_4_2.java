/*
    LssclM2M - http://www.lsscl.com
    Copyright (C) 2006-2011 Lsscl ES Technologies Inc.
     
    
     
     
     
     

     
     
     
     

     
    
 */
package com.serotonin.mango.db.upgrade;

import java.io.OutputStream;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 *  
 */
public class Upgrade1_4_2 extends DBUpgrade {
    private final Log log = LogFactory.getLog(getClass());

    @Override
    public void upgrade() throws Exception {
        OutputStream out = createUpdateLogOutputStream("1_4_2");

        // Run the script.
        log.info("Running script");
        runScript(script, out);

        out.flush();
        out.close();
    }

    @Override
    protected String getNewSchemaVersion() {
        return "1.5.0";
    }

    private static String[] script = {
            "alter table pointViews alter dataPointId null;",
            "alter table scheduledEvents add alias varchar(255);",
            "alter table pointViews add displayControls char(1) default 'Y' not null;",

            "create table staticViews (",
            "  id int not null generated by default as identity (start with 1, increment by 1),",
            "  mangoViewId int not null,",
            "  x int not null,",
            "  y int not null,",
            "  content clob",
            ");",
            "alter table staticViews add constraint staticViewsPk primary key (id);",
            "alter table staticViews add constraint staticViewsFk1 foreign key (mangoViewId) references mangoViews(id);", };
}