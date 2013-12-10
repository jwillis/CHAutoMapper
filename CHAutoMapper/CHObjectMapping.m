#import "CHObjectMapping.h"
#import "CHArrayMapping.h"
#import "NSString+CHAutoMapper.h"
#import "NSDate+CHAutoMapper.h"
#import "NSObject+CHMetadata.h"

@implementation CHObjectMapping

@synthesize targetClass, propertyMap, propertyName, keyFromPropertyName;

- (void)belongsTo:(Class)parentClass propertyName:(NSString *)name
{
    [self mapPropertyNamed:name mapping:[CHObjectMapping mappingForClass:parentClass keyFromPropertyName:self.keyFromPropertyName]];
}

- (void)hasMany:(Class)childClass propertyName:(NSString *)name
{
    [self mapPropertyNamed:name mapping:[CHArrayMapping mappingWithObjectMapping:
        [CHObjectMapping mappingForClass:childClass keyFromPropertyName:self.keyFromPropertyName]]];
}

- (id)map:(id)source
{
    if ([source isKindOfClass:[NSArray class]]) {
        return [[CHArrayMapping mappingWithObjectMapping:self] map:source];
    }
    
    NSObject *target = [[targetClass alloc] init];
    [self map:source onTo:target];
    return target;
}

- (void)map:(id)source onTo:(id)target
{
    source = [source dictionary];
    
    for (NSString *key in source) {
        id value = [source valueForKey:key];
        id property = [propertyMap valueForKey:key];
        
        if (!property || [value isKindOfClass:[NSNull class]]) {
            continue;
        }
        
        if ([property isKindOfClass:[CHObjectMapping class]]) {
        	CHObjectMapping *subMapping = (CHObjectMapping *)property; 
            value = [subMapping map:value];
            property = subMapping.propertyName;
        }
        else if ([[targetClass classOfPropertyNamed:property] isSubclassOfClass:[NSDate class]]
            && [value isKindOfClass:[NSString class]]) {
            value = [NSDate dateFromString:value withFormat:kCHIso8601DateFormat];
        }
        
        [target setValue:value forKey:property];
    }
}

- (void)mapPropertyNamed:(NSString *)propertyName_ toKey:(NSString *)key
{
    [propertyMap setValue:propertyName_ forKey:key];
}

- (void)mapPropertyNamed:(NSString *)propertyName_ mapping:(CHObjectMapping *)mapping
{
    mapping.propertyName = propertyName_;
    NSString *key = [[propertyMap allKeysForObject:propertyName_] objectAtIndex:0];
    [propertyMap setValue:mapping forKey:key];
}

- (void)ignorePropertyNamed:(NSString *)propertyName_
{
    NSString *keyMatch = nil;
    for (id key in [propertyMap allKeys]) {
        if ([[propertyMap objectForKey:key] isEqualToString:propertyName_]) {
            keyMatch = key;
            break;
        }
    }
    if (keyMatch) [propertyMap removeObjectForKey:keyMatch];
}

- (id)initWithTargetClass:(Class)targetClass_ propertyName:(NSString *)propertyName_ propertyMap:(NSDictionary *)propertyMap_
{
    if (self = [super init]) {
        self.targetClass = targetClass_;
        self.propertyName = propertyName_;
        self.propertyMap = [NSMutableDictionary dictionaryWithDictionary:propertyMap_];
    }
    return self;
}

+ (CHObjectMapping *)mappingForClass:(Class)targetClass propertyName:(NSString *)propertyName propertyMap:(NSDictionary *)propertyMap
{
    return [[CHObjectMapping alloc] initWithTargetClass:targetClass propertyName:propertyName propertyMap:propertyMap];
}

+ (CHObjectMapping *)mappingForClass:(Class)targetClass keyFromPropertyName:(KeyFromPropertyName)keyFromPropertyName
{
    CHObjectMapping *mapping = [[CHObjectMapping alloc] init];
    mapping.targetClass = targetClass;
    mapping.keyFromPropertyName = keyFromPropertyName;
    mapping.propertyMap = [NSMutableDictionary dictionaryWithDictionary:
        [self propertyMapForClass:targetClass keyFromPropertyName:keyFromPropertyName]];
    return mapping;
}

+ (CHObjectMapping *)underscoreMappingForClass:(Class)targetClass
{
    return [CHObjectMapping mappingForClass:targetClass keyFromPropertyName:[self underscoreKeyFromPropertyName]];
}

+ (CHObjectMapping *)identityMappingForClass:(Class)targetClass
{
    return [CHObjectMapping mappingForClass:targetClass keyFromPropertyName:^NSString *(NSString *propertyName, Class targetClass) {
    	return propertyName;   
    }];
}

+ (NSDictionary *)propertyMapForClass:(Class)targetClass keyFromPropertyName:(KeyFromPropertyName)keyFromPropertyName
{
    NSObject *object = [[targetClass alloc] init];
    NSArray *propertyNames = [[object class] propertyNames];
    NSMutableDictionary *propertyMap = [[NSMutableDictionary alloc] initWithCapacity:propertyNames.count];
    
    for (NSString *propertyName in propertyNames) {
        NSString *key = keyFromPropertyName(propertyName, targetClass);
        [propertyMap setValue:propertyName forKey:key];
    }
    
    return propertyMap;
}

+ (NSDictionary *)underscorePropertyMapForClass:(Class)targetClass
{
    return [self propertyMapForClass:targetClass keyFromPropertyName:[self underscoreKeyFromPropertyName]];
}

+ (KeyFromPropertyName)underscoreKeyFromPropertyName
{
    KeyFromPropertyName underscoreKeyFromPropertyName = ^NSString *(NSString *propertyName, Class targetClass) {
        BOOL isEntityId = [propertyName isEqualToString:[targetClass nameOfEntityIdProperty]];
        return isEntityId ? @"id" : [propertyName underscoreFromCamel];     
    };
    
    return underscoreKeyFromPropertyName;
}

@end
