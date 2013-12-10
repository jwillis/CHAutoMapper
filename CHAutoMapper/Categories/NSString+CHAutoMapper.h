@interface NSString (CHAutoMapper)

- (NSString *)camelizeFromUnderscore;
- (NSString *)underscoreFromCamel;
- (NSString *)camelizeFromPascal;
- (NSString *)pascalizeFromCamel;

@end
