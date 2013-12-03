//
//  TestHelper.m
//  DrivelineRestClient
//
//  Created by Simon P Kaluza on 10/28/13.
//  Copyright (c) 2013 Simon P Kaluza. All rights reserved.
//

#import "TestHelper.h"
@interface TestHelper()
@property(atomic)SWGUserApi* userApi;
@property(atomic)SWGGroupApi* groupApi;
@end

@implementation TestHelper
@synthesize userApi;
@synthesize groupApi;
@synthesize lastCreatedGroup;

- (id) init
{
    self = [super init];
    if (self){
        userApi = [[SWGUserApi alloc] init];
        groupApi = [[SWGGroupApi alloc] init];
    }
    return self;
}

+ (SWGGroup *) instantiateGroup: (NSString*) name description: (NSString*) description adminEmail: (NSString*) adminEmail address: (NSString*) address deleted: (NSNumber*) deleted
{
    SWGGroup* g = [[SWGGroup alloc] init];
    g.address = address;
    g.name = name;
    g.description = description;
    g.adminEmail = adminEmail;
    g.deleted = deleted;
    return g;
}

+ (SWGUser *) instantiateUser: (NSString*) email password: (NSString*) password firstName: (NSString*) firstName lastName: (NSString*) lastName phone: (NSString*) phone userStatus: (NSNumber*) userStatus seats: (NSNumber*) seats
{
    SWGUser* u = [[SWGUser alloc] init];
    u.email = email;
    u.password = password;
    u.firstName = firstName;
    u.lastName = lastName;
    u.phone = phone;
    u.userStatus = userStatus;
    u.seats = seats;
    return u;
}

- (void) createUser: (SWGUser *) user testCaller: (id<DrivelineTestCase>) caller
{
    StartBlock();
    [userApi createUserWithCompletionBlock:user completionHandler:^(NSError *error) {
        if (caller) [caller assertNotNil: error];
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

- (void) readUser: (SWGUser *) user testCaller: (id<DrivelineTestCase>) caller
{
    StartBlock();
    [userApi getUserWithCompletionBlock: EMAIL password: PASSWORD requestedUserEmail:EMAIL completionHandler:^(SWGUser *output, NSError *error) {
        if (caller) [caller assertNotNil: error];
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

- (void) deleteUser: (SWGUser *) user testCaller: (id<DrivelineTestCase>) caller
{
    StartBlock();
    [userApi deleteUserWithCompletionBlock:EMAIL password:PASSWORD emailForDeletion:EMAIL completionHandler:^(NSError *error) {
        if (caller) [caller assertNotNil: error];
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

- (void) createGroup: (SWGGroup *) g testCaller: (id<DrivelineTestCase>) caller
{
    StartBlock();
    [groupApi addGroupWithCompletionBlock:EMAIL password:PASSWORD body:g completionHandler:^(SWGGroup *output, NSError *error) {
        lastCreatedGroup = output;
        if (caller) [caller assertNotNil: error];
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

- (void) readGroup: (SWGGroup *) g testCaller: (id<DrivelineTestCase>) caller
{
    StartBlock();
    [groupApi getGroupByIdWithCompletionBlock:EMAIL password:PASSWORD groupId:g._id completionHandler:^(SWGGroup *output, NSError *error) {
        if (caller) [caller assertNotNil: error];
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

- (void) deleteGroup: (SWGGroup *) g testCaller: (id<DrivelineTestCase>) caller
{
    StartBlock();
    [groupApi deleteGroupWithCompletionBlock:EMAIL password:PASSWORD idForDeletion:g._id completionHandler:^(NSError *error) {
        if (caller) [caller assertNotNil: error];
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

@end
