// GroupSqlDataManager.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.data;

import com.depthfirstdesign.driveline.exception.ApiException;
import com.depthfirstdesign.driveline.model.*;
import com.mysql.jdbc.exceptions.jdbc4.MySQLIntegrityConstraintViolationException;
import org.apache.commons.lang.exception.ExceptionUtils;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class GroupSqlDataManager extends SqlDataManager {
    private static GroupSqlDataManager instance;

    public Group getGroupById(long groupId) throws ApiException {
        Connection conn = null;
        try {
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("select * from `group` where groupId=? and deleted=0");
            stmt.setLong(1, groupId);
            ResultSet rst = stmt.executeQuery();
            if (rst.first()) {
                return new Group(rst.getLong("groupId"), rst.getString("name"),
                        rst.getString("admin_email"), rst.getString("description"), rst.getInt("deleted"), rst.getString("address"));
            }
            rst.close();
        } catch (SQLException e) {
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
        return null;
    }

    public List<Group> findGroupBySearchKeyword(String keyword) throws ApiException {
        Connection conn = null;
        try {
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("select * from `group` where `name` like CONCAT('%',CONCAT(?,'%')) and deleted=0;");
            stmt.setString(1, keyword);
            ResultSet rst = stmt.executeQuery();
            List<Group> matchingGroups = new ArrayList<Group>();
            while (rst.next()) {
                matchingGroups.add(
                        new Group(rst.getLong("groupId"), rst.getString("name"),
                                rst.getString("admin_email"), rst.getString("description"), rst.getInt("deleted"),
                                rst.getString("address"))
                );
            }
            rst.close();
            return matchingGroups;
        } catch (SQLException e) {
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public Group addGroup(Group group) throws ApiException {
        Connection conn = null;
        try {
            conn = getFreeConnection();
            addGroup(conn, group);
            return group;
        } catch (MySQLIntegrityConstraintViolationException e) {
            String message = "Attempted to create a new group with id '" + group.getId() + "'" +
                    " but group already exists (FORBIDDEN).";
            Logger.getAnonymousLogger().log(Level.WARNING, message);
            throw new ApiException(403, message);
        } catch (SQLException e) {
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    private void addGroup(Connection conn, Group group) throws SQLException, ApiException {
        PreparedStatement stmt = conn.prepareStatement("INSERT INTO `driveline`.`group` "
                + "(`description`, `admin_email`, `deleted`, `address`, `name`)"
                + " VALUES (?, ?, ?, ?, ?);");
        stmt.setString(1, group.getDescription());
        stmt.setString(2, group.getAdminEmail());
        stmt.setInt(3, group.getDeleted());
        stmt.setString(4, group.getAddress());
        stmt.setString(5, group.getName());
        int rc = stmt.executeUpdate();
        if (rc != 1) {
            throw new ApiException(500, "A non-cardinal number returned from Group insert statement.  RC was " + rc);
        }
        // Use the MySQL LAST_INSERT_ID() (guaranteed to work atomically per connection)
        long autoIncKeyFromFunc = -1;
        ResultSet rs = stmt.executeQuery("SELECT LAST_INSERT_ID()");
        if (rs.next())autoIncKeyFromFunc = rs.getLong(1);
        else
            throw new ApiException(500, "The groupId was not retrieved!  This is a fatal MySQL error  RC was " + rc);
        rs.close();
        group.setId(autoIncKeyFromFunc);
    }

    public void updateGroup(Group group) throws ApiException{
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("update `driveline`.`group` "
                    + "set `description`=?, `admin_email`=?, `deleted`=?, `address`=?, `name`=?  "
                    + "where groupId=?;");
            stmt.setString(1, group.getDescription());
            stmt.setString(2, group.getAdminEmail());
            stmt.setInt(3, group.getDeleted());
            stmt.setString(4, group.getAddress());
            stmt.setString(5, group.getName());
            stmt.setLong(6, group.getId());
            int rc = stmt.executeUpdate();
            if (rc == 0){
                throw new ApiException(404, "No Group found with the requested id.  RC was " + rc);
            }
            if (rc != 1){
                throw new ApiException(500, "A non-cardinal number returned from Group update statement.  RC was " + rc);
            }
            conn.close();
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

    public List<User> getAllGroupsUsers(long groupId) throws ApiException {
        Connection conn = null;
        try {
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("select `user`.email, firstname, lastname, phone, " +
                    "`password`, deleted, seats, admin, status, lastLatitude, lastLongitude from `user` " +
                    "inner join user_group on `user`.email=`user_group`.email " +
                    "where `user_group`.groupId=? and deleted=0");
            stmt.setLong(1, groupId);
            ResultSet rst = stmt.executeQuery();
            List<User> users = new ArrayList<User>();
            while(rst.next()) {
                User u = new User(rst.getString("email"), rst.getString("firstname"), rst.getString("lastname"),
                        rst.getString("password"), rst.getString("phone"), rst.getInt("seats"), rst.getFloat("lastLatitude"),
                        rst.getFloat("lastLongitude"));
                u.setAdmin(rst.getInt("admin"));
                u.setUserStatus(rst.getInt("status"));
                users.add(u);
            }
            rst.close();
            return users;
        } catch (SQLException e) {
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public static GroupSqlDataManager getInstance() {
        if (instance == null) instance = new GroupSqlDataManager();
        return instance;
    }

    private GroupSqlDataManager() {
        super();
    }

    public void removeGroup(long idForDeletion) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("delete from `group` WHERE `groupId`= ?");
            stmt.setLong(1, idForDeletion);
            int rc = stmt.executeUpdate();
            if (rc == 0){
                throw new ApiException(404, "No groups deleted during group delete statement.  RC was " + rc);
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

    public void addUserToGroup(long groupId, String newMemberEmail, int adminRights) throws ApiException {
        Connection conn = null;
        try {
            conn = getFreeConnection();
            addUserToGroup(conn, groupId, newMemberEmail, adminRights);
        } catch (MySQLIntegrityConstraintViolationException e) {
            String message = "Attempted to add user to group with id '" + groupId + "'" +
                    " but a user already exists for that group (FORBIDDEN).";
            Logger.getAnonymousLogger().log(Level.WARNING, message);
            throw new ApiException(403, message);
        } catch (SQLException e) {
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    private void addUserToGroup(Connection conn, long groupId, String newMemberEmail, int adminRights)
            throws SQLException, ApiException {
        PreparedStatement stmt = conn.prepareStatement("INSERT INTO `driveline`.`user_group` " +
                "(`groupId`, `email`, `status`, `admin`) VALUES (?, ?, ?, ?);");
        stmt.setLong(1, groupId);
        stmt.setString(2, newMemberEmail);
        stmt.setInt(3, 0);
        stmt.setInt(4, adminRights);
        int rc = stmt.executeUpdate();
        if (rc != 1) {
            throw new ApiException(500, "A non-cardinal number returned from Group insert statement.  RC was " + rc);
        }
    }

    public Group createGroupAsAdmin(String email, Group group) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            conn.setAutoCommit(false);
            addGroup(conn, group);
            addUserToGroup(conn, group.getId(), email, 1);
            conn.commit();
        } catch (SQLException e) {
            try{
                conn.rollback();    // Rollback the failed transaction
            }
            catch(SQLException e1){
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e1));
            }
            throw new ApiException(500, "Error creating group: " + ExceptionUtils.getFullStackTrace(e));
        } finally{
            try {
                if (conn != null){
                    conn.setAutoCommit(true);
                    conn.close();
                }
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
            return group;
        }
    }

    public void removeUserFromGroup(long groupId, String newMemberEmail) throws ApiException {
        Connection conn = null;
        try {
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("DELETE FROM `user_group`  where " +
                    "`groupId`=? AND `email`= ?;");
            stmt.setLong(1, groupId);
            stmt.setString(2, newMemberEmail);
            int rc = stmt.executeUpdate();
            if (rc != 1) {
                throw new ApiException(500, "A non-cardinal number returned from delete statement.  RC was " + rc);
            }
        } catch (SQLException e) {
            Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
            throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
        } finally {
            try {
                if (conn != null) conn.close();
            } catch (SQLException e) {
                Logger.getAnonymousLogger().log(Level.SEVERE, ExceptionUtils.getFullStackTrace(e));
                throw new ApiException(500, ExceptionUtils.getFullStackTrace(e));
            }
        }
    }

    public void acceptUserToGroup(String acceptedUserEmail, long acceptingGroupId) throws ApiException {
        Connection conn = null;
        try{
            conn = getFreeConnection();
            PreparedStatement stmt = conn.prepareStatement("UPDATE `user_group` SET `admin`=0 WHERE `email`=? and `groupId`=?;");
            stmt.setString(1, acceptedUserEmail);
            stmt.setLong(2, acceptingGroupId);
            int rc = stmt.executeUpdate();
            if (rc < 1) throw new ApiException(404, "User not in group with id = " + acceptingGroupId);
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
}