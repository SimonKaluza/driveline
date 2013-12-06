// MyGroupsDetailViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "MyGroupsDetailViewController.h"
#define PENDING_SECTION 3
#define BUTTON_SECTION 2
#define ADDRESS_SECTION 1
#define DESCRIPTION_SECTION 0

@interface MyGroupsDetailViewController ()
@property SWGGroup* group;
@property SWGGroupApi* groupApi;
@property NSMutableArray* users;

@property SWGUser* selectedUser; // Pending request User last selected for verification
@property NSIndexPath* selectedIndexPath; // Index path of User last selected for verification
@end

@implementation MyGroupsDetailViewController
@synthesize group;
@synthesize groupApi;
@synthesize users;
@synthesize selectedUser;
@synthesize selectedIndexPath;

// ============================================================================
#pragma mark - UIViewController Messages for Groups Detail
// ============================================================================

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil group:(SWGGroup *) groupModel{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.title = groupModel.name;
        self.group = groupModel;
        self.groupApi = [[SWGGroupApi alloc] init];
        self.users = [[NSMutableArray alloc] init];
        [[DataManager sharedSingleton] refreshUserListForGroupId:group._id];
        [[DataManager sharedSingleton] registerUserListUpdateListener:self];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

-(void) viewDidUnload {
    [[DataManager sharedSingleton] deregisterUserListUpdateListener:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ============================================================================
#pragma mark - UITableViewDataSource Messages for Groups Detail
// ============================================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([group.usersAdminStatus isEqual: @1]) return 4;
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
        case DESCRIPTION_SECTION: return 1;
        case ADDRESS_SECTION: return 2;
        case BUTTON_SECTION: return 1;
        case PENDING_SECTION: return users.count;
        // Should never reach default
        default: return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            cell.textLabel.text = group.description;
            break;
        case 1:
            cell.textLabel.text = group.address;
            break;
        case 2: {
            if ([[DataManager sharedSingleton] isCurrentUserInGroup:self.group]){
                if ([group.usersAdminStatus  isEqual: @1]) {
                    cell.textLabel.text = @"Delete this group";
                }
                else cell.textLabel.text = @"Leave this group";
            }
            else cell.textLabel.text = @"Join this group";
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            break;
        }
        case 3: {
            if (users.count > 0){
                SWGUser* user = [users objectAtIndex:indexPath.row];
                cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
            }
            else {
                cell.textLabel.text = @"No Pending Requests";
            }
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section){
        case 0: return @"Description";
        case 1: return @"Address";
        case 3: return @"Pending Join Requests";
        default: return nil;
    }
}

// ============================================================================
#pragma mark - UITableViewDelegate Messages for Groups Detail
// ============================================================================

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Handle the "Delete/Leave/Join Group" Button case
    if ( indexPath.section == BUTTON_SECTION){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        if ([[DataManager sharedSingleton] isCurrentUserInGroup:group]){
            [groupApi removeUserFromGroupWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password groupId:group._id emailForDeletion: [DataManager sharedSingleton].currentUser.email completionHandler:^(NSError *error) {
                if (error){
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to leave group" message: @"Could not leave the selected group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Left group" message: @"Successfully left the group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
        else {
            __weak MyGroupsDetailViewController* weakSelf = self;
            [ groupApi addUserToGroupWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password groupId:group._id _newMemberEmail:[DataManager sharedSingleton].currentUser.email adminStatus:@-1 completionHandler:^(NSError *error) {
                if (error){
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to join group" message: @"Could not join the selected group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                }
                else {
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Joined group" message: @"Successfully joined the group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
    // Handle the "Pending Join Request selection"
    else if (indexPath.section == PENDING_SECTION) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        selectedUser = [users objectAtIndex:indexPath.row];
        selectedIndexPath = indexPath;
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle: @"Verify Request" message: [NSString stringWithFormat: @"Allow %@ to ride and drive for %@?", selectedUser.firstName, group.name] delegate:self cancelButtonTitle:@"Reject" otherButtonTitles:@"Accept", nil];
        [alert show];
    }
}

// ============================================================================
#pragma mark - UIAlertViewDelegate Messages for Groups Detail
// ============================================================================
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (buttonIndex == [alertView cancelButtonIndex]){
        [groupApi removeUserFromGroupWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password groupId:group._id emailForDeletion:selectedUser.email completionHandler:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) [self removeSelectedUser];
        }];
    }
    else {
        [groupApi acceptUserToGroupWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password acceptedUserEmail:selectedUser.email acceptingGroupId:group._id completionHandler:^(NSError *error){
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error)[self removeSelectedUser];
        }];
    }
    
}

// ============================================================================
#pragma mark - UserListUpdateListener Messages for Groups Detail
// ============================================================================
- (void) userListUpdateSucceeded:(NSArray*) newUsers removedUsers:(NSArray*) removedUsers {
    users = [NSMutableArray arrayWithArray:[DataManager sharedSingleton].onlineUsers];
    [self.tableView reloadData];
}
- (void) userListUpdateFailed:(NSString *) message {
    // Do nothing if we cannot get a new User list successfully (no users will added)
}

-(void) removeSelectedUser
{
    NSArray *tempArray = [[NSArray alloc] initWithObjects: selectedIndexPath, nil];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationFade];
    [self.users removeObject:selectedUser];
    [self.tableView endUpdates];
}

@end
