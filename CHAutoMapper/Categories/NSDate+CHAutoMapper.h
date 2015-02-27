@interface NSDate (CHAutoMapper)

extern NSString * const kCHIso8601DateFormat;

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

@end