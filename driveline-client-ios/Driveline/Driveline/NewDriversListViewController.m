// DriversListViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "NewDriversListViewController.h"

static NSString *DriversListCellIdentifier = @"DriversListCell";
static NSString *VanillaCellIdentifier = @"VanillaCell";

@interface NewDriversListViewController ()
@property(nonatomic) UIActionSheet *actionSheet;
@property(nonatomic) InsetAdjustedRefreshControl* refreshControl;
@property(nonatomic, weak) SWGGroup* group;
@end

@implementation NewDriversListViewController
@synthesize driverTableView;
@synthesize groupTextField;
@synthesize actionSheet;
@synthesize groupPickerView;
@synthesize refreshControl;
@synthesize group;

// ============================================================================
#pragma mark - UIViewController Messages for Drivers List View
// ============================================================================
- (void)viewDidLoad
{
    [super viewDidLoad];
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [groupTextField setPlaceholder:@"Join a group from the Groups tab!"];
    [[DataManager sharedSingleton] registerGroupListUpdateListener:self];
    [[DataManager sharedSingleton] registerUserListUpdateListener:self];
    //driverTableView.contentInset = UIEdgeInsetsZero;    // Get rid of table content gap in iOS7
    groupPickerView = [[UIPickerView alloc] init];
    
    [self.driverTableView registerClass:[DriversListCell class] forCellReuseIdentifier:DriversListCellIdentifier];
    [self.driverTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:VanillaCellIdentifier];
    self.title = @"Drivers";
    // Use a special RefreshControl that behaves properly with the lack of table insets
    refreshControl = [[InsetAdjustedRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(sendUserListRefreshRequest) forControlEvents:UIControlEventValueChanged];
    [driverTableView addSubview:refreshControl];
    [[DataManager sharedSingleton] refreshCurrentUsersGroups];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.refreshControl beginRefreshing];
        [self.refreshControl endRefreshing];
    });
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(contentSizeCategoryChanged:)
                                                 name:UIContentSizeCategoryDidChangeNotification
                                               object:nil];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    [self sendUserListRefreshRequest];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

// ============================================================================
#pragma mark - UITableViewDataSource Messages (for Driver's List View)
// ============================================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the count of users online according to DataManager if there are any, otherwise give one row in the cell to inform the user there are none.
    if ([DataManager sharedSingleton].onlineUsers.count > 0)
    return [DataManager sharedSingleton].onlineUsers.count;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([DataManager sharedSingleton].onlineUsers.count > 0){
        SWGUser* user = [self getUserForIndexPath:indexPath];
        DriversListCell* cell = [tableView dequeueReusableCellWithIdentifier:DriversListCellIdentifier forIndexPath:indexPath];
        NSString* name = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        [cell.titleLabel setText: name];
        
        [cell.bodyLabel setText: [self getStringDistanceFromUser:user]];
        if ([user.userStatus isEqual:@2]) cell.busy = YES;
        else cell.busy = NO;
        // Make sure the constraints have been added to this cell, since it may have just been created from scratch
        [cell setNeedsUpdateConstraints];
        return cell;
    }
    else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:VanillaCellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"No users online";
        [cell.textLabel setNeedsUpdateConstraints];
        return cell;
    }
}

// ============================================================================
#pragma mark - UITableViewDelegate Messages
// ============================================================================

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([DataManager sharedSingleton].onlineUsers.count > 0){
        DriversListDetailViewController* driverDetailController =[[DriversListDetailViewController alloc] initWithNibName:@"DriversListDetailViewController" bundle:nil driver:[self getUserForIndexPath:indexPath ]];
        [[self navigationController] pushViewController:driverDetailController animated:YES];
    }
}

// ============================================================================
#pragma mark - UserListUpdateListener Messages (for Driver's List View)
// ============================================================================

- (void) userListUpdateSucceeded:(NSArray*) newUsers removedUsers:(NSArray*) removedUsers
{
    [driverTableView reloadData];
    [refreshControl endRefreshing];
    [self.driverTableView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void) userListUpdateFailed:(NSString *) message{
    [refreshControl endRefreshing];
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"User List Update Failed!" message:@"Couldn't download your Driveline friends list from the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// ============================================================================
#pragma mark - UIPickerViewDataSource for Groups Picker
// ============================================================================

-(void) dismissGroupPickActionSheet {
    [actionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [DataManager sharedSingleton].usersGroups.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if ([DataManager sharedSingleton].onlineUsers.count > 0) {
        DriversListCell *cell = [tableView dequeueReusableCellWithIdentifier:DriversListCellIdentifier];
        
        [cell updateFonts];
        
        SWGUser *user = [self getUserForIndexPath:indexPath];
        NSString* name = [NSString stringWithFormat:@"%@ %@", user.firstName, user.lastName];
        cell.titleLabel.text =  name;
        cell.bodyLabel.text = @"Distance Placeholder";
        
        cell.bodyLabel.preferredMaxLayoutWidth = tableView.bounds.size.width - (kLabelHorizontalInsets * 2.0f);
        
        [cell setNeedsUpdateConstraints];
        [cell updateConstraintsIfNeeded];
        [cell.contentView setNeedsLayout];
        [cell.contentView layoutIfNeeded];
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
    else {
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:VanillaCellIdentifier];
        height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    }
        
    
    return height;
}

// ============================================================================
#pragma mark - UIPickerViewDelegate for Groups Picker
// ============================================================================

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    SWGGroup* currentGroup = [self getGroupForRow:row];
    if (currentGroup){
        return currentGroup.name;
    }
    return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([DataManager sharedSingleton].usersGroups.count > 0){
        group = [self getGroupForRow:row];
        [groupTextField setText:group.name];
        [self sendUserListRefreshRequest];
    }
}

// ============================================================================
#pragma mark - GroupListUpdateListener Protocol Messages
// ============================================================================

- (void) groupListUpdateSucceeded{
    [groupPickerView reloadAllComponents];
    [groupPickerView selectRow:0 inComponent:0 animated:YES];
    [self pickerView:groupPickerView didSelectRow:0 inComponent:0];
}

- (void) groupListUpdateFailed:(NSString *) message{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"Groups List!" message:@"Couldn't download your Driveline Groups from the server" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

// ============================================================================
#pragma mark - Miscellanous messages
// ============================================================================

- (IBAction)touchedGroupPicker:(id)sender {
    actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                              delegate:nil
                                     cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                     otherButtonTitles:nil];
    
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    groupPickerView.showsSelectionIndicator = YES;
    groupPickerView.dataSource = self;
    groupPickerView.delegate = self;
    
    [actionSheet addSubview:groupPickerView];
    
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Close"]];
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    [closeButton addTarget:self action:@selector(dismissGroupPickActionSheet) forControlEvents:UIControlEventValueChanged];
    [actionSheet addSubview:closeButton];
    
    [actionSheet showInView:self.view];
    [actionSheet setBounds:CGRectMake(0, 0, 320, 485)];
}

- (SWGUser*) getUserForIndexPath: (NSIndexPath*) indexPath
{
    if ([DataManager sharedSingleton].onlineUsers.count > 0) {
        return [[DataManager sharedSingleton].onlineUsers objectAtIndex:indexPath.row];
    }
    else {
        return nil;
    }
}

- (void) sendUserListRefreshRequest
{
    [[DataManager sharedSingleton] refreshUserListForGroupId:group._id];
}

- (SWGGroup*) getGroupForRow: (NSInteger) row {
    return [[DataManager sharedSingleton].usersGroups objectAtIndex:row];
}

- (void)contentSizeCategoryChanged:(NSNotification *)notification
{
    [self.driverTableView reloadData];
}

- (NSString*) getStringDistanceFromUser:(SWGUser*) user
{
    SWGUser* currentUser = [DataManager sharedSingleton].currentUser;
    // Return if no valid location data exists about the user (indicated in database by latitude > 999)
    if (user.lastLatitude.doubleValue >= 999) return @"No location data available";
    CLLocation *currentLoc = [[CLLocation alloc] initWithLatitude: user.lastLatitude.doubleValue longitude:user.lastLongitude.doubleValue];
    CLLocation *otherLoc = [[CLLocation alloc] initWithLatitude: currentUser.lastLatitude.doubleValue longitude:currentUser.lastLongitude.doubleValue];
    CLLocationDistance distance = [currentLoc distanceFromLocation:otherLoc];
    // Format the string but convert from meters to miles first
    return [NSString stringWithFormat:@"%.1f miles away", distance / 1609.344];
}
@end
