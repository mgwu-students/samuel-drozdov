//
//  Gameplay.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Ball.h"
#import "Crosshair.h"
#import <CoreMotion/CoreMotion.h>

@implementation Gameplay {
    
    // motion manager (cannot make more than one)
    CMMotionManager *_motionManager;
    
    // time variables
    CCLabelTTF *_timeLabel;
    int time;
    
    // moving nodes
    Ball *ball;
    Crosshair *crosshair;
}

- (id)init
{
    if (self = [super init])
    {
        crosshair = (Crosshair*)[CCBReader load:@"Crosshair"];
        [self addChild:crosshair z:5]; // high 'z' value so its visible and over the other nodes
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    crosshair.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
    [_motionManager startAccelerometerUpdates];
}
- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    //spawns a ball randomly on the screen
    ball = (Ball*)[CCBReader load:@"Ball"];
    // find the size of the gameplay scene
    CGSize bbsize = [[UIScreen mainScreen] bounds].size;
    // position the ball randomly in the gameplay scene
    ball.position = ccp(arc4random_uniform(bbsize.width - 70),arc4random_uniform(bbsize.height - 70));
    // add the ball to the Gameplay scene
    [self addChild:ball];
    
    time = 600;
}




// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //
}

// updates that happen in time
- (void)update:(CCTime)delta {
    
    // updates the time counter
    time -= .1;
    _timeLabel.string = [NSString stringWithFormat:@"%d", time];
    
    
    // accelerometer data to be updated
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = crosshair.position.x + acceleration.y * 1000 * delta;
    
    newXPosition = clampf(newXPosition, 0, self.contentSize.width);
    crosshair.position = CGPointMake(newXPosition, crosshair.position.y);
    
    
    if(time == 0) {
        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        [[CCDirector sharedDirector] replaceScene:recapScene];
    }
    
}

@end
