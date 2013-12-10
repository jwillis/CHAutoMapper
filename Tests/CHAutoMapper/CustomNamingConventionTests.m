#import "CustomNamingConventionTests.h"
#import "CHAutoMapper.h"
#import "NSString+CHAutoMapper.h"
#import "Team.h"

@implementation CustomNamingConventionTests

- (void)testMapWithPascalNamingConvention
{
	[[CHObjectMapper shared] mapWithMapping:[CHObjectMapping mappingForClass:[Team class]
        keyFromPropertyName:^NSString *(NSString *propertyName, Class targetClass) {
            return [[propertyName pascalizeFromCamel] stringByReplacingOccurrencesOfString:@"Id" withString:@"ID"];
        }
    ]];
    
    NSString *json = @"{ \"TeamID\": 1, \"Name\": \"Bulls\", \"HeadCoachID\": 4 }";
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                               options:kNilOptions error:NULL];
    Team *team = [[Team alloc] initWithDictionary:dictionary];
    STAssertTrue([team.teamId isEqualToNumber:[NSNumber numberWithInt:1]], nil);
    STAssertTrue([team.name isEqualToString:@"Bulls"], nil);
    STAssertTrue([team.headCoachId isEqualToNumber:[NSNumber numberWithInt:4]], nil);
}

@end
