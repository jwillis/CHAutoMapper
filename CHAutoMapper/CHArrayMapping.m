#import "CHArrayMapping.h"

@implementation CHArrayMapping

- (id)map:(id)source
{
    NSArray *array = (NSArray *)source;
    NSMutableArray *target = [[NSMutableArray alloc] initWithCapacity:array.count];
    
    for (id element in array) {
		id value = [super map:element];
		[target addObject:value];
    }
    
    return target;
}

+ (CHArrayMapping *)mappingWithObjectMapping:(CHObjectMapping *)objectMapping
{
    return [[CHArrayMapping alloc] initWithTargetClass:objectMapping.targetClass propertyName:nil propertyMap:objectMapping.propertyMap];
}

@end
