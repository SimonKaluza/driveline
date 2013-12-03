#import <Foundation/Foundation.h>
#import "SWGGroup.h"
#import "SWGUser.h"


@interface SWGGroupApi: NSObject

-(void) addHeader:(NSString*)value forKey:(NSString*)key;
-(unsigned long) requestQueueSize;
+(SWGGroupApi*) apiWithHeader:(NSString*)headerValue key:(NSString*)key;
+(void) setBasePath:(NSString*)basePath;
+(NSString*) getBasePath;
/**

 getGroup
 Returns a group based on Group ID. Non-integers will trigger API error conditions
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param groupId ID of group that needs to be fetched
 */
-(NSNumber*) getGroupByIdWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        groupId:(NSNumber*) groupId 
        completionHandler: (void (^)(SWGGroup* output, NSError* error))completionBlock;

/**

 Finds groups by keyword
 Performs a search on all groups that contain the specified character combination.
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param keyword Keyword to filter by
 */
-(NSNumber*) findGroupsByKeywordWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        keyword:(NSString*) keyword 
        completionHandler: (void (^)(NSArray* output, NSError* error))completionBlock;

/**

 Get all users for group
 Gets an array of all users for a particular group
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes
 @param groupId The groupId of the group whose users are sought
 */
-(NSNumber*) getGroupsUsersWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        groupId:(NSNumber*) groupId 
        completionHandler: (void (^)(NSArray* output, NSError* error))completionBlock;

/**

 createGroup
 Adds a new group to the app
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param body Group object that needs to be added to the app
 */
-(NSNumber*) addGroupWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        body:(SWGGroup*) body 
        completionHandler: (void (^)(SWGGroup* output, NSError* error))completionBlock;

/**

 createGroupAsAdmin
 Adds a new group and adds the current user as the first admin member
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param body Group object that needs to be added to the app
 */
-(NSNumber*) createGroupAsAdminWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        body:(SWGGroup*) body 
        completionHandler: (void (^)(SWGGroup* output, NSError* error))completionBlock;

/**

 addUserToGroup
 Adds a specified user to a particular group
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param groupId Group Id of the group for which the User requests membership
 @param _newMemberEmail Email of address of the User requesting membership
 @param adminStatus User privileges (0 for regular user, 1 for admin)
 */
-(NSNumber*) addUserToGroupWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        groupId:(NSNumber*) groupId 
        _newMemberEmail:(NSString*) _newMemberEmail 
        adminStatus:(NSNumber*) adminStatus 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 updateGroup
 Updates a Group specified by the groupId
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param body Group object that needs to updated in the database
 */
-(NSNumber*) updateGroupWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        body:(SWGGroup*) body 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 removeUserFromGroup
 Removes a specified user from a particular group
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param groupId Group Id of the group from which to remove the specified user
 @param emailForDeletion Email of address of the User leaving the group
 */
-(NSNumber*) removeUserFromGroupWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        groupId:(NSNumber*) groupId 
        emailForDeletion:(NSString*) emailForDeletion 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 Delete Group
 Deletes the specified Group
 @param email Requesting User's email address for authentication and authorization purposes
 @param password Requesting User's password for authentication and authorization purposes
 @param idForDeletion The id of the group needs to be deleted
 */
-(NSNumber*) deleteGroupWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        idForDeletion:(NSNumber*) idForDeletion 
        completionHandler: (void (^)(NSError* error))completionBlock;

@end
