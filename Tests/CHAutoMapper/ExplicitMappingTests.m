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
                @"T_ID" : @"teamId",
                @"T_NAME" : @"name",
                @"T_PLAYER_ARRAY" : [CHObjectMapping mappingForClass:[Player class] propertyName:@"players"
                    propertyMap:@{
                        @"P_ID" : @"playerId",
                        @"P_T_ID" : @"teamId"
                    }
                ]
            }
        ]
    ];
}

- (void)testExplicitMapping
{
   NSString *json = @"{ \"T_ID\": 1, \"T_NAME\": \"Bulls\", "
        "\"T_PLAYER_ARRAY\": ["
            "{ \"P_ID\": 1, \"P_T_ID\": 1 }, "
            "{ \"P_ID\": 2, \"P_T_ID\": 1 } ] }";
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
        options:kNilOptions error:NULL];
    
    Team *team = [[Team alloc] initWithDictionary:dictionary];
    Player *player = [team.players objectAtIndex:1];
    STAssertTrue([player.teamId isEqualToNumber:[NSNumber numberWithInt:1]], nil);
}

@end
