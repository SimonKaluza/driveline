// SampleExceptionMapper
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.resource;

import com.depthfirstdesign.driveline.exception.ApiException;
import com.depthfirstdesign.driveline.model.ApiResponse;
import org.apache.commons.lang.exception.ExceptionUtils;

import javax.ws.rs.ext.*;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.Status;
import java.util.logging.Level;
import java.util.logging.Logger;

@Provider
public class SampleExceptionMapper implements ExceptionMapper<Exception> {
    public Response toResponse(Exception exception) {
        if (exception instanceof javax.ws.rs.WebApplicationException) {
            javax.ws.rs.WebApplicationException e = (javax.ws.rs.WebApplicationException) exception;
            return Response
                    .status(e.getResponse().getStatus())
                    .entity(new ApiResponse(e.getResponse().getStatus(),
                            exception.getMessage())).build();
        } else if (exception instanceof ApiException) {
            ApiException e = (ApiException) exception;
            return Response.status(e.getCode())
                    .entity(new ApiResponse(e.getCode(), e.getMessage())).build();
        } else if (exception.getClass().getPackage().getName().matches("com\\.fasterxml\\.jackson\\..*")) {
            return Response
                    .status(Status.BAD_REQUEST)
                    .entity(new ApiResponse(400, "Bad REST Request! :'" + exception.getLocalizedMessage() + "'")).build();
        } else {
            Logger.getAnonymousLogger().log(Level.SEVERE, "Unexcepted exception thrown!", exception);
            return Response.status(500)
                    .entity(new ApiResponse(500, ExceptionUtils.getStackTrace(exception)))
                    .build();
        }
    }
}