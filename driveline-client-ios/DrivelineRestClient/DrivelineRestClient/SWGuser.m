#import "SWGDate.h"
#import "SWGUser.h"

@implementation SWGUser

-(id)password: (NSString*) password
    email: (NSString*) email
    admin: (NSNumber*) admin
    userStatus: (NSNumber*) userStatus
    firstName: (NSString*) firstName
    lastName: (NSString*) lastName
    phone: (NSString*) phone
    seats: (NSNumber*) seats
    deleted: (NSNumber*) deleted
    lastLatitude: (NSNumber*) lastLatitude
    lastLongitude: (NSNumber*) lastLongitude
{
  _password = password;
  _email = email;
  _admin = admin;
  _userStatus = userStatus;
  _firstName = firstName;
  _lastName = lastName;
  _phone = phone;
  _seats = seats;
  _deleted = deleted;
  _lastLatitude = lastLatitude;
  _lastLongitude = lastLongitude;
  return self;
}

-(id) initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        _password = dict[@"password"]; 
        _email = dict[@"email"]; 
        _admin = dict[@"admin"]; 
        _userStatus = dict[@"userStatus"]; 
        _firstName = dict[@"firstName"]; 
        _lastName = dict[@"lastName"]; 
        _phone = dict[@"phone"]; 
        _seats = dict[@"seats"]; 
        _deleted = dict[@"deleted"]; 
        _lastLatitude = dict[@"lastLatitude"]; 
        _lastLongitude = dict[@"lastLongitude"]; 
        

    }
    return self;
}

-(NSDictionary*) asDictionary {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(_password != nil) dict[@"password"] = _password ;
        if(_email != nil) dict[@"email"] = _email ;
        if(_admin != nil) dict[@"admin"] = _admin ;
        if(_userStatus != nil) dict[@"userStatus"] = _userStatus ;
        if(_firstName != nil) dict[@"firstName"] = _firstName ;
        if(_lastName != nil) dict[@"lastName"] = _lastName ;
        if(_phone != nil) dict[@"phone"] = _phone ;
        if(_seats != nil) dict[@"seats"] = _seats ;
        if(_deleted != nil) dict[@"deleted"] = _deleted ;
        if(_lastLatitude != nil) dict[@"lastLatitude"] = _lastLatitude ;
        if(_lastLongitude != nil) dict[@"lastLongitude"] = _lastLongitude ;
        NSDictionary* output = [dict copy];
    return output;
}

@end

