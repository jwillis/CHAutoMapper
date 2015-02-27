#import "ExplicitMappingTests.h"
#import "CHAutoMapper.h"
#import "Team.h"
#import "Player.h"

@implementation ExplicitMappingTests

- (void)setUp
{
    // This mapping needs to be explicit because the source data has unconventional keys.
    
    [[CHObjectMapper shared] mapWithMapping:
        [CHObjectMapping mappingForClass:[Team class] propertyName:nil
            propertyMap:@{
                @"__TEAM_ID__" : @"teamId",
                @"__NAME__" : @"name",
                @"__PLAYER_ARRAY__" : [CHObjectMapping mappingForClass:[Player class] propertyName:@"players"
                    propertyMap:@{
                        @"__PLAYER_ID__" : @"playerId",
                        @"__TEAM_ID__" : @"teamId"
                    }
                ]
            }
        ]
    ];
}

- (void)testExplicitMapping
{
   NSString *json = @"{ \"__TEAM_ID__\": 1, \"__NAME__\": \"Bulls\", "
        "\"__PLAYER_ARRAY__\": ["
            "{ \"__PLAYER_ID__\": 1, \"__TEAM_ID__\": 1 }, "
            "{ \"__PLAYER_ID__\": 2, \"__TEAM_ID__\": 1 } ] }";
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
        options:kNilOptions error:NULL];
    
    Team *team = [[Team alloc] initWithDictionary:dictionary];
    Player *player = [team.players objectAtIndex:1];
    XCTAssertTrue([player.teamId isEqualToNumber:[NSNumber numberWithInt:1]]);
}

@end
