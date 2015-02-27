#import "NSDate+CHAutoMapper.h"

@implementation NSDate (CHAutoMapper)

NSString * const kCHIso8601DateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format
{
    if (string == (id)[NSNull null] || string.length == 0)
        return nil;
    	
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = format;
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
	formatter.locale = locale;
	return [formatter dateFromString:string];
}

@end
