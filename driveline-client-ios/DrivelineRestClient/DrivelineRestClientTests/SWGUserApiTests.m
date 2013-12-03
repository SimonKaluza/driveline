// SWGUserApiTests.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <XCTest/XCTest.h>
#import "SWGUserApi.h"
#import "SWGGroupApi.h"
#import "TestHelper.h"

@interface SWGUserApiTests : XCTestCase <DrivelineTestCase> {
@private
    SWGUserApi* userApi;
    SWGGroupApi* groupApi;
}

@end

@implementation SWGUserApiTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void) testCRUDUser
{
    TestHelper* testHelper = [[TestHelper alloc ] init];
    SWGUser* user = [TestHelper instantiateUser:EMAIL password:PASSWORD firstName:FIRSTNAME lastName:LASTNAME phone:PHONE userStatus:USER_STATUS seats:SEATS];
    [testHelper deleteUser: user testCaller: nil]; // Clear the user in case it already existed from previous test
    [testHelper createUser: user testCaller: self];
    [testHelper readUser: user testCaller: self];
    [testHelper deleteUser: user testCaller: self];
}

- (void) testCRUDGroup
{
    TestHelper* testHelper = [[TestHelper alloc ] init];
    SWGGroup* group = [TestHelper instantiateGroup:NAME description:DESCRIPTION adminEmail:ADMIN_EMAIL address:ADDRESS deleted:DELETED];
    [testHelper deleteGroup:group testCaller: nil]; // Clear the group in case it existed from previous test
    [testHelper createGroup: group testCaller: self];
    // Pull the newly created group off of the TestHelper object, as the new instance will have ID
    group = testHelper.lastCreatedGroup;
    [testHelper readGroup:group testCaller: self];
    [testHelper deleteGroup:group testCaller: self];
}

- (void) assertNotNil: (NSError *) error
{
    XCTAssertNil(error, @"Create User REST request returned with '%@'", error.description);
}


@end
