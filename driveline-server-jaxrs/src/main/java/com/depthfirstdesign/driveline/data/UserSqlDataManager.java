// UserSqlDataManager.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.data;

import com.depthfirstdesign.driveline.exception.ApiException;
import com.depthfirstdesign.driveline.model.*;
import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import org.apache.commons.lang.exception.ExceptionUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserSqlDataManager extends SqlDataManager {
    private static UserSqlDataManager instance;

    public User findUserByEmail(String email) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("select * from `user` where email=? and deleted=0");
            stmt.setString(1, email);
            ResultSet rst = stmt.executeQuery();
            if (rst.first()){
                 User u = new User(rst.getString("email"), rst.getString("firstname"), rst.getString("lastname"),
                        rst.getString("password"), rst.getString("phone"), rst.getInt("seats"), rst.getFloat("lastLatitude"), rst.getFloat("lastLongitude"));
                 rst.close();
                 PreparedStatement stmt2 = conn.prepareStatement("select * from `user_group` where email=?");
                 stmt2.setString(1, email);
                 rst = stmt2.executeQuery();
                 u.setUserStatus(0);
                 while (rst.next()){
                     if (rst.getInt("status") > u.getUserStatus()) u.setUserStatus(rst.getInt("status"));
                 }
                 rst.close();
                 return u;
            }

        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
        return null;
    }

    public boolean isUserAuthorized(String email, String password) throws ApiException{
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("select * from `user` where email=? and password=?");
            stmt.setString(1, email);
            stmt.setString(2, password);
            ResultSet rst = stmt.executeQuery();
            if (rst.first()){
                if (rst.getString("email").equals(email) && rst.getString("password").equals(password)) return true;
            }
            return false;
        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public void addUser(User user) throws ApiException{
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("INSERT INTO `driveline`.`user` "
                    + "(`email`, `firstname`, `lastname`, `phone`, `password`, `deleted`, `seats`," +
                    "   `lastLatitude`, `lastLongitude`)"
                    + " VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?);");
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getFirstName());
            stmt.setString(3, user.getLastName());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getPassword());
            stmt.setInt(6, 0);
            stmt.setInt(7, user.getSeats());
            // Users location is initially unknown so position cooridinates
            // larger than 999 are treated as invalid by client apps
            stmt.setFloat(8, 999f);
            stmt.setFloat(9, 999f);
            int rc = stmt.executeUpdate();
            if (rc != 1){
                throw new ApiException(500, "A non-cardinal number returned from User insert statement.  RC was " + rc);
            }
        }
        catch(MySQLIntegrityConstraintViolationException e){
            String message = "Attempted to create a new user with email '" + user.getEmail() + "'" +
                    " but user already exists (FORBIDDEN).";
            Logger.getAnonymousLogger().log(Level.WARNING, message);
            throw new ApiException(403, message);
        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public void updateUser(String email, User user) throws ApiException{
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("update `driveline`.`user` "
                    + "set `email`=?, `firstname`=?, `lastname`=?, `phone`=?, `password`=?, `deleted`=?, `seats`=?, "
                    + "lastLatitude=?, lastLongitude=? where email=?");
            stmt.setString(1, user.getEmail());
            stmt.setString(2, user.getFirstName());
            stmt.setString(3, user.getLastName());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getPassword());
            stmt.setInt(6, user.getDeleted());
            stmt.setInt(7, user.getSeats());
            stmt.setFloat(8, user.getLastLatitude());
            stmt.setFloat(9, user.getLastLongitude());
            stmt.setString(10, user.getEmail());
            int rc = stmt.executeUpdate();
            if (rc == 0){
                throw new ApiException(404, "No user found with the requested username.  RC was " + rc);
            }
            if (rc != 1){
                throw new ApiException(500, "A non-cardinal number returned from User insert statement.  RC was " + rc);
            }
        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public void removeUser(String email) throws ApiException{
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("delete from `user` WHERE `email`= ?");
            stmt.setString(1, email);
            int rc = stmt.executeUpdate();
            if (rc == 0){
                throw new ApiException(404, "No users deleted return from user delete statement.  RC was " + rc);
            }
        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public List<Group> getUserGroups(String requestedEmail) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("select `group`.groupId, description, deleted, address, " +
                    "admin_email, `name`, `admin` from `group` inner join user_group on `group`.groupId=`user_group`.groupId " +
                    "where `user_group`.email=? and deleted=0");
            stmt.setString(1, requestedEmail);
            ResultSet rst = stmt.executeQuery();
            List<Group> groups = new ArrayList<Group>();
            while(rst.next()){
                Group g = new Group(rst.getLong("groupId"), rst.getString("name"),
                        rst.getString("admin_email"), rst.getString("description"), rst.getInt("deleted"),
                        rst.getString("address"));
                g.setUsersAdminStatus(rst.getInt("admin"));
                groups.add(g);
            }
            rst.close();
            return groups;
        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public static UserSqlDataManager getInstance() {
        if (instance == null) instance = new UserSqlDataManager();
        return instance;
    }

    private UserSqlDataManager() {
        super();
    }

    public void updateUsersStatus(String email, List<UserStatus> statuses) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            conn.setAutoCommit(false);  // Enable transactions

            for (UserStatus s : statuses){
                PreparedStatement stmt = conn.prepareStatement("UPDATE `user_group` SET `status`=?" +
                        " WHERE `groupId`=? and`email`=?;");
                stmt.setInt(1, (int) s.getStatus());
                stmt.setLong(2, s.getGroupId());
                stmt.setString(3, email);
                int rc = stmt.executeUpdate();
                if (rc == 0){
                    conn.rollback();
                    throw new ApiException(404, "User does not belong to this group.  RC was " + rc);
                }
                if (rc != 1){
                    conn.rollback();
                    throw new ApiException(500, "A non-cardinal number returned from the update statement.  RC was " + rc);
                }
            }
            conn.commit();
        }
        catch (SQLException e){
            try {
                conn.rollback(); // Rollback on any SQL failures
            } catch (SQLException e1) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e1)); // Mega SQL failure... Pray this doesn't happen
            }
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) {
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public void clearDrivingStatuses(String userEmail) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("UPDATE `user_group` SET `status`=0 WHERE `email`=?;");
            stmt.setString(1, userEmail);
            stmt.executeUpdate();
        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) {
                    conn.close();
                }
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public List<UserStatus> getAllStatuses(String requestedUserEmail) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("select * from `user_group` where email=?");
            stmt.setString(1, requestedUserEmail);
            ResultSet rst = stmt.executeQuery();
            ArrayList<UserStatus> statuses = new ArrayList<UserStatus>();
            while (rst.next()){
                UserStatus us = new UserStatus();
                us.setStatus(rst.getInt("status"));
                us.setGroupId(rst.getLong("groupId"));
                statuses.add(us);
            }
            rst.close();
            return statuses;

        }
        catch (SQLException e){
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        }
        finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }
}