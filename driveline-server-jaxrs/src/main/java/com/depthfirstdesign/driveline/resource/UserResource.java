// UserResource.java
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

package com.depthfirstdesign.driveline.resource;

import com.depthfirstdesign.driveline.data.UserSqlDataManager;
import com.depthfirstdesign.driveline.exception.ApiException;
import com.depthfirstdesign.driveline.model.Group;
import com.depthfirstdesign.driveline.model.UserStatus;
import com.depthfirstdesign.driveline.util.Authorizer;
import com.wordnik.swagger.annotations.*;
import com.depthfirstdesign.driveline.model.User;

import javax.annotation.PostConstruct;
import javax.ws.rs.core.Response;
import javax.ws.rs.*;
import java.util.ArrayList;
import java.util.List;

@Path("/user")
@Api(value = "/user", description = "Operations on Driveline users")
@Produces({"application/json", "application/xml"})
public class UserResource {
    UserSqlDataManager userData = UserSqlDataManager.getInstance();

    @PostConstruct
    private void init() {
        userData = UserSqlDataManager.getInstance();
    }

    @GET
    @Path("/get/{requestedUserEmail}")
    @ApiOperation(value = "Get User",
            notes = "Return a User object for a specified email address",
            response = User.class)
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid User object supplied"),
            @ApiResponse(code = 404, message = "User not found")})
    public Response getUser(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "The email for the User object requested", required = true)
            @PathParam("requestedUserEmail") String requestedUserEmail
    ) throws ApiException {
        Authorizer.authorize(email, password);
        User user = userData.findUserByEmail(requestedUserEmail);
        if (user != null) return Response.ok().entity(user).build();
        else throw new ApiException(404, "User not found");
    }

    @GET
    @Path("/getStatuses/{requestedUserEmail}")
    @ApiOperation(value = "Get all statuses for User",
            notes = "Return a UserStatus object for each group for a given User",
            response = UserStatus.class,
            responseContainer = "List")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid User object supplied"),
            @ApiResponse(code = 404, message = "User not found")})
    public Response getUserStatuses(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "The email of the User for which we're requesting all UserStatuses", required = true)
            @PathParam("requestedUserEmail") String requestedUserEmail
    ) throws ApiException {
        Authorizer.authorize(email, password);
        List<UserStatus> statuses = userData.getAllStatuses(requestedUserEmail);
        return Response.ok().entity(statuses).build();
    }

    @GET
    @Path("/get-groups")
    @ApiOperation(value = "Get all groups for user",
            notes = "Gets an array of all groups for a particular user",
            response = Group.class,
            responseContainer = "List")
    @ApiResponses(value = {
            @ApiResponse(code = 401, message = "Unauthorized (appropriate credentials required)")
    })
    public Response getUsersGroups(
            @ApiParam(value = "Requesting User's email address for authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes")
            @HeaderParam("password") String password,
            @ApiParam(value = "The email of the User whose groups are sought", required = true)
            @QueryParam("requestedEmail") String requestedEmail) throws ApiException{
        Authorizer.authorize(email, password);
        List<Group> groups = userData.getUserGroups(requestedEmail);
        return Response.ok(groups).build();
    }

    @POST
    @ApiOperation(value = "Create User",
            notes = "Inserts and saves a new User to the database")
    public Response createUser(
            @ApiParam(value = "New User object", required = true) User user) throws ApiException {
        userData.addUser(user);
        return Response.ok().entity("").build();
    }

    @POST
    @Path("/create-via-list")
    @ApiOperation(value = "Create via list", notes = "Creates list of Users with given input array (only admins)")
    public Response createUsersWithListInput(
            @ApiParam(value = "Requesting User's email address for authentication and authorization purposes")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authentication and authorization purposes")
            @HeaderParam("password") String password,
            @ApiParam(value = "List of user object", required = true) java.util.List<User> users) throws ApiException {
        Authorizer.authorize(email, password);
        for (User user : users) {
            userData.addUser(user);
        }
        return Response.ok().entity("").build();
    }

    @PUT
    @Path("/update")
    @ApiOperation(value = "Update User",
            notes = "Modify a particular User's profile data for the given email address")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid User supplied"),
            @ApiResponse(code = 404, message = "User not found")})
    public Response updateUser(
            @ApiParam(value = "Requesting User's email address for authorization purposes (original)")
                @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
                @HeaderParam("password") String password,
            @ApiParam(value = "Updated user object", required = true) User user) throws ApiException {
        Authorizer.authorize(email, password);
        userData.updateUser(email, user);
        return Response.ok().entity("").build();
    }

    @PUT
    @Path("/update-status/{userEmail}")
    @ApiOperation(value = "Update User's driving status",
            notes = "Update a particular user's driving status for a list of group IDs")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid User supplied"),
            @ApiResponse(code = 404, message = "User not found")})
    public Response updateUsersStatus(
            @ApiParam(value = "Requesting User's email address for authorization purposes (original)")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "User email whose status needs an update", required = true)
            @PathParam("userEmail") String userEmail,
            @ApiParam(value = "Statuses (one for each group which needs to be updated)", required = true)
                java.util.List<UserStatus> statuses) throws ApiException {
        Authorizer.authorize(email, password);
        userData.updateUsersStatus(userEmail, statuses);
        return Response.ok().entity("").build();
    }

    @PUT
    @Path("/stop-driving/{userEmail}")
    @ApiOperation(value = "Clear driving status",
            notes = "Forces the user off driving duty (for all groups)")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid User supplied"),
            @ApiResponse(code = 404, message = "User not found")})
    public Response stopDriving(
            @ApiParam(value = "Requesting User's email address for authorization purposes (original)")
            @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authorization purposes (original)")
            @HeaderParam("password") String password,
            @ApiParam(value = "User email who should no longer be driving", required = true)
            @PathParam("userEmail") String userEmail) throws ApiException {
        Authorizer.authorize(email, password);
        userData.clearDrivingStatuses(userEmail);
        return Response.ok().entity("").build();
    }

    @DELETE
    @Path("/delete/{emailForDeletion}")
    @ApiOperation(value = "Delete User", notes = "Deletes the specified user account")
    @ApiResponses(value = {
            @ApiResponse(code = 400, message = "Invalid username supplied or insufficient permissions"),
            @ApiResponse(code = 404, message = "User not found")})
    public Response deleteUser(
            @ApiParam(value = "Requesting User's email address for authentication and authorization purposes")
                @HeaderParam("email") String email,
            @ApiParam(value = "Requesting User's password for authentication and authorization purposes")
                @HeaderParam("password") String password,
            @ApiParam(value = "The name that needs to be deleted", required = true)
                @PathParam("emailForDeletion") String emailForDeletion)
            throws ApiException {
        Authorizer.authorize(email, password);
        userData.removeUser(emailForDeletion);
        return Response.ok().entity("").build();
    }
}
