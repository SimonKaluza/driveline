#import <Foundation/Foundation.h>
#import "SWGObject.h"

@interface SWGUser : SWGObject

@property(nonatomic) NSString* password;  

@property(nonatomic) NSString* email;  

@property(nonatomic) NSNumber* lastLatitude;  

@property(nonatomic) NSNumber* lastLongitude;  

@property(nonatomic) NSString* firstName;  

@property(nonatomic) NSString* lastName;  

@property(nonatomic) NSString* phone;  

@property(nonatomic) NSNumber* userStatus;  

@property(nonatomic) NSNumber* seats;  

@property(nonatomic) NSNumber* admin;  

@property(nonatomic) NSNumber* deleted;  

- (id) password: (NSString*) password
     email: (NSString*) email
     lastLatitude: (NSNumber*) lastLatitude
     lastLongitude: (NSNumber*) lastLongitude
     firstName: (NSString*) firstName
     lastName: (NSString*) lastName
     phone: (NSString*) phone
     userStatus: (NSNumber*) userStatus
     seats: (NSNumber*) seats
     admin: (NSNumber*) admin
     deleted: (NSNumber*) deleted;

- (id) initWithValues: (NSDictionary*)dict;
- (NSDictionary*) asDictionary;


@end

