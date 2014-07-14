//
//  GameMechanics.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameMechanics.h"

static NSString *const GAME_STATE_SCORE_KEY = @"GameStateScoreKey";
static NSString *const GAME_STATE_TIME_KEY = @"GameStateTimeKey";

@implementation GameMechanics 

static GameMechanics *sharedInstance = nil;

+(instancetype)sharedInstance {
    
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    
    return sharedInstance;
}

- (id)init
{
    if (self = [super init])
    {
        _motionManager = [[CMMotionManager alloc] init];
        
        self.highScoreSet = false;
        self.classicScore = 0;
        self.zenScore = 0;
        self.marathonScore = 0;
        self.insanityScore = 0;
    }
    return self;
}

#pragma mark - Setter Override

//- (void)setScore:(NSInteger)score {
//    _score = score;
//    
//    NSNumber *scoreNumber = [NSNumber numberWithInt:score];
//    
//    // broadcast change
//    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_SCORE_NOTIFICATION object:scoreNumber];
//    
//    // store change
//    [[NSUserDefaults standardUserDefaults]setObject:scoreNumber forKey:GAME_STATE_SCORE_KEY];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}
//
//- (void)setTime:(NSInteger)time {
//    _time = time;
//    
//    NSNumber *timeNumber = [NSNumber numberWithInt:time];
//    
//    // broadcast change
//    [[NSNotificationCenter defaultCenter]postNotificationName:GAME_STATE_TIME_NOTIFICATION object:timeNumber];
//    
//    // store change
//    [[NSUserDefaults standardUserDefaults]setObject:timeNumber forKey:GAME_STATE_TIME_KEY];
//    [[NSUserDefaults standardUserDefaults]synchronize];
//}





@end
