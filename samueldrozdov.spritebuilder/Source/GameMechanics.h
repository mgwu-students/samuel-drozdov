//
//  GameMechanics.h
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

static NSString *const GAME_STATE_SCORE_NOTIFICATION = @"GameState_ScoreChanged";
static NSString *const GAME_STATE_TIME_NOTIFICATION = @"GameState_TimeChanged";

@interface GameMechanics : NSObject

+ (instancetype)sharedInstance;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) NSString *gameMode;
@property (nonatomic, assign) NSString *previousGameMode;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) float classicTime;

@property (nonatomic, assign) bool highScoreSet;
@property (nonatomic, assign) int classicScore;
@property (nonatomic, assign) int zenScore;
@property (nonatomic, assign) int marathonScore;
@property (nonatomic, assign) int insanityScore;

@end
