#import <Foundation/Foundation.h>
#import "SWGObject.h"
#import "SWGUser.h"

@interface SWGGroupUser : SWGObject

@property(nonatomic) NSNumber* status;  

@property(nonatomic) NSNumber* admin;  

@property(nonatomic) SWGUser* user;  

- (id) status: (NSNumber*) status
     admin: (NSNumber*) admin
     user: (SWGUser*) user;

- (id) initWithValues: (NSDictionary*)dict;
- (NSDictionary*) asDictionary;


@end

