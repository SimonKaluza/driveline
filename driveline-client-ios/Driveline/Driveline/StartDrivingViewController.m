// StartDrivingViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "StartDrivingViewController.h"

@interface StartDrivingViewController ()
@end

@implementation StartDrivingViewController
@synthesize groupsTableView;

// ============================================================================
#pragma mark - UIViewController Messages for Start Driving View Controller
// ============================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

// ============================================================================
#pragma mark - UITableViewDataSource for Start Driving View Controller
// ============================================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [DataManager sharedSingleton].usersGroups.count;
} 

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"Select the groups you'd like to drive for:";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    cell = [[UITableViewCell alloc] init];
    [cell.textLabel setText: [self getGroupForIndexPath:indexPath].name];
    return cell;
}

// ============================================================================
#pragma mark - UITableViewDelegate for Start Driving View Controller
// ============================================================================

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)path {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:path];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    [groupsTableView deselectRowAtIndexPath:path animated:YES];
}

// ============================================================================
#pragma mark - Misc Actions/Messages for Start Driving View Controller
// ============================================================================

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)readyButtonPressed:(id)sender {
    // Loop through visible cells looking for checks, these groups must be retrieved and sent to server as status updates
    NSMutableArray* userStatuses = [[NSMutableArray alloc] init];
    for (UITableViewCell *cell in groupsTableView.visibleCells){
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark){
            SWGUserStatus* newStatus = [[SWGUserStatus alloc] init];
            newStatus.status = @1;
            newStatus.groupId = [self getGroupForIndexPath: [groupsTableView indexPathForCell:cell]]._id;
            [userStatuses addObject:newStatus];
        }
    }
    if (userStatuses.count > 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [[[SWGUserApi alloc] init] updateUsersStatusWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password userEmail:[DataManager sharedSingleton].currentUser.email body:userStatuses completionHandler:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (error){
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Could Not Start Driving" message:@"The server could not receive your request to begin driving at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            else {
                [DataManager sharedSingleton].currentUser.userStatus = @1;
                [DataManager sharedSingleton].groupStatuses = userStatuses;
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

- (SWGGroup*) getGroupForIndexPath: (NSIndexPath*) indexPath
{
    return [[DataManager sharedSingleton].usersGroups  objectAtIndex:indexPath.row];
}
@end
