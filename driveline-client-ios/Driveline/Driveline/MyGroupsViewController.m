// MyGroupsViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "MyGroupsViewController.h"

@interface MyGroupsViewController ()
@property SWGGroupApi* groupApi;
@property UIRefreshControl* refreshControl;
@end

@implementation MyGroupsViewController
@synthesize groupsTableView;
@synthesize searchBar;
@synthesize filteredGroups;
@synthesize groupApi;
@synthesize refreshControl;


// ============================================================================
#pragma mark - UIViewController Messages for My Groups
// ============================================================================

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"My Groups";
        groupApi = [[SWGGroupApi alloc] init];
        filteredGroups = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[DataManager sharedSingleton] registerGroupListUpdateListener:self];
    UIBarButtonItem* createGroupButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushCreateGroupController)];
    self.navigationItem.rightBarButtonItem = createGroupButton;
    
    refreshControl = [[UIRefreshControl alloc]
                                        init];
    [refreshControl addTarget:self action:@selector(sendGroupListUpdateRequest) forControlEvents:UIControlEventValueChanged];
    [groupsTableView addSubview:refreshControl];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self sendGroupListUpdateRequest];
    [self.groupsTableView setContentOffset:CGPointMake(0,0) animated:YES];
    [super viewWillAppear: animated];
}

// ============================================================================
#pragma mark - UITableViewDataSource Messages
// ============================================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [filteredGroups count];
    else return [DataManager sharedSingleton].usersGroups.count;
} 

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    SWGGroup *group = [self getGroupForTableView: tableView atIndexPath: indexPath];
    cell = [[UITableViewCell alloc] init];
    [cell.textLabel setText: group.name];
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

// ============================================================================
#pragma mark - UITableViewDelegate Messages
// ============================================================================

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MyGroupsDetailViewController *groupsDetailController = [[MyGroupsDetailViewController alloc] initWithNibName:@"MyGroupsDetailViewController" bundle:nil group: [self getGroupForTableView:tableView atIndexPath:indexPath]];
    [[self navigationController] pushViewController:groupsDetailController animated:YES];
}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
//
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, tableView.bounds.size.width - 10, 18)];
//    label.text = @"My Groups";
//    label.textColor = [UIColor whiteColor];
//    label.backgroundColor = [UIColor clearColor];
//    [headerView addSubview:label];
//    return headerView;
//}

// ============================================================================
#pragma mark - UISearchBarDelegate Messages
// ============================================================================

- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [[self navigationController]  setNavigationBarHidden:YES animated:YES];
    return TRUE;
}

- (BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    [[self navigationController]  setNavigationBarHidden:NO animated:YES];
    return TRUE;
}

// ============================================================================
#pragma mark - UISearchDisplayDelegate Messages
// ============================================================================

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [groupApi findGroupsByKeywordWithCompletionBlock: [DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password keyword:searchString completionHandler:^(NSArray *output, NSError *error) {
        if (output){
            filteredGroups = [NSMutableArray arrayWithArray:output];
            [self.searchDisplayController.searchResultsTableView reloadData];
        }
    }];
    // Return NO to cause the app to not reload the table until the server responds (and callback manually forces reload)
    return NO;
}


// ============================================================================
#pragma mark - GroupListUpdate Listener Messages
// ============================================================================

- (void) groupListUpdateSucceeded
{
    [groupsTableView reloadData];
    [refreshControl endRefreshing];
    [self.groupsTableView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void) groupListUpdateFailed:(NSString *) message
{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Groups List!" message:@"Couldn't download your SafeRide Groups from the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// ============================================================================
#pragma mark - Misc
// ============================================================================

- (void) pushCreateGroupController {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"CreateGroupAccount" bundle:nil];
    CreateGroupViewController* createGroupController = [storyBoard instantiateInitialViewController];
    [self.navigationController pushViewController:createGroupController animated:YES];
}

- (void) sendGroupListUpdateRequest
{
    // Force the refresh control to animate
    [self.groupsTableView setContentOffset:CGPointMake(0, -self.refreshControl.frame.size.height) animated:YES];
    [[DataManager sharedSingleton] refreshCurrentUsersGroups];
}

- (SWGGroup*) getGroupForTableView: (UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView)
        return [filteredGroups objectAtIndex:indexPath.row];
    else return [[DataManager sharedSingleton].usersGroups  objectAtIndex:indexPath.row];
}

@end
