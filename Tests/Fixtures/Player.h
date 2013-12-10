#import <Foundation/Foundation.h>
#import "Team.h"

@interface Player : NSObject

@property (nonatomic, strong) NSNumber *playerId;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSDate *birthDate;
@property (nonatomic, strong) NSNumber *teamId;
@property (nonatomic, strong) Team *team;

@end
