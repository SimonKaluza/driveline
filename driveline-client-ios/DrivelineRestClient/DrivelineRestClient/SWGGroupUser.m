#import "SWGDate.h"
#import "SWGGroupUser.h"

@implementation SWGGroupUser

-(id)status: (NSNumber*) status
    admin: (NSNumber*) admin
    user: (SWGUser*) user
{
  _status = status;
  _admin = admin;
  _user = user;
  return self;
}

-(id) initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        _status = dict[@"status"]; 
        _admin = dict[@"admin"]; 
        id user_dict = dict[@"user"];
        if(user_dict != nil)
            _user = [[SWGUser alloc]initWithValues:user_dict];
        

    }
    return self;
}

-(NSDictionary*) asDictionary {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(_status != nil) dict[@"status"] = _status ;
        if(_admin != nil) dict[@"admin"] = _admin ;
        if(_user != nil){
        if([_user isKindOfClass:[NSArray class]]){
            NSMutableArray * array = [[NSMutableArray alloc] init];
            for( SWGUser *user in (NSArray*)_user) {
                [array addObject:[(SWGObject*)user asDictionary]];
            }
            dict[@"user"] = array;
        }
        else if(_user && [_user isKindOfClass:[SWGDate class]]) {
            NSString * dateString = [(SWGDate*)_user toString];
            if(dateString){
                dict[@"user"] = dateString;
            }
        }
        else {
        if(_user != nil) dict[@"user"] = [(SWGObject*)_user asDictionary];
        }
    }
    NSDictionary* output = [dict copy];
    return output;
}

@end

