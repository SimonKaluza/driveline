// CreateAccountViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "CreateAccountViewController.h"

@interface CreateAccountViewController ()
@property (atomic) int phoneNumberTfSemaphore;
@property ( nonatomic) PhoneNumberFormatter *phoneNumberFormatter;
@property (nonatomic) SWGUserApi* userApi;

@end

@implementation CreateAccountViewController
@synthesize emailTf;
@synthesize passwordTf;
@synthesize verifyTf;
@synthesize firstNameTf;
@synthesize lastNameTf;
@synthesize phoneNumberTf;
@synthesize registerButton;
@synthesize phoneNumberTfSemaphore;
@synthesize phoneNumberFormatter;
@synthesize userApi;

- (void) viewDidLoad {
    [super viewDidLoad];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    // Add and register a gesture recognizer to end editting if a user touches outside a textfield
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped)];
    tgr.delegate = self;
    [self.tableView addGestureRecognizer:tgr];
    // Initialize our phone number formatting event listener:
    phoneNumberFormatter =[[PhoneNumberFormatter alloc] init];
    [phoneNumberTf addTarget: self action: @selector(autoFormatPhoneNumberTextField:) forControlEvents:UIControlEventEditingChanged];
    userApi = [[SWGUserApi alloc] init];
    self.navigationController.navigationBar.backItem.title = @"";
}

- (IBAction)pushCancelButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) autoFormatPhoneNumberTextField: (id)sender {
    if (phoneNumberTfSemaphore) return;
    phoneNumberTfSemaphore = 1;
    phoneNumberTf.text = [phoneNumberFormatter format:phoneNumberTf.text withLocale:@"us"];
    phoneNumberTfSemaphore = 0;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if (textField == emailTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [passwordTf becomeFirstResponder];
    }
    else if(textField == passwordTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [verifyTf becomeFirstResponder];
    }
    else if(textField == verifyTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [firstNameTf becomeFirstResponder];   
    }
    else if(textField == firstNameTf)
    {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [lastNameTf becomeFirstResponder];
    }
    else if(textField == lastNameTf)
    { 
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:2] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [phoneNumberTf becomeFirstResponder];
    }
    else 
    {
        [textField resignFirstResponder];
        [self tryCreate];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}

-(void)tryCreate
{
    [registerButton setEnabled:NO];
    SWGUser* user = [[SWGUser alloc] init];
    user.email = emailTf.text;
    user.password = passwordTf.text;
    user.firstName = firstNameTf.text;
    user.lastName = lastNameTf.text;
    // String out the special formatting characters of the view element's phone number
    user.phone = [[[[phoneNumberTf.text
                    stringByReplacingOccurrencesOfString:@"-" withString:@""] stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [userApi createUserWithCompletionBlock:user completionHandler:^(NSError *error) {
        if (error){
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Account Creation Failed" message:@"Please try again with the correct input fields" delegate:self.parentViewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Account Created" message: @"Welcome to Driveline!  Please login and join a group to start ride-sharing" delegate:self.parentViewController cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (IBAction)pushRegisterButton:(id)sender {
    [self.view endEditing:YES];
    [self tryCreate];
}


- (void) viewTapped {
    [self.view endEditing:YES];
}


@end
