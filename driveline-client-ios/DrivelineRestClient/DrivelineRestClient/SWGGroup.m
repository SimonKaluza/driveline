#import "SWGDate.h"
#import "SWGGroup.h"

@implementation SWGGroup

-(id)address: (NSString*) address
    name: (NSString*) name
    _id: (NSNumber*) _id
    description: (NSString*) description
    adminEmail: (NSString*) adminEmail
    deleted: (NSNumber*) deleted
{
  _address = address;
  _name = name;
  __id = _id;
  _description = description;
  _adminEmail = adminEmail;
  _deleted = deleted;
  return self;
}

-(id) initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        _address = dict[@"address"]; 
        _name = dict[@"name"]; 
        __id = dict[@"id"]; 
        _description = dict[@"description"]; 
        _adminEmail = dict[@"adminEmail"]; 
        _deleted = dict[@"deleted"]; 
        

    }
    return self;
}

-(NSDictionary*) asDictionary {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(_address != nil) dict[@"address"] = _address ;
        if(_name != nil) dict[@"name"] = _name ;
        if(__id != nil) dict[@"id"] = __id ;
        if(_description != nil) dict[@"description"] = _description ;
        if(_adminEmail != nil) dict[@"adminEmail"] = _adminEmail ;
        if(_deleted != nil) dict[@"deleted"] = _deleted ;
        NSDictionary* output = [dict copy];
    return output;
}

@end

