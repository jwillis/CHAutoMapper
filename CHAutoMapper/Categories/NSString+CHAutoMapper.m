#import "NSString+CHAutoMapper.h"

@implementation NSString (CHAutoMapper)

- (NSString *)camelizeFromUnderscore
{
    NSString *camel = @"";
    
    BOOL upcaseNextCharacter = NO;
    
    for (int i = 0; i < [self length]; i++) {
        
        unichar character = [self characterAtIndex:i];
        
        if (character == '_') {
            upcaseNextCharacter =  YES;
            continue;
        }
        
        if (upcaseNextCharacter) {
            character = toupper(character);
            upcaseNextCharacter = NO;
        }
        
        camel = [camel stringByAppendingFormat:@"%c", character];
    }
    
    return camel;
}

- (NSString *)underscoreFromCamel
{
    NSString *underscore = @"";
    
    for (int i = 0; i < self.length; i++) {
        
        unichar character = [self characterAtIndex:i];
        
        if (isupper(character)) {
            underscore = [underscore stringByAppendingString:@"_"];
        }
        
        underscore = [underscore stringByAppendingFormat:@"%c", tolower(character)];
    }
    
    return underscore;
}

- (NSString *)camelizeFromPascal
{
    if (self.length == 0) return self;
    
    return [NSString stringWithFormat:@"%c%@",
            tolower([self characterAtIndex:0]),
            [self substringFromIndex:1]];
}

- (NSString *)pascalizeFromCamel
{
    if (self.length == 0) return self;
    
    return [NSString stringWithFormat:@"%c%@",
            toupper([self characterAtIndex:0]),
            [self substringFromIndex:1]];
}

@end
