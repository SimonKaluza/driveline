// DriversListDetailViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "MainTabViewController.h"
#import "ProfileHeaderCell.h"
#import "SWGuser.h"

@interface DriversListDetailViewController : UITableViewController <UINavigationControllerDelegate, MFMessageComposeViewControllerDelegate>
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil driver:(SWGUser*) driver;
- (void) callButtonPressed: (id) button;
- (void) textButtonPressed: (id) button;
@end
