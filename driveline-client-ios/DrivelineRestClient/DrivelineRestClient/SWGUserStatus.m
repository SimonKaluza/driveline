#import "SWGDate.h"
#import "SWGUserStatus.h"

@implementation SWGUserStatus

-(id)status: (NSNumber*) status
    groupId: (NSNumber*) groupId
{
  _status = status;
  _groupId = groupId;
  return self;
}

-(id) initWithValues:(NSDictionary*)dict
{
    self = [super init];
    if(self) {
        _status = dict[@"status"]; 
        _groupId = dict[@"groupId"]; 
        

    }
    return self;
}

-(NSDictionary*) asDictionary {
    NSMutableDictionary* dict = [[NSMutableDictionary alloc] init];
    if(_status != nil) dict[@"status"] = _status ;
        if(_groupId != nil) dict[@"groupId"] = _groupId ;
        NSDictionary* output = [dict copy];
    return output;
}

@end

