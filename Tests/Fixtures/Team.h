#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, retain) NSNumber *teamId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *headCoachId;
@property (nonatomic, retain) NSMutableArray *players;

@end
