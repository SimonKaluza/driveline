// DataManager.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "DataManager.h"

@interface DataManager()
@property(nonatomic) SWGUserApi *userApi;
@property(nonatomic) SWGGroupApi *groupApi;
@property(atomic) NSMutableArray *loginListeners;
@property(atomic) NSMutableArray *groupListUpdateListeners;
@property(atomic) NSMutableArray *userListUpdateListeners;
@end

@implementation DataManager
@synthesize userApi;
@synthesize groupApi;

@synthesize currentUser;
@synthesize usersGroups;
@synthesize allUsers;
@synthesize groupStatuses;

@synthesize loginListeners;
@synthesize groupListUpdateListeners;
@synthesize userListUpdateListeners;

-(id) init
{
    self = [super init];
    if(self){
        userApi = [[SWGUserApi alloc] init];
        groupApi = [[SWGGroupApi alloc] init];
        
        loginListeners = [[NSMutableArray alloc] init];
        groupListUpdateListeners = [[NSMutableArray alloc] init];
        userListUpdateListeners = [[NSMutableArray alloc] init];
        
        usersGroups = [[NSArray alloc] init];
        allUsers = [[NSArray alloc] init];
        groupStatuses = [[NSArray alloc] init];
    }
    return self;
}

+ (DataManager *)sharedSingleton
{
    static DataManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[DataManager alloc] init];
        
        return sharedSingleton;
    }
}

- (NSArray*) onlineUsers
{
    NSPredicate *userPredicate = [NSPredicate predicateWithFormat:@"userStatus != %@", @0];
    return [allUsers filteredArrayUsingPredicate:userPredicate];
}

- (BOOL) isCurrentUserInGroup: (SWGGroup *) group {
    NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"name = %@", group.name];
    if ([usersGroups filteredArrayUsingPredicate:groupPredicate].count > 0) return YES;
    return NO;
}

- (void) attemptLoginWithUsername: (NSString *) email password: (NSString *) password
{
    [userApi getUserWithCompletionBlock:email password:password requestedUserEmail: email completionHandler: ^(SWGUser *output, NSError *error) {
        currentUser = output;
        if (output) {
            [userApi getUserStatusesWithCompletionBlock:currentUser.email password:currentUser.password requestedUserEmail:currentUser.email completionHandler:^(NSArray *output, NSError *error) {
                if (output){
                    [[LocationManager sharedSingleton] startStandardUpdates];
                    groupStatuses = output;
                    for (id<LoginRequestDelegate> listener in self.loginListeners)
                        [listener receiveLoginResponse];
                }
                // Handle error
                else{
                    for (id<LoginRequestDelegate> listener in self.loginListeners)
                        [listener receiveLoginFailure:error.description];
                }
            }];
        }
        // Handle error
        else {
            for (id<LoginRequestDelegate> listener in self.loginListeners)
                [listener receiveLoginFailure:error.description];
        }
    }];
}

- (void) sendCurrentUserUpdate
{
    [userApi updateUserWithCompletionBlock:currentUser.email password:currentUser.password body:currentUser completionHandler:^(NSError *error) {
        if (error) NSLog(@"Error updating user : %@", error.description);
        else NSLog(@"Successfully updated user");
    }];
}

- (void) refreshCurrentUsersGroups
{
    [userApi getUsersGroupsWithCompletionBlock:currentUser.email password: currentUser.password requestedEmail: currentUser.email completionHandler:^(NSArray *output, NSError *error) {
        if (output) {
            usersGroups = output;
            for (id<GroupListUpdateListener> listener in self.groupListUpdateListeners)
                [listener groupListUpdateSucceeded];
        }
        else for (id<GroupListUpdateListener> listener in self.groupListUpdateListeners) [listener groupListUpdateFailed: error.description];
    }];
}

- (void) refreshUserListForGroupId: (NSNumber*) groupId
{
    allUsers = [[NSArray alloc] init];   // Clear the online User array immediately
    [groupApi getGroupsUsersWithCompletionBlock:currentUser.email password:currentUser.password groupId:groupId completionHandler:^(NSArray *output, NSError *error) {
        if (output) {
            NSMutableArray* newItems = [[NSMutableArray alloc] init];
            NSMutableArray* removedItems = [[NSMutableArray alloc] init];
            // First determine which users have been added and which have been removed for tableview transitions...
            [DataManager retrieveAddedAndDeletedUsers:self.onlineUsers newUsers:output addedUsers:newItems deletedUsers:removedItems];
            allUsers = output;
            for (id<UserListUpdateListener> listener in self.userListUpdateListeners)
                [listener userListUpdateSucceeded: newItems removedUsers:removedItems];
        }
        else for (id<UserListUpdateListener> listener in self.userListUpdateListeners) [listener userListUpdateFailed: error.description];
    }];
}

- (void) logout
{
    groupListUpdateListeners = [[NSMutableArray alloc] init];
    userListUpdateListeners = [[NSMutableArray alloc] init];
    
    usersGroups = [[NSArray alloc] init];
    allUsers = [[NSArray alloc] init];
    groupStatuses = [[NSArray alloc] init];
    currentUser = nil;
}

// ============================================================================
#pragma mark - Listener Delegate Registration
// ============================================================================

- (void) registerLoginListener: (id<LoginRequestDelegate>) listener {
    [self.loginListeners addObject:listener];
}

- (void) registerGroupListUpdateListener: (id<GroupListUpdateListener>) listener {
    [self.groupListUpdateListeners addObject:listener];
}

- (void) registerUserListUpdateListener: (id<UserListUpdateListener>) listener {
    [self.userListUpdateListeners addObject:listener];
}

+ (void) retrieveAddedAndDeletedUsers:(NSArray*) oldUsers newUsers: (NSArray*) newUsers addedUsers: (NSMutableArray*) addedUsers deletedUsers: (NSMutableArray*) deletedUsers
{
    for (int j=0; j<newUsers.count; j++){
        SWGUser* newUser = [newUsers objectAtIndex:j];
        BOOL isAddedUser = true;
        for (int k=0; k<oldUsers.count; k++){
            SWGUser* oldUser = [oldUsers objectAtIndex:k];
            if ([newUser.email isEqualToString:oldUser.email]){
                isAddedUser = false;
                break;
            }
        }
        if (isAddedUser) [addedUsers addObject:newUser];
    }
    
    for (int j=0; j<oldUsers.count; j++){
        SWGUser* oldUser = [oldUsers objectAtIndex:j];
        BOOL isDeletedUser = true;
        for (int k=0; k<newUsers.count; k++){
            SWGUser* newUser = [newUsers objectAtIndex:k];
            if ([newUser.email isEqualToString:oldUser.email]){
                isDeletedUser = false;
                break;
            }
        }
        if (isDeletedUser) [deletedUsers addObject:oldUser];
    }
}

@end
