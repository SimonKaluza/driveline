#import <Foundation/Foundation.h>
#import "SWGObject.h"

@interface SWGGroup : SWGObject

@property(nonatomic) NSString* address;  

@property(nonatomic) NSString* name;  

@property(nonatomic) NSNumber* _id;  

@property(nonatomic) NSString* description;  

@property(nonatomic) NSString* adminEmail;  

@property(nonatomic) NSNumber* deleted;  

@property(nonatomic) NSNumber* usersAdminStatus;  

- (id) address: (NSString*) address
     name: (NSString*) name
     _id: (NSNumber*) _id
     description: (NSString*) description
     adminEmail: (NSString*) adminEmail
     deleted: (NSNumber*) deleted
     usersAdminStatus: (NSNumber*) usersAdminStatus;

- (id) initWithValues: (NSDictionary*)dict;
- (NSDictionary*) asDictionary;


@end

