// MyGroupsViewController.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "MyGroupsDetailViewController.h"
#import "SWGGroupApi.h"
#import "CreateGroupViewController.h"

@interface MyGroupsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchDisplayDelegate, GroupListUpdateListener>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *groupsTableView;

@property (strong, nonatomic) NSMutableArray *filteredGroups;

@end