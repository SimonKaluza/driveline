// CreateGroupViewController.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline


#import "CreateGroupViewController.h"

@interface CreateGroupViewController ()

@end


@implementation CreateGroupViewController
@synthesize groupNameTf;
@synthesize descriptionTf;
@synthesize streetAddressTf;
@synthesize cityTf;
@synthesize stateTf;
@synthesize zipTf;

// ============================================================================
#pragma mark - UIViewController Messages for Create Group
// ============================================================================

- (void) viewDidLoad {
    // Add and register a gesture recognizer to end editting if a user touches outside a textfield
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.tableView addGestureRecognizer:tgr];
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    [self.view endEditing: YES];
}

// ============================================================================
#pragma mark - UITextFieldDelegate Messages for Create Group
// ============================================================================

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == groupNameTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [descriptionTf becomeFirstResponder];
    }
    else if (textField == descriptionTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [streetAddressTf becomeFirstResponder];
    }
    else if (textField == streetAddressTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [cityTf becomeFirstResponder];
    }
    else if (textField == cityTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [stateTf becomeFirstResponder];
    }
    else if (textField == stateTf){
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [zipTf becomeFirstResponder];
    }
    else if (textField == zipTf){
        [self.view endEditing:YES];
    }
    return NO; // Stop UITextField from allowing line-breaks.
}

// ============================================================================
#pragma mark - Misc Messages/Actions for Create Group
// ============================================================================

-(void)tryCreate
{
    SWGGroupApi *groupApi = [[SWGGroupApi alloc] init];
    SWGGroup* group = [[SWGGroup alloc] init];
    group.name = groupNameTf.text;
    group.description = descriptionTf.text;
    group.address = streetAddressTf.text;
    group.adminEmail = [DataManager sharedSingleton].currentUser.email;
    [groupApi createGroupAsAdminWithCompletionBlock:[DataManager sharedSingleton].currentUser.email password:[DataManager sharedSingleton].currentUser.password body: group completionHandler:^(SWGGroup *output, NSError *error) {
        if (output) {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Group Created" message: @"Successfully created group" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [self.navigationController popViewControllerAnimated:YES];
        }
        else {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Group Creation Error" message: @"Could not create group on server" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [self dismissViewControllerAnimated: YES completion:nil];
    }];
}

- (IBAction)pushedCreateButton:(id)sender {
    [self.view endEditing:YES];
    [self tryCreate];
}
@end
