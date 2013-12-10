@interface NSDate (CHAutoMapper)

extern NSString * const kCHIso8601DateFormat;

- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;
- (NSInteger)componentUnits:(NSUInteger)unitFlags;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithFormat:(NSString *)format andTimeZone:(NSTimeZone *)timeZone;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

@end