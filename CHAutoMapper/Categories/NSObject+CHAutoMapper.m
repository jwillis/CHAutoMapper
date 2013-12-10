#import "NSObject+CHAutoMapper.h"
#import "CHObjectMapper.h"

@implementation NSObject (CHAutoMapper)

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [self init]) {
        [[[CHObjectMapper shared] mappingForClass:[self class]] map:dictionary onTo:self];
    }
    return self;
}

@end
