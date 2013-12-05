#import <Foundation/Foundation.h>
#import "SWGObject.h"

@interface SWGUserStatus : SWGObject

@property(nonatomic) NSNumber* status;  

@property(nonatomic) NSNumber* groupId;  

- (id) status: (NSNumber*) status
     groupId: (NSNumber*) groupId;

- (id) initWithValues: (NSDictionary*)dict;
- (NSDictionary*) asDictionary;


@end

