#import <Foundation/Foundation.h>
#import "SWGObject.h"

@interface SWGUserStatus : SWGObject

@property(nonatomic) NSNumber* groupId;  

@property(nonatomic) NSNumber* status;  

- (id) groupId: (NSNumber*) groupId
     status: (NSNumber*) status;

- (id) initWithValues: (NSDictionary*)dict;
- (NSDictionary*) asDictionary;


@end

