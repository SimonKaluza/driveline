// LocationManager.m
//
// Simon Kaluza
// University of New Haven
// Master's Project -- Driveline

#import "LocationManager.h"
@interface LocationManager()
@property (nonatomic) CLLocationManager* locationManager;
@end

@implementation LocationManager
@synthesize locationManager;


+ (LocationManager *)sharedSingleton
{
    static LocationManager *sharedSingleton;
    
    @synchronized(self)
    {
        if (!sharedSingleton)
            sharedSingleton = [[LocationManager alloc] init];
        
        return sharedSingleton;
    }
}

// Initialize the Core location Manager and begin listening for updates
- (void)startStandardUpdates
{
    if (nil == locationManager)
        locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 500; // meters
    
    [locationManager startUpdatingLocation];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power.
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 30.0) {
        // If the event is recent, update the user's location.
        NSLog(@"latitude %+.6f, longitude %+.6f\n",
              location.coordinate.latitude,
              location.coordinate.longitude);
        [DataManager sharedSingleton].currentUser.lastLatitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        [DataManager sharedSingleton].currentUser.lastLongitude = [NSNumber numberWithDouble:location.coordinate.longitude];
        [[DataManager sharedSingleton] sendCurrentUserUpdate];
    }
}

@end