#import <Foundation/Foundation.h>
#import "SWGUserStatus.h"
#import "SWGGroup.h"
#import "SWGUser.h"


@interface SWGUserApi: NSObject

-(void) addHeader:(NSString*)value forKey:(NSString*)key;
-(unsigned long) requestQueueSize;
+(SWGUserApi*) apiWithHeader:(NSString*)headerValue key:(NSString*)key;
+(void) setBasePath:(NSString*)basePath;
+(NSString*) getBasePath;
/**

 Get all statuses for User
 Return a UserStatus object for each group for a given User
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param requestedUserEmail The email of the User for which we're requesting all UserStatuses
 */
-(NSNumber*) getUserStatusesWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        requestedUserEmail:(NSString*) requestedUserEmail 
        completionHandler: (void (^)(NSArray* output, NSError* error))completionBlock;

/**

 Get all groups for user
 Gets an array of all groups for a particular user
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes
 @param requestedEmail The email of the User whose groups are sought
 */
-(NSNumber*) getUsersGroupsWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        requestedEmail:(NSString*) requestedEmail 
        completionHandler: (void (^)(NSArray* output, NSError* error))completionBlock;

/**

 Create User
 Inserts and saves a new User to the database
 @param body New User object
 */
-(NSNumber*) createUserWithCompletionBlock :(SWGUser*) body 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 Create via list
 Creates list of Users with given input array (only admins)
 @param email Requesting User's email address for authentication and authorization purposes
 @param password Requesting User's password for authentication and authorization purposes
 @param body List of user object
 */
-(NSNumber*) createUsersWithListInputWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        body:(NSArray*) body 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 Update User
 Modify a particular User's profile data for the given email address
 @param email Requesting User's email address for authorization purposes (original)
 @param password Requesting User's password for authorization purposes (original)
 @param body Updated user object
 */
-(NSNumber*) updateUserWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        body:(SWGUser*) body 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 Update User's driving status
 Update a particular user's driving status for a list of group IDs
 @param email Requesting User's email address for authorization purposes (original)
 @param password Requesting User's password for authorization purposes (original)
 @param userEmail User email whose status needs an update
 @param body Statuses (one for each group which needs to be updated)
 */
-(NSNumber*) updateUsersStatusWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        userEmail:(NSString*) userEmail 
        body:(NSArray*) body 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 Clear driving status
 Forces the user off driving duty (for all groups)
 @param email Requesting User's email address for authorization purposes (original)
 @param password Requesting User's password for authorization purposes (original)
 @param userEmail User email who should no longer be driving
 */
-(NSNumber*) stopDrivingWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        userEmail:(NSString*) userEmail 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 Delete User
 Deletes the specified user account
 @param email Requesting User's email address for authentication and authorization purposes
 @param password Requesting User's password for authentication and authorization purposes
 @param emailForDeletion The name that needs to be deleted
 */
-(NSNumber*) deleteUserWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        emailForDeletion:(NSString*) emailForDeletion 
        completionHandler: (void (^)(NSError* error))completionBlock;

/**

 Get User
 Return a User object for a specified email address
 @param email Requesting User's email address for authorization purposes
 @param password Requesting User's password for authorization purposes (original)
 @param requestedUserEmail The email for the User object requested
 */
-(NSNumber*) getUserWithCompletionBlock :(NSString*) email 
        password:(NSString*) password 
        requestedUserEmail:(NSString*) requestedUserEmail 
        completionHandler: (void (^)(SWGUser* output, NSError* error))completionBlock;

@end
