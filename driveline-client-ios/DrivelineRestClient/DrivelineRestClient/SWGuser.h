#import <Foundation/Foundation.h>
#import "SWGObject.h"

@interface SWGUser : SWGObject

@property(nonatomic) NSString* password;  

@property(nonatomic) NSString* email;  

@property(nonatomic) NSNumber* admin;  

@property(nonatomic) NSNumber* userStatus;  

@property(nonatomic) NSString* firstName;  

@property(nonatomic) NSString* lastName;  

@property(nonatomic) NSString* phone;  

@property(nonatomic) NSNumber* seats;  

@property(nonatomic) NSNumber* deleted;  

@property(nonatomic) NSNumber* lastLatitude;  

@property(nonatomic) NSNumber* lastLongitude;  

- (id) password: (NSString*) password
     email: (NSString*) email
     admin: (NSNumber*) admin
     userStatus: (NSNumber*) userStatus
     firstName: (NSString*) firstName
     lastName: (NSString*) lastName
     phone: (NSString*) phone
     seats: (NSNumber*) seats
     deleted: (NSNumber*) deleted
     lastLatitude: (NSNumber*) lastLatitude
     lastLongitude: (NSNumber*) lastLongitude;

- (id) initWithValues: (NSDictionary*)dict;
- (NSDictionary*) asDictionary;


@end

