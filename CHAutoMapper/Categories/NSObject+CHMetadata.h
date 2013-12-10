@interface NSObject (CHMetadata)

+ (BOOL)hasPropertyNamed:(NSString *)name;
+ (Class)classOfPropertyNamed:(NSString *)name;
+ (NSString *)encodedClassNameOfPropertyNamed:(NSString *)name;
+ (NSArray *)propertyNames;
+ (NSString *)nameOfEntityIdProperty;
- (BOOL)entityIdPropertyIsSet;
- (NSDictionary *)dictionary;


@end
