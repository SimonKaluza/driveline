// DriversListDetailViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "DriversListDetailViewController.h"

@interface DriversListDetailViewController ()
@property (nonatomic) SWGUser* driver;
@end

@implementation DriversListDetailViewController
@synthesize driver;

// ============================================================================
#pragma mark - UIViewController Messages for Drivers Detail
// ============================================================================

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil driver:(SWGUser *) driverP{
    driver = driverP;
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
        NSString* name = [driver.firstName stringByAppendingFormat:@" %@", driver.lastName];
        self.title = name;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// ============================================================================
#pragma mark - UITableViewDataSource Messages for Drivers Detail
// ============================================================================

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *headerCell = @"DriverHeader";
    static NSString *buttonCell = @"CallButton";
    UITableViewCell *cell;
    
    if (indexPath.section == 0){
        cell = [tableView dequeueReusableCellWithIdentifier:headerCell];
        if (cell == nil){
            
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderCell" owner:nil options:nil];
            
            for(id currentObject in topLevelObjects)
            {
                if([currentObject isKindOfClass:[ProfileHeaderCell class]])
                {
                    ProfileHeaderCell* hCell = (ProfileHeaderCell *)currentObject;
                    hCell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
                    hCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    hCell.nameLabel.text = [driver.firstName stringByAppendingFormat:@" %@", driver.lastName];
                    cell = hCell;
                    break;
                }
            }
        }
    }
    else {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier: buttonCell];
    }
    
    
    return cell;
}

// ============================================================================
#pragma mark - UITableViewDelegate Messages for Drivers Detail
// ============================================================================

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return PROFILEHEADERHEIGHT;
    }
    return [super tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0){
        
    }
    else {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = cell.contentView.bounds;
        [cell.contentView addSubview:button];
        
        if (indexPath.section == 1) {
            [button setTitle:@"Call for a Ride!" forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(callButtonPressed:)
             forControlEvents:UIControlEventTouchDown];
        }
        else {
            [button setTitle:@"Text for a Ride!" forState:UIControlStateNormal];
            [button addTarget:self
                       action:@selector(textButtonPressed:) forControlEvents:UIControlEventTouchDown];
        }

    }
}

// ============================================================================
#pragma mark - MFMessageComposeViewControllerDelegate Messages for Drivers Detail
// ============================================================================

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    UIAlertView* alert;
	switch (result) {
		case MessageComposeResultCancelled:
			NSLog(@"Cancelled");
			break;
		case MessageComposeResultFailed:
            alert = [[UIAlertView alloc] initWithTitle:@"Couldn't Send SMS!" message:@"Couldn't send a text to the driver!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
			break;
		case MessageComposeResultSent:
            
			break;
		default:
			break;
	}
    
	[[MainTabViewController instance] dismissViewControllerAnimated:YES completion:nil];
}

// ============================================================================
#pragma mark - Misc Messages for Drivers Detail
// ============================================================================

- (void) callButtonPressed: (id) button{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:driver.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (void) textButtonPressed: (id) button {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
	if([MFMessageComposeViewController canSendText])
	{
		controller.body = @"I need a ride!";
		controller.recipients = [NSArray arrayWithObjects:driver.phone, nil];
        controller.navigationBarHidden = false;
		controller.messageComposeDelegate = self;
		[[MainTabViewController instance] presentViewController:controller animated:YES completion:nil];
	}
}
@end
