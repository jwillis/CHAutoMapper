#import <Foundation/Foundation.h>

@interface CHObjectMapping : NSObject

typedef NSString *(^KeyFromPropertyName)(NSString *, Class);

@property (assign) Class targetClass;
@property (strong, nonatomic) NSMutableDictionary *propertyMap;
@property (strong, nonatomic) NSString *propertyName;
@property (strong, nonatomic) KeyFromPropertyName keyFromPropertyName;

- (void)belongsTo:(Class)parentClass propertyName:(NSString *)propertyName;

- (void)hasMany:(Class)childClass propertyName:(NSString *)propertyName;

- (id)map:(id)source;

- (void)map:(id)source onTo:(id)target;

- (void)mapPropertyNamed:(NSString *)propertyName toKey:(NSString *)key;

- (void)ignorePropertyNamed:(NSString *)propertyName;

- (id)initWithTargetClass:(Class)targetClass propertyName:(NSString *)propertyName propertyMap:(NSDictionary *)propertyMap;

+ (CHObjectMapping *)mappingForClass:(Class)targetClass keyFromPropertyName:(KeyFromPropertyName)keyFromPropertyName;

+ (CHObjectMapping *)underscoreMappingForClass:(Class)targetClass;

+ (CHObjectMapping *)identityMappingForClass:(Class)targetClass;

+ (CHObjectMapping *)mappingForClass:(Class)targetClass propertyName:(NSString *)propertyName propertyMap:(NSDictionary *)propertyMap;

@end
