// DriversListViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>

#import "EditableDetailCell.h"
#import "DriversListDetailViewController.h"
#import "DriversListCell.h"
#import "InsetAdjustedRefreshControl.h"
#import "DataManager.h"

@interface NewDriversListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UserListUpdateListener, GroupListUpdateListener>

- (IBAction)touchedGroupPicker:(id)sender;
- (void) dismissGroupPickActionSheet;
- (void) sendUserListRefreshRequest;

@property (weak, nonatomic) IBOutlet UITextField *groupTextField;
@property (weak, nonatomic) IBOutlet UITableView *driverTableView;

@property (strong, nonatomic) UIPickerView * groupPickerView;
@end
