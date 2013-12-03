//
//  ComplexTests.m
//  DrivelineRestClient
//
//  Created by Simon P Kaluza on 10/29/13.
//  Copyright (c) 2013 Simon P Kaluza. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TestHelper.h"

@interface ComplexTests : XCTestCase <DrivelineTestCase>

@end

@implementation ComplexTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testAddNewUserToGroup
{
    TestHelper* testHelper = [[TestHelper alloc ] init];
    SWGUser* user = [TestHelper instantiateUser:EMAIL password:PASSWORD firstName:FIRSTNAME lastName:LASTNAME phone:PHONE userStatus:USER_STATUS seats:SEATS];
    SWGGroup* group = [TestHelper instantiateGroup:NAME description:DESCRIPTION adminEmail:ADMIN_EMAIL address:ADDRESS deleted:DELETED];
    
    [testHelper createUser: user testCaller: nil];
    [testHelper createGroup: group testCaller: nil];
    group = testHelper.lastCreatedGroup;
    SWGGroupApi* groupApi = [[SWGGroupApi alloc] init];
    SWGUserApi* userApi = [[SWGUserApi alloc] init];
    
    [self performAddUserToGroup:groupApi user:user group:group];
    [self listAllGroupsUsers:groupApi user:user group:group];
    [self listAllUsersGroups:userApi user:user group:group];
    
    // Clean up database for future tests...
    [testHelper deleteUser:user testCaller:nil];
    [testHelper deleteGroup: group testCaller: nil];
}

- (void) performAddUserToGroup: (SWGGroupApi*) groupApi user: (SWGUser*) user group: (SWGGroup*) group {
    StartBlock();
    [groupApi addUserToGroupWithCompletionBlock:user.email password:user.password groupId:group._id _newMemberEmail:user.email adminStatus: @0 completionHandler:^(NSError *error) {
        XCTAssertNil(error);
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

- (void) listAllGroupsUsers: (SWGGroupApi*) groupApi user: (SWGUser*) user group: (SWGGroup*) group {
    StartBlock();
    [groupApi getGroupsUsersWithCompletionBlock:user.email password:user.password groupId:group._id completionHandler:^(NSArray *output, NSError *error) {
        XCTAssertNotNil(output);
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}

- (void) listAllUsersGroups: (SWGUserApi*) userApi user: (SWGUser*) user group: (SWGGroup*) group {
    StartBlock();
    [userApi getUsersGroupsWithCompletionBlock: user.email password:user.password requestedEmail:user.email completionHandler:^(NSArray *output, NSError *error) {
        XCTAssertNotNil(output);
        EndBlock();
    }];
    WaitUntilBlockCompletes();
}


- (void) assertNotNil: (NSError *) error
{
    XCTAssertNil(error, @"Create User REST request returned with '%@'", error.description);
}

@end
