#import "SWGDate.h"
#import "SWGUserStatus.h"

@implementation SWGUserStatus

-(id)groupId: (NSNumber*) groupId
    status: (NSNumber*) status
{
  _groupId = groupId;
  _status = status;
  return self;
}

-(id) initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        _groupId = dict[@"groupId"]; 
        _status = dict[@"status"]; 
        

    }
    return self;
}

-(NSDictionary*) asDictionary {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(_groupId != nil) dict[@"groupId"] = _groupId ;
        if(_status != nil) dict[@"status"] = _status ;
        NSDictionary* output = [dict copy];
    return output;
}

@end

