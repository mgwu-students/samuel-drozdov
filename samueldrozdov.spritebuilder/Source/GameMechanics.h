//
//  GameMechanics.h
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCScene.h"

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>
#import "GameMechanics.h"
#import "Ball.h"
#import "Crosshair.h"
#import "PauseScreen.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@interface GameMechanics : CCScene

+ (instancetype)sharedInstance;

@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) NSString *previousGameMode;
@property (nonatomic, assign) int ballRadius;
@property (nonatomic, assign) bool paused;
@property (nonatomic, assign) float calibration;

@property (nonatomic, assign) int score;
@property (nonatomic, assign) int time;
@property (nonatomic, assign) float classicTime;

#pragma mark - High Score Variables

@property (nonatomic, assign) bool highScoreSet;
@property (nonatomic, assign) float classicScore;
@property (nonatomic, assign) int zenScore;
@property (nonatomic, assign) int marathonScore;
@property (nonatomic, assign) int insanityScore;

@end
