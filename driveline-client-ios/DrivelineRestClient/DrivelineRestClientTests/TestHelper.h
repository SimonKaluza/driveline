//
//  TestHelper.h
//  DrivelineRestClient
//
//  Created by Simon P Kaluza on 10/26/13.
//  Copyright (c) 2013 Simon P Kaluza. All rights reserved.
//

#ifndef DrivelineRestClient_TestHelper_h
#define DrivelineRestClient_TestHelper_h

#import "SWGGroupApi.h"
#import "SWGUserApi.h"
#import "SWGuser.h"
#import "SWGGroup.h"
#import <XCTest/XCTest.h>

// Set the flag for a block completion handler
#define StartBlock() __block BOOL waitingForBlock = YES

// Set the flag to stop the loop
#define EndBlock() waitingForBlock = NO

// Wait and loop until flag is set
#define WaitUntilBlockCompletes() WaitWhile(waitingForBlock)

// Macro - Wait for condition to be NO/false in blocks and asynchronous calls
#define WaitWhile(condition) \
do { \
while(condition) { \
[[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.1]]; \
} \
} while(0)

#define EMAIL @"johnny.appleseed@apple.com"
#define PASSWORD @"superpassword!"
#define FIRSTNAME @"Johnny"
#define LASTNAME @"Appleseed"
#define PHONE @"2034153486"
#define USER_STATUS @1
#define SEATS @4

#define ADDRESS @"94 Some Random Rd., Some Town, CT 06443"
#define NAME @"New SafeRide Group"
#define DESCRIPTION @"Some random new SafeRide group!"
#define ADMIN_EMAIL @"uberl33tadmin@driveline.com"
#define DELETED 0

@protocol DrivelineTestCase <NSObject>
@required
-(void) assertNotNil: (NSError *) error;
@end

@interface TestHelper : NSObject

@property(atomic) SWGGroup* lastCreatedGroup;

- (void) createUser: (SWGUser *) user testCaller: (id<DrivelineTestCase>) caller;
- (void) readUser: (SWGUser *) user testCaller: (id<DrivelineTestCase>) caller;
- (void) deleteUser: (SWGUser *) user testCaller: (id<DrivelineTestCase>) caller;
- (void) createGroup: (SWGGroup *) g testCaller: (id<DrivelineTestCase>) caller;
- (void) readGroup: (SWGGroup *) g testCaller: (id<DrivelineTestCase>) caller;
- (void) deleteGroup: (SWGGroup *) g testCaller: (id<DrivelineTestCase>) caller;
+ (SWGUser *) instantiateUser: (NSString*) email password: (NSString*) password firstName: (NSString*) firstName lastName: (NSString*) lastName phone: (NSString*) phone userStatus: (NSNumber*) userStatus seats: (NSNumber*) seats;
+ (SWGGroup *) instantiateGroup: (NSString*) name description: (NSString*) description adminEmail: (NSString*) adminEmail address: (NSString*) address deleted: (NSNumber*) deleted;
@end



#endif
