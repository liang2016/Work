/*
    LssclM2M - http://www.lsscl.com
    Copyright (C) 2006-2011 Lsscl ES Technologies Inc.
     
    
     
     
     
     

     
     
     
     

     
    
 */
package com.serotonin.mango.web.servlet;

import java.io.IOException;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.serotonin.mango.Common;
import com.serotonin.mango.vo.User;

/**
 *  
 */
public class ReportChartServlet extends BaseInfoServlet {
    private static final long serialVersionUID = -1;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        // The only place that should be calling this servlet is the report chart, generated by a Freemarker
        // template. The ReportChartCreator that controlled the generation put the generated image content into the
        // user object, so all i need to do is write that content to the response object.
        User user = Common.getUser(request);
        if (user != null) {
            Map<String, byte[]> imageData = user.getReportImageData();
            if (imageData != null) {
                String path = request.getPathInfo();

                // Path will be of the format "/<chartName>", so we need to ignore the first character.
                byte[] data = imageData.get(path.substring(1));
                if (data != null)
                    response.getOutputStream().write(data);
            }
        }
    }
}