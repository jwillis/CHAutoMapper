#import "AutoMappingTests.h"
#import "CHAutoMapper.h"
#import "Team.h"
#import "Player.h"
#import "NSObject+CHMetaData.h"

@implementation AutoMappingTests

- (void)setUp
{
    [[CHObjectMapper shared] mapClass:[Team class] withOverride:^(CHObjectMapping *team) {
        [team hasMany:[Player class] propertyName:@"players"];
    }];
    
    [[CHObjectMapper shared] mapClass:[Player class] withOverride:^(CHObjectMapping *player) {
        [player belongsTo:[Team class] propertyName:@"team"];
    }];
}

- (void)testMapWithUnderscoreNamingConvention
{
	NSString *json = @"{ \"id\": 1, \"name\": \"Bulls\", \"head_coach_id\": 4 }";
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
        options:kNilOptions error:NULL];
    
    Team *team = [[Team alloc] initWithDictionary:dictionary];
    XCTAssertTrue([team.teamId isEqualToNumber:[NSNumber numberWithInt:1]]);
    XCTAssertTrue([team.name isEqualToString:@"Bulls"]);
    XCTAssertTrue([team.headCoachId isEqualToNumber:[NSNumber numberWithInt:4]]);
}

- (void)testBelongsTo
{
	NSString *json = @"{ \"id\": 1, \"team_id\": 1, "
        "\"team\": { \"id\": 1, \"name\": \"Bulls\" } }";
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
        options:kNilOptions error:NULL];
    
    Player *player = [[Player alloc] initWithDictionary:dictionary];
    Team *team = player.team;
    XCTAssertTrue([player.playerId isEqualToNumber:[NSNumber numberWithInt:1]]);
    XCTAssertTrue([player.teamId isEqualToNumber:[NSNumber numberWithInt:1]]);
    XCTAssertNotNil(team);
    XCTAssertTrue([team.name isEqualToString:@"Bulls"]);
}

- (void)testHasMany
{
	NSString *json = @"{ \"id\": 1, \"name\": \"Bulls\", "
    	"\"players\": ["
        "{ \"id\": 1, \"team_id\": 1 }, "
        "{ \"id\": 2, \"team_id\": 1 } ] }";
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
        options:kNilOptions error:NULL];
    
    Team *team = [[Team alloc] initWithDictionary:dictionary];
    Player *player = [team.players objectAtIndex:1];
    XCTAssertTrue([player.teamId isEqualToNumber:[NSNumber numberWithInt:1]]);
}

@end
