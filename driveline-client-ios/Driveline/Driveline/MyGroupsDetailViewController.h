// MyGroupsDetailViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import "SWGGroup.h"
#import "SWGGroupApi.h"
#import "DataManager.h"

@interface MyGroupsDetailViewController : UITableViewController <UserListUpdateListener>
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil group:(SWGGroup *) group;
@end
