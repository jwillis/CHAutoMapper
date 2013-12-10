#import "CHObjectMapper.h"

@implementation CHObjectMapper

- (void)mapClass:(Class)targetClass withOverride:(void (^)(CHObjectMapping *))overrideBlock
{
    CHObjectMapping *mapping = [CHObjectMapping underscoreMappingForClass:targetClass];
    if (overrideBlock) overrideBlock(mapping);
    [self mapWithMapping:mapping];
}

- (void)mapClass:(Class)targetClass
{
    [self mapClass:targetClass withOverride:nil];
}

- (void)mapWithMapping:(CHObjectMapping *)mapping
{
    [mappings setObject:mapping forKey:NSStringFromClass(mapping.targetClass)];
}

- (CHObjectMapping *)mappingForClass:(Class)targetClass
{
    return [mappings objectForKey:NSStringFromClass(targetClass)];
}

+ (CHObjectMapper *)shared
{
    static CHObjectMapper *shared;
    @synchronized (self) {
        if (!shared) {
            shared = [[CHObjectMapper alloc] init];
        }
    }
    return  shared;
}

- (id)init
{	
	if (self = [super init]) {
        mappings = [[NSMutableDictionary alloc] init];
    }
    return self;
}

@end
