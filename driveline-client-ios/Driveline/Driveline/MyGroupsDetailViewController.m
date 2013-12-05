// MyGroupsDetailViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "MyGroupsDetailViewController.h"

@interface MyGroupsDetailViewController ()
@property SWGGroup* group;
@property SWGGroupApi* groupApi;
@end

@implementation MyGroupsDetailViewController
@synthesize group;
@synthesize groupApi;

// ============================================================================
#pragma mark - UIViewController Messages for Groups Detail
// ============================================================================

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil group:(SWGGroup *) groupModel{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        self.title = groupModel.name;
        self.group = groupModel;
        self.groupApi = [[SWGGroupApi alloc] init];
    }
    return self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section){
        case 0: return 1;
        case 1: return 2;
        case 2: return 1;
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
                cell.textLabel.text = @"Leave this group";
            }
            else cell.textLabel.text = @"Join this group";
            
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            break;
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section){
        case 0: return @"Description"; break;
        case 1: return @"Address"; break;
        default: return nil;
    }
    return @"My Permissions";
}

// ============================================================================
#pragma mark - UITableViewDelegate Messages for Groups Detail
// ============================================================================

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 2 && indexPath.row ==0 ){
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
}

@end
