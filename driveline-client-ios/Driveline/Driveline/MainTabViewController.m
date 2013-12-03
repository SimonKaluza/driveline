// MainTabViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "MainTabViewController.h"

@interface MainTabViewController ()
@property (nonatomic, strong) UIViewController *myGroupsVc;
@property (nonatomic, strong) UINavigationController *nav1;
@property (nonatomic, strong) UIView* navigationConstrainingView1;

@property (nonatomic, strong) UIView* navigationConstrainingView2;
@property (nonatomic, strong) UINavigationController *nav2;

@property (nonatomic) NSMutableArray* transientNavConstraints;
@property (nonatomic) NSMutableArray* transientRootConstraints;

@property (nonatomic) UINavigationItem* riderNavigationItem;
@property (nonatomic) UINavigationItem* driverNavigationItem;
@property (nonatomic) UINavigationItem* busyDriverNavigationItem;

@property (atomic) bool rideInProgress;


@end

@implementation MainTabViewController
@synthesize driverListVc;
@synthesize myGroupsVc;
@synthesize nav2;
@synthesize driverListTabBarItem;
@synthesize mainTabBar;
@synthesize mainTitleBar;
@synthesize nav1;
@synthesize navigationConstrainingView2;
@synthesize navigationConstrainingView1;
@synthesize transientNavConstraints;
@synthesize transientRootConstraints;

@synthesize riderNavigationItem;
@synthesize driverNavigationItem;
@synthesize busyDriverNavigationItem;


// Singleton pattern implementation:
static MainTabViewController *gInstance = NULL;

+ (MainTabViewController *)instance
{
    return(gInstance);
}

// ============================================================================
#pragma mark - UIViewController Messages for My Groups
// ============================================================================

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.rideInProgress = NO;
        navigationConstrainingView2 = [[UIView alloc] init];
        navigationConstrainingView1 = [[UIView alloc] init];
        transientNavConstraints = [[NSMutableArray alloc] init];
        transientRootConstraints = [[NSMutableArray alloc] init];
        [self initializeMyDriversView];
        [self initializeMyGroupsView];
        gInstance = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view insertSubview:self.navigationConstrainingView1 belowSubview:mainTabBar];
    [self forceResizeOfNavigationView:nav1.view constrainingView:navigationConstrainingView1 oldConstrainingView:navigationConstrainingView2];
    
    
    // Setup "Navigation Items" for all user states:
    riderNavigationItem = [[UINavigationItem alloc] initWithTitle:@"Driveline"];
    driverNavigationItem = [[UINavigationItem alloc] initWithTitle:@"On Duty"];
    busyDriverNavigationItem = [[UINavigationItem alloc] initWithTitle:@"Busy"];
    
    UIBarButtonItem* startShiftButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Shift" style:UIBarButtonItemStyleBordered target:self action:@selector(pressedStartShiftButton)];
    riderNavigationItem.hidesBackButton = YES;
    riderNavigationItem.rightBarButtonItem = startShiftButton;
    
    UIBarButtonItem* endShiftButton = [[UIBarButtonItem alloc] initWithTitle:@"End Shift" style: UIBarButtonItemStyleBordered target:self action:@selector(pressedEndShiftButton)];
    UIBarButtonItem* startDrivingButton = [[UIBarButtonItem alloc] initWithTitle:@"Start Driving" style:UIBarButtonItemStyleBordered target:self action:@selector(pressedStartDrivingButton)];
    driverNavigationItem.leftBarButtonItem = endShiftButton;
    driverNavigationItem.rightBarButtonItem = startDrivingButton;
    
    UIBarButtonItem* stopDrivingButton = [[UIBarButtonItem alloc] initWithTitle:@"Stop Driving" style:UIBarButtonItemStyleBordered target:self action:@selector(pressedStopDrivingButton)];
    busyDriverNavigationItem.leftBarButtonItem = endShiftButton;
    busyDriverNavigationItem.rightBarButtonItem = stopDrivingButton;
    
    
    [mainTitleBar pushNavigationItem:riderNavigationItem animated:NO];
    [mainTabBar setSelectedItem:driverListTabBarItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [mainTitleBar popNavigationItemAnimated:NO];
    switch ([DataManager sharedSingleton].currentUser.userStatus.integerValue){
        case 0:
            [mainTitleBar pushNavigationItem:riderNavigationItem animated:YES];
            break;
        case 1:
            [mainTitleBar pushNavigationItem:driverNavigationItem animated:YES];
            break;
        case 2:
            [mainTitleBar pushNavigationItem:busyDriverNavigationItem animated:YES];
            break;
    }
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    switch (item.tag) {
        case 1:
            [self.navigationConstrainingView2 removeFromSuperview];
            [self.view insertSubview:self.navigationConstrainingView1 belowSubview:mainTabBar];
            [self forceResizeOfNavigationView:nav1.view constrainingView:navigationConstrainingView1 oldConstrainingView:navigationConstrainingView2];
            break;
        case 2:
            [self.navigationConstrainingView1 removeFromSuperview]; // Ensure this view is removed
            [self.view insertSubview:self.navigationConstrainingView2 belowSubview:mainTabBar];
            [self forceResizeOfNavigationView:nav2.view constrainingView:navigationConstrainingView2 oldConstrainingView:navigationConstrainingView1];
            break;
        case 3:
            [[DataManager sharedSingleton] logout];
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
    }
}

-(void) initializeMyDriversView{
    
    if (driverListVc == nil) {
        self.driverListVc =[[NewDriversListViewController alloc] initWithNibName:@"NewDriversListViewController" bundle:nil];
    }
    if (self.nav1 == nil){
        self.nav1 = [[UINavigationController alloc] initWithRootViewController:self.driverListVc];
        [self.nav1.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [navigationConstrainingView1 addSubview:self.nav1.view];
        [navigationConstrainingView1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

-(void) initializeMyGroupsView{
    if (myGroupsVc == nil) {
        self.myGroupsVc =[[MyGroupsViewController alloc] initWithNibName:@"MyGroupsViewController" bundle:nil];
    }
    
    if (self.nav2 == nil){
        self.nav2 = [[UINavigationController alloc] initWithRootViewController:self.myGroupsVc];
        [self.nav2.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [navigationConstrainingView2 addSubview:self.nav2.view];
        [navigationConstrainingView2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
}

- (void)pressedStartShiftButton {
    [self presentViewController:[[StartDrivingViewController alloc] initWithNibName:@"StartDrivingViewController" bundle:nil] animated:YES completion:nil];
}

- (void) pressedEndShiftButton {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray* newStatuses = [[NSMutableArray alloc] init];
    for (SWGUserStatus* status in [DataManager sharedSingleton].groupStatuses) {
        SWGUserStatus* newStatus = [[SWGUserStatus alloc] init];
        newStatus.groupId = status.groupId;
        newStatus.status = @0;
        [newStatuses addObject:newStatus];
    }
    [[[SWGUserApi alloc] init] updateUsersStatusWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password userEmail:[DataManager sharedSingleton].currentUser.email body:newStatuses completionHandler:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Could Not Start Driving" message:@"The server could not receive your request to end your shift at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else {
            [DataManager sharedSingleton].currentUser.userStatus = @0;
            [DataManager sharedSingleton].groupStatuses = newStatuses;
            [mainTitleBar popNavigationItemAnimated:NO];
            [mainTitleBar pushNavigationItem:riderNavigationItem animated:YES];
            [self.driverListVc sendUserListRefreshRequest];
        }
    }];
}

- (void) pressedStartDrivingButton {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray* newStatuses = [[NSMutableArray alloc] init];
    for (SWGUserStatus* status in [DataManager sharedSingleton].groupStatuses) {
        SWGUserStatus* newStatus = [[SWGUserStatus alloc] init];
        newStatus.groupId = status.groupId;
        newStatus.status = @2;
        [newStatuses addObject:newStatus];
    }
    [[[SWGUserApi alloc] init] updateUsersStatusWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password userEmail:[DataManager sharedSingleton].currentUser.email body:newStatuses completionHandler:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Could Not Start Driving" message:@"The server could not receive your request to begin driving at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else {
            [DataManager sharedSingleton].currentUser.userStatus = @2;
            [DataManager sharedSingleton].groupStatuses = newStatuses;
            [mainTitleBar popNavigationItemAnimated:NO];
            [mainTitleBar pushNavigationItem:busyDriverNavigationItem animated:YES];
            [self.driverListVc sendUserListRefreshRequest];
        }
    }];
}

- (void) pressedStopDrivingButton {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray* newStatuses = [[NSMutableArray alloc] init];
    for (SWGUserStatus* status in [DataManager sharedSingleton].groupStatuses) {
        SWGUserStatus* newStatus = [[SWGUserStatus alloc] init];
        newStatus.groupId = status.groupId;
        newStatus.status = @1;
        [newStatuses addObject:newStatus];
    }
    [[[SWGUserApi alloc] init] updateUsersStatusWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password userEmail:[DataManager sharedSingleton].currentUser.email body:newStatuses completionHandler:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Could Not Start Driving" message:@"The server could not receive your request to begin driving at this time." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }
        else {
            [DataManager sharedSingleton].currentUser.userStatus = @1;
            [DataManager sharedSingleton].groupStatuses = newStatuses;
            [mainTitleBar popNavigationItemAnimated:NO];
            [mainTitleBar pushNavigationItem:driverNavigationItem animated:YES];
            [self.driverListVc sendUserListRefreshRequest];
        }
    }];
}

- (void) forceResizeOfNavigationView: (UIView*) navigationControllerView constrainingView: (UIView*) newConstrainingView oldConstrainingView: (UIView*) oldConstrainingView
{
    [self.view removeConstraints:transientRootConstraints];
    [oldConstrainingView removeConstraints:transientNavConstraints];
    
    [transientRootConstraints removeAllObjects];
    [transientNavConstraints removeAllObjects];
    
    [self.transientRootConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[mainTitleBar]-0-[newConstrainingView]-0-[mainTabBar]" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(mainTabBar, mainTitleBar,newConstrainingView)]];
    [self.transientRootConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[newConstrainingView]-0-|" options: NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(newConstrainingView)]];
    
    [self.view addConstraints:transientRootConstraints];
    
    [self.transientNavConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[navigationControllerView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(navigationControllerView)]];
    [self.transientNavConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[navigationControllerView]-0-|" options:NSLayoutFormatDirectionLeadingToTrailing metrics:nil views:NSDictionaryOfVariableBindings(navigationControllerView)]];
    
    [newConstrainingView addConstraints:transientNavConstraints];
}
@end
