// CreateGroupViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import "SWGGroupApi.h"
#import "DataManager.h"

@interface CreateGroupViewController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *groupNameTf;
@property (weak, nonatomic) IBOutlet UITextField *descriptionTf;
@property (weak, nonatomic) IBOutlet UITextField *streetAddressTf;
@property (weak, nonatomic) IBOutlet UITextField *cityTf;
@property (weak, nonatomic) IBOutlet UITextField *stateTf;
@property (weak, nonatomic) IBOutlet UITextField *zipTf;

@property (weak, nonatomic) IBOutlet UITableViewCell *createButton;

- (IBAction)pushedCreateButton:(id)sender;
@end
