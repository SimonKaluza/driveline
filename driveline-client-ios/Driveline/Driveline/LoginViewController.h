// LoginViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "KeychainItemWrapper.h"
#import "CreateAccountViewController.h"
#import "EditableDetailCell.h"
#import "DataManager.h"
#import "SWGuser.h"

@interface LoginViewController : UIViewController <UITableViewDataSource, UITextFieldDelegate, ADBannerViewDelegate,LoginRequestDelegate>
- (IBAction)loginButtonPush:(id)sender;

@property (weak, nonatomic) IBOutlet ADBannerView *bannerAd;
@property (weak, nonatomic) IBOutlet UITextField *test;
@property (weak, nonatomic)UITextField *usernameTextField;
@property (weak, nonatomic)UITextField *passwordTextField;
@end
