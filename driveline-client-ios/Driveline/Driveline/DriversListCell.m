// DriversListCell.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "DriversListCell.h"

@interface DriversListCell ()
@property (nonatomic, assign) BOOL didSetupConstraints;

@end

@implementation DriversListCell
@synthesize parentController;
@synthesize busy;

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        UIImage *image = [UIImage imageNamed:@"steeringwheel"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setImage:image forState:UIControlStateNormal];
        //UIImageView* button = [[UIImageView alloc] initWithImage:image];
        button.tintColor = [UIColor greenColor];
        CGRect frame = CGRectMake(0.0, 0.0, image.size.width, image.size.height);
        button.frame = frame;	// match the button's size with the image size
        self.accessoryView = button;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.titleLabel setNumberOfLines:1];
        [self.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [self.titleLabel setTextColor:[UIColor blackColor]];
        [self.titleLabel setBackgroundColor:[UIColor clearColor]];
        
        self.bodyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.bodyLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.bodyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
        [self.bodyLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.bodyLabel setNumberOfLines:0];
        [self.bodyLabel setTextAlignment:NSTextAlignmentLeft];
        [self.bodyLabel setTextColor:[UIColor darkGrayColor]];
        [self.bodyLabel setBackgroundColor:[UIColor clearColor]];
        
        //[self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.bodyLabel];
    }
    return self;
}

- (void)updateConstraints {
    [super updateConstraints];
    
    if (self.didSetupConstraints) return;
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.titleLabel
                                     attribute:NSLayoutAttributeLeading
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeLeading
                                     multiplier:1.0f
                                     constant:kLabelHorizontalInsets]];
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.titleLabel
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1.0f
                                     constant:(kLabelHorizontalInsets / 2)]];
    
    [self.contentView addConstraint:[NSLayoutConstraint
                                     constraintWithItem:self.titleLabel
                                     attribute:NSLayoutAttributeTrailing
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:self.contentView
                                     attribute:NSLayoutAttributeTrailing
                                     multiplier:1.0f
                                     constant:-kLabelHorizontalInsets]];
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.bodyLabel
                                      attribute:NSLayoutAttributeLeading
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeLeading
                                      multiplier:1.0f
                                      constant:kLabelHorizontalInsets]];
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.bodyLabel
                                      attribute:NSLayoutAttributeTop
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.titleLabel
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:(kLabelHorizontalInsets / 4)]];
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.bodyLabel
                                      attribute:NSLayoutAttributeTrailing
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeTrailing
                                      multiplier:1.0f
                                      constant:-kLabelHorizontalInsets]];
    
    [self.contentView  addConstraint:[NSLayoutConstraint
                                      constraintWithItem:self.bodyLabel
                                      attribute:NSLayoutAttributeBottom
                                      relatedBy:NSLayoutRelationEqual
                                      toItem:self.contentView
                                      attribute:NSLayoutAttributeBottom
                                      multiplier:1.0f
                                      constant:-(kLabelHorizontalInsets / 2)]];
    
    self.didSetupConstraints = YES;
}

- (void)updateFonts
{
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.bodyLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleCaption2];
}

- (void) setBusy:(bool) busyP {
    busy = busyP;
	UIButton* button = (UIButton *) self.accessoryView;
    button.tintColor = (busy) ? [UIColor redColor]: [UIColor greenColor];
}

- (bool) busy{
    return busy;
}

@end