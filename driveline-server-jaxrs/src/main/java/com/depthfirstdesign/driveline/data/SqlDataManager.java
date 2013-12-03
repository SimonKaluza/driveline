// SqlDataManager.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.data;

import javax.naming.InitialContext;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class SqlDataManager {
    protected DataSource ds;
    public SqlDataManager() {
        Logger.getAnonymousLogger().log(Level.INFO, "Retrieving context and database pool for SqlDataManager " + this.getClass().getCanonicalName());
        try{
            InitialContext ctx = new InitialContext();
            if(ctx == null )throw new Exception("Fatal error - No Context");
            ds =(DataSource)ctx.lookup("java:comp/env/jdbc/driveline-dbcp");
        }
        catch(Exception e){
            Logger.getAnonymousLogger().log(Level.SEVERE, e.getMessage());
        }
    }

    public Connection getFreeConnection() throws SQLException {
        return ds.getConnection();
    }
}
