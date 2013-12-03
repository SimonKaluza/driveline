// StartDrivingViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "SWGUserStatus.h"
#import "MainTabViewController.h"

@interface StartDrivingViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)readyButtonPressed:(id)sender;

@end
