// MainTabViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import "MyGroupsViewController.h"
#import "StartDrivingViewController.h"
#import "NewDriversListViewController.h"
#import "DataManager.h"
@class NewDriversListViewController;

@interface MainTabViewController : UIViewController <UITabBarDelegate>

- (void) pressedStartDrivingButton;
@property (weak, nonatomic) IBOutlet UITabBarItem *driverListTabBarItem;
@property (nonatomic, retain) IBOutlet UITabBar *mainTabBar;
@property (weak, atomic) IBOutlet UINavigationBar *mainTitleBar;

@property (nonatomic, strong) NewDriversListViewController *driverListVc;

+ (MainTabViewController *)instance;
 
@end
