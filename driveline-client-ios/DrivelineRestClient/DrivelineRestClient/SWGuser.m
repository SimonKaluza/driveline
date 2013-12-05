#import "SWGDate.h"
#import "SWGUser.h"

@implementation SWGUser

-(id)password: (NSString*) password
    email: (NSString*) email
    lastLatitude: (NSNumber*) lastLatitude
    lastLongitude: (NSNumber*) lastLongitude
    firstName: (NSString*) firstName
    lastName: (NSString*) lastName
    phone: (NSString*) phone
    userStatus: (NSNumber*) userStatus
    seats: (NSNumber*) seats
    admin: (NSNumber*) admin
    deleted: (NSNumber*) deleted
{
  _password = password;
  _email = email;
  _lastLatitude = lastLatitude;
  _lastLongitude = lastLongitude;
  _firstName = firstName;
  _lastName = lastName;
  _phone = phone;
  _userStatus = userStatus;
  _seats = seats;
  _admin = admin;
  _deleted = deleted;
  return self;
}

-(id) initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        _password = dict[@"password"]; 
        _email = dict[@"email"]; 
        _lastLatitude = dict[@"lastLatitude"]; 
        _lastLongitude = dict[@"lastLongitude"]; 
        _firstName = dict[@"firstName"]; 
        _lastName = dict[@"lastName"]; 
        _phone = dict[@"phone"]; 
        _userStatus = dict[@"userStatus"]; 
        _seats = dict[@"seats"]; 
        _admin = dict[@"admin"]; 
        _deleted = dict[@"deleted"]; 
        

    }
    return self;
}

-(NSDictionary*) asDictionary {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(_password != nil) dict[@"password"] = _password ;
        if(_email != nil) dict[@"email"] = _email ;
        if(_lastLatitude != nil) dict[@"lastLatitude"] = _lastLatitude ;
        if(_lastLongitude != nil) dict[@"lastLongitude"] = _lastLongitude ;
        if(_firstName != nil) dict[@"firstName"] = _firstName ;
        if(_lastName != nil) dict[@"lastName"] = _lastName ;
        if(_phone != nil) dict[@"phone"] = _phone ;
        if(_userStatus != nil) dict[@"userStatus"] = _userStatus ;
        if(_seats != nil) dict[@"seats"] = _seats ;
        if(_admin != nil) dict[@"admin"] = _admin ;
        if(_deleted != nil) dict[@"deleted"] = _deleted ;
        NSDictionary* output = [dict copy];
    return output;
}

@end

