// LoginViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "LoginViewController.h"

@interface LoginViewController ()
@property (nonatomic) KeychainItemWrapper* keychainItem;
@end

@implementation LoginViewController
@synthesize test;
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize keychainItem;
@synthesize bannerAd;

- (void)viewDidLoad
{
    [super viewDidLoad];
    bannerAd.delegate = self;
    keychainItem = [[KeychainItemWrapper alloc] initWithIdentifier:@"DrivelineAppKeychain" accessGroup:nil];
    [[DataManager sharedSingleton] registerLoginListener:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self navigationController]  setNavigationBarHidden:YES animated:YES];
}

- (IBAction)loginButtonPush:(id)sender 
{
    [self tryLogin];
}

- (void)tryLogin
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [keychainItem setObject:passwordTextField.text forKey: (__bridge id) kSecValueData];
    [keychainItem setObject:usernameTextField.text forKey: (__bridge id) kSecAttrAccount];
    [[DataManager sharedSingleton] attemptLoginWithUsername:usernameTextField.text password:passwordTextField.text];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField 
{
    if (textField == usernameTextField)
        [passwordTextField becomeFirstResponder];
    else if (textField == passwordTextField){
        [textField resignFirstResponder];
        [self tryLogin];
    }
    
    return NO;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EditableDetailCell *cell;
    if ([indexPath row] == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"EmailCell"];
        [cell.textField setPlaceholder:@"Email"];
        [cell.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [cell.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [cell.textField setKeyboardType:UIKeyboardTypeEmailAddress];
        if ([DataManager sharedSingleton].currentUser)
            [cell.textField setText:[DataManager sharedSingleton].currentUser.email];
        else{
            // Try to load a saved email from the secure keychain to login
            NSString *email = [keychainItem objectForKey:(__bridge id)kSecAttrAccount];
            if (email) [cell.textField setText:email];
        }
        [self setUsernameTextField:cell.textField];
    }
    else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"PasswordCell"];
        [cell.textField setPlaceholder:@"Password"];
        [cell.textField setReturnKeyType:UIReturnKeyGo];
        [cell.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [cell.textField setSecureTextEntry:YES];
        if ([DataManager sharedSingleton].currentUser)
            [cell.textField setText:[DataManager sharedSingleton].currentUser.password];
        else{
            // Try to load a saved email from the secure keychain to login
            NSString *password = [keychainItem objectForKey:(__bridge id)kSecValueData];
            if (password) [cell.textField setText:password];
        }
        [self setPasswordTextField:cell.textField];
    }
    
    [cell.textField setDelegate:self];
    return cell;
}


- (void) receiveLoginResponse {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self performSegueWithIdentifier:@"NewLoginSegue" sender:self];
}

- (void) receiveLoginFailure:(NSString *) message {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Login Failed" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Trivial Ad load error");
}
@end
