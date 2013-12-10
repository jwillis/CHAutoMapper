#import "NSDate+CHAutoMapper.h"

@implementation NSDate (CHAutoMapper)

NSString * const kCHIso8601DateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";

- (NSInteger)year
{
    return [self componentUnits:NSYearCalendarUnit];
}

- (NSInteger)month
{
    return [self componentUnits:NSMonthCalendarUnit];
}

- (NSInteger)day
{
    return [self componentUnits:NSDayCalendarUnit];
}

- (NSInteger)hour
{
    return [self componentUnits:NSHourCalendarUnit];
}

- (NSInteger)minute
{
    return [self componentUnits:NSMinuteCalendarUnit];
}

- (NSInteger)second
{ 
    return [self componentUnits:NSSecondCalendarUnit];
}

- (NSInteger)componentUnits:(NSUInteger)unitFlags
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    int units = 0;
    
    if (unitFlags == NSYearCalendarUnit)
        units = [components year];
    else if (unitFlags == NSMonthCalendarUnit)
        units = [components month];
    else if (unitFlags == NSDayCalendarUnit)
        units = [components day];
    else if (unitFlags == NSHourCalendarUnit)
        units = [components hour];
    else if (unitFlags == NSMinuteCalendarUnit)
        units = [components minute];
    else if (unitFlags == NSSecondCalendarUnit)
        units = [components second];
        
    return units;
}

- (NSString *)stringWithFormat:(NSString *)format
{
    return [self stringWithFormat:format andTimeZone:[NSTimeZone localTimeZone]];
}

- (NSString *)stringWithFormat:(NSString *)format andTimeZone:(NSTimeZone *)timeZone {
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = format;
	formatter.timeZone = timeZone;
	NSString *string = [formatter stringFromDate:self];
	return string;
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    calendar.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    return [calendar dateFromComponents:components];
}

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
