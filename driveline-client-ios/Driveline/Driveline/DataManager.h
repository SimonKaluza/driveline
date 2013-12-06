// DataManager.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <Foundation/Foundation.h>
#import "SWGUserApi.h"
#import "SWGGroupApi.h"
#import "MBProgressHUD.h"
#import "LocationManager.h"


@protocol LoginRequestDelegate <NSObject>
@required
- (void) receiveLoginResponse;
- (void) receiveLoginFailure:(NSString *) message;
@end

@protocol GroupListUpdateListener <NSObject>
@required
- (void) groupListUpdateSucceeded;
- (void) groupListUpdateFailed:(NSString *) message;
@end

@protocol UserListUpdateListener <NSObject>

@required
- (void) userListUpdateSucceeded:(NSArray*) newUsers removedUsers:(NSArray*) removedUsers;
- (void) userListUpdateFailed:(NSString *) message;
@end

@interface DataManager : NSObject

@property(atomic, readonly) SWGUser* currentUser;
@property(atomic, readonly) NSArray* usersGroups;

@property(atomic, readonly) NSArray* onlineUsers;
@property(atomic, readonly) NSArray* allUsers;

@property(atomic) NSArray* groupStatuses;

+ (DataManager *)sharedSingleton;

- (BOOL) isCurrentUserInGroup: (SWGGroup *) group;

- (void) sendCurrentUserUpdate;
- (void) attemptLoginWithUsername: (NSString *) email password: (NSString *) password;
- (void) refreshCurrentUsersGroups;
- (void) refreshUserListForGroupId: (NSNumber*) groupId;
- (void) logout;

- (void) registerLoginListener: (id<LoginRequestDelegate>) listener;
- (void) registerGroupListUpdateListener: (id<GroupListUpdateListener>) listener;
- (void) registerUserListUpdateListener: (id<UserListUpdateListener>) listener;
- (void) deregisterUserListUpdateListener: (id<UserListUpdateListener>) listener;
@end
