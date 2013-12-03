// Authorizer.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.util;

import com.depthfirstdesign.driveline.data.UserSqlDataManager;
import com.depthfirstdesign.driveline.exception.ApiException;

public class Authorizer {
    public static boolean authorize(String email, String password) throws ApiException{
        if (UserSqlDataManager.getInstance().isUserAuthorized(email, password)) return true;
        else throw new ApiException(401,  "Authorization refused for specified credentials");
    }
}
