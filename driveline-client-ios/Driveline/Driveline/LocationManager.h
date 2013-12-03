// LocationManager.h
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "DataManager.h"

@interface LocationManager : NSObject <CLLocationManagerDelegate>

+ (LocationManager *) sharedSingleton;
- (void)startStandardUpdates;

@end
