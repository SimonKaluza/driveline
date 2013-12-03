// CreateAccountViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import "PhoneNumberFormatter.h"
#import "SWGUserApi.h"

#define CREATETAG 6

@interface CreateAccountViewController : UITableViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *emailTf;
@property (strong, nonatomic) IBOutlet UITextField *passwordTf;
@property (strong, nonatomic) IBOutlet UITextField *verifyTf;
@property (strong, nonatomic) IBOutlet UITextField *firstNameTf;
@property (strong, nonatomic) IBOutlet UITextField *lastNameTf;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTf;

@property (strong, nonatomic) IBOutlet UIButton *registerButton;
- (IBAction)pushCancelButton:(id)sender;

- (void) autoFormatPhoneNumberTextField:(id)sender;
@end
