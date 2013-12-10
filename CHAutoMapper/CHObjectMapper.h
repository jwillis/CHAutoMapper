#import <Foundation/Foundation.h>
#import "CHObjectMapping.h"

@interface CHObjectMapper : NSObject {
	NSMutableDictionary *mappings;    
}

- (void)mapClass:(Class)targetClass withOverride:(void (^)(CHObjectMapping *))overrideBlock;
- (void)mapClass:(Class)targetClass;
- (void)mapWithMapping:(CHObjectMapping *)mapping;
- (CHObjectMapping *)mappingForClass:(Class)targetClass;
+ (CHObjectMapper *)shared;

@end
