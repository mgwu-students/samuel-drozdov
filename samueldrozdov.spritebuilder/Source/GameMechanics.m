//
//  GameMechanics.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameMechanics.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

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
        self.paused = false;
        self.classicScore = 0;
        self.ballRadius = 32;
        self.zenScore = 0;
        self.marathonScore = 0;
        self.insanityScore = 0;
        self.calibration = 0;
    }
    return self;
}




@end
