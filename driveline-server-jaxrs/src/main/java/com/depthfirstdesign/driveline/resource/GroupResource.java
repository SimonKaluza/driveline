// GroupResource.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.resource;

import com.depthfirstdesign.driveline.data.GroupSqlDataManager;
import com.depthfirstdesign.driveline.exception.ApiException;
import com.depthfirstdesign.driveline.model.User;
import com.depthfirstdesign.driveline.util.Authorizer;
import com.wordnik.swagger.annotations.*;
import com.depthfirstdesign.driveline.model.Group;

import javax.annotation.PostConstruct;
import javax.ws.rs.core.Response;
import javax.ws.rs.*;
import java.util.List;

@Path("/group")
@Api(value = "/group", description = "Operations about Driveline Groups")
@Produces({"application/json", "application/xml"})
public class GroupResource {
    private GroupSqlDataManager groupData = GroupSqlDataManager.getInstance();

    @PostConstruct
    private void init() {
        groupData = GroupSqlDataManager.getInstance();
    }

    @GET
    @Path("/get/{groupId}")
    @ApiOperation(value = "getGroup",
            notes = "Returns a group based on Group ID. Non-integers will trigger API error conditions",
            response = Group.class)
    @ApiResponses(value = {@ApiResponse(code = 400, message = "Invalid ID supplied"),
            @ApiResponse(code = 404, message = "Group not found")})
    public Response getGroupById(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "ID of group that needs to be fetched", allowableValues = "range[1,5]", required = true)
            @PathParam("groupId") Long groupId)
            throws ApiException {
        Authorizer.authorize(email, password);
        Group group = groupData.getGroupById(groupId);
        if (null != group) {
            return Response.ok().entity(group).build();
        } else {
            throw new ApiException(404, "Group not found");
        }
    }

    @GET
    @Path("/find-by-keyword")
    @ApiOperation(value = "Finds groups by keyword",
            notes = "Performs a search on all groups that contain the specified character combination.",
            response = Group.class,
            responseContainer = "List")
    @ApiResponses(value = {@ApiResponse(code = 400, message = "Invalid keyword value")})
    public Response findGroupsByKeyword(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "Keyword to filter by", required = true, allowMultiple = true) @QueryParam("keyword") String keyword) throws ApiException {
        Authorizer.authorize(email, password);
        return Response.ok(groupData.findGroupBySearchKeyword(keyword)).build();
    }

    @GET
    @Path("/get-users")
    @ApiOperation(value = "Get all users for group",
            notes = "Gets an array of all users for a particular group",
            response = User.class,
            responseContainer = "List")
    @ApiResponses(value = {
            @ApiResponse(code = 401, message = "Unauthorized (appropriate credentials required)")
    })
    public Response getGroupsUsers(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes")
            @HeaderParam("password") String password,
            @ApiParam(value = "The groupId of the group whose users are sought", required = true)
            @QueryParam("groupId") long groupId) throws ApiException{
        Authorizer.authorize(email, password);
        List<User> groups = groupData.getAllGroupsUsers(groupId);
        return Response.ok(groups).build();
    }

    @POST
    @ApiOperation(value = "createGroup", notes = "Adds a new group to the app", response = Group.class)
    @ApiResponses(value = {@ApiResponse(code = 405, message = "Invalid input")})
    public Response addGroup(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "Group object that needs to be added to the app", required = true) Group group)
            throws ApiException {
        Authorizer.authorize(email, password);
        Group g = groupData.addGroup(group);
        return Response.ok().entity(g).build();
    }

    @POST
    @Path("/asAdmin")
    @ApiOperation(value = "createGroupAsAdmin", notes = "Adds a new group and adds the current user as the first admin member", response = Group.class)
    @ApiResponses(value = {@ApiResponse(code = 405, message = "Invalid input")})
    public Response createGroupAsAdmin(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "Group object that needs to be added to the app", required = true) Group group)
            throws ApiException {
        Authorizer.authorize(email, password);
        Group g = groupData.createGroupAsAdmin(email, group);
        return Response.ok().entity(g).build();
    }

    @POST
    @Path("/addUser/{groupId}/{newMemberEmail}/{adminStatus}")
    @ApiOperation(value = "addUserToGroup", notes = "Adds a specified user to a particular group")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid input"),
            @ApiResponse(code = 404, message = "User or group not found")
    })
    public Response addUserToGroup(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "Group Id of the group for which the User requests membership", required = true)
            @PathParam("groupId") long groupId,
            @ApiParam(value = "Email of address of the User requesting membership", required = true)
            @PathParam("newMemberEmail") String newMemberEmail,
            @ApiParam(value = "User privileges (-1 for unverified user, 0 for regular user, 1 for admin)", required = true)
            @PathParam("adminStatus") int adminStatus)
            throws ApiException {
        Authorizer.authorize(email, password);
        groupData.addUserToGroup(groupId, newMemberEmail, adminStatus);
        return Response.ok().entity("").build();
    }

    @PUT
    @Path("/acceptUserToGroup")
    @ApiOperation(value = "Accept User to Group",
            notes = "Modify a particular User's admin status such that they have driving/riding permissions for a group")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid User supplied"),
            @ApiResponse(code = 404, message = "User not found")})
    public Response acceptUserToGroup(
            @ApiParam(value = "Requesting User's email address for authorization purposes (original)")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "Updated user object", required = true)
            @QueryParam(value="acceptedUserEmail") String acceptedUserEmail,
            @ApiParam(value = "Updated user object", required = true)
            @QueryParam(value="acceptingGroupId")long acceptingGroupId) throws ApiException {
        Authorizer.authorize(email, password);
        groupData.acceptUserToGroup(acceptedUserEmail, acceptingGroupId);
        return Response.ok().entity("").build();
    }

    @PUT
    @Path("/update")
    @ApiOperation(value = "updateGroup", notes = "Updates a Group specified by the groupId")
    @ApiResponses(value = {@ApiResponse(code = 400, message = "Invalid ID supplied"),
            @ApiResponse(code = 404, message = "Group not found"),
            @ApiResponse(code = 405, message = "Validation exception")})
    public Response updateGroup(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "Group object that needs to updated in the database", required = true) Group group) throws ApiException {
        Authorizer.authorize(email, password);
        groupData.updateGroup(group);
        return Response.ok().entity("SUCCESS").build();
    }

    @DELETE
    @Path("/removeUser/{groupId}/{emailForDeletion}")
    @ApiOperation(value = "removeUserFromGroup", notes = "Removes a specified user from a particular group")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid input"),
            @ApiResponse(code = 404, message = "User or group not found")
    })
    public Response removeUserFromGroup(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "Group Id of the group from which to remove the specified user", required = true)
            @PathParam("groupId") long groupId,
            @ApiParam(value = "Email of address of the User leaving the group", required = true)
            @PathParam("emailForDeletion") String emailForDeletion)
            throws ApiException {
        Authorizer.authorize(email, password);
        groupData.removeUserFromGroup(groupId, emailForDeletion);
        return Response.ok().entity("").build();
    }

    @DELETE
    @Path("/delete/{idForDeletion}")
    @ApiOperation(value = "Delete Group", notes = "Deletes the specified Group")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid username supplied or insufficient permissions"),
            @ApiResponse(code = 404, message = "Group not found")})
    public Response deleteGroup(
            @ApiParam(value = "Requesting User's email address for authentication and authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authentication and authorization purposes")
            @HeaderParam("password") String password,
            @ApiParam(value = "The id of the group needs to be deleted", required = true)
            @PathParam("idForDeletion") long idForDeletion)
            throws ApiException {
        Authorizer.authorize(email, password);
        groupData.removeGroup(idForDeletion);
        return Response.ok().entity("").build();
    }
}
