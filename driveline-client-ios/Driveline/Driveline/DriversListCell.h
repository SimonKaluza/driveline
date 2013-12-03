// DriversListCell.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <UIKit/UIKit.h>
#import "NewDriversListViewController.h"

#define kLabelHorizontalInsets 20.0f

@class NewDriversListViewController;

@interface DriversListCell : UITableViewCell

- (void)updateFonts;

@property (nonatomic, weak) NewDriversListViewController* parentController;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;
@property bool busy;
@end