#import "NSObject+CHMetadata.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation NSObject (CHMetadata)

+ (BOOL)hasPropertyNamed:(NSString *)name
{
    return class_getProperty(self.class, [name UTF8String]) != NULL;
}

+ (NSString *)encodedClassNameOfPropertyNamed:(NSString *)name
{
    objc_property_t property = class_getProperty(self.class, [name UTF8String]);
	
    if (property == NULL)
        return nil;
    
    const char *attrs = property_getAttributes(property);
	if (attrs == NULL)
		return nil;
    
	static char buffer[256];
	const char *e = strchr(attrs, ',');
	if (e == NULL)
		return nil;
    
	int len = (int)(e - attrs);
	memcpy(buffer, attrs, len);
	buffer[len] = '\0';
    
    NSString *className = [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
    return className;
}

+ (Class)classOfPropertyNamed:(NSString *)name
{
    NSString *className = [self encodedClassNameOfPropertyNamed:name];
    
    if (className.length < 3)
        return nil;
    
    className = [className substringFromIndex:3];
    className = [className substringToIndex:[className length] - 1];
    
    return NSClassFromString(className);
}

+ (NSArray *)propertyNames
{
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(self.class, &count);
    
    for(int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithCString:property_getName(property)
                                            encoding:NSUTF8StringEncoding];
        [names addObject:name];
    }
    
    free(properties);
    
    return names;
}

+ (NSString *)nameOfEntityIdProperty
{
    NSString *className = [NSString stringWithUTF8String:class_getName(self.class)];
    
    NSString *nameOfEntityIdProperty = [NSString stringWithFormat:@"%c%@Id",
                                        tolower([className characterAtIndex:0]),
                                        [className substringFromIndex:1]];
    
    return [self.class hasPropertyNamed:nameOfEntityIdProperty] ? nameOfEntityIdProperty : nil;
}

- (BOOL)entityIdPropertyIsSet
{
    NSString *entityIdProperty = [self.class nameOfEntityIdProperty];
    return (entityIdProperty && [self valueForKey:entityIdProperty]);
}

- (NSDictionary *)dictionary
{
    return [self isKindOfClass:[NSDictionary class]]
    	? (NSDictionary *)self
    	: [self dictionaryWithValuesForKeys:self.class.propertyNames];
}

@end
