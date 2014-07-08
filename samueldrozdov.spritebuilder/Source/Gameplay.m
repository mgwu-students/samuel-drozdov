//
//  Gameplay.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"
#import "Ball.h"
#import <CoreMotion/CoreMotion.h>

@implementation Gameplay {
    
    // important: only create one instance of a motion manager
    CMMotionManager *_motionManager;
    CCLabelTTF *_label;
    
    CCLabelTTF *_timeLabel;
    int time;
    
    Ball *ball;
    
}

- (id)init
{
    if (self = [super init])
    {
        _label= [CCLabelTTF labelWithString:@"X" fontName:@"Arial" fontSize:48];
        [self addChild:_label];
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    _label.position = ccp(self.contentSize.width/2, self.contentSize.height/2);
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
    ball.position = ccp(arc4random_uniform(bbsize.width-70),arc4random_uniform(bbsize.height-70));
    // add the ball to the Gameplay scene
    [self addChild:ball];
    
    time = 900;
}


// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    //
}

// updates that happen in time
- (void)update:(CCTime)delta {
    time -= .1;
    _timeLabel.string = [NSString stringWithFormat:@"%d", time];
    
    if(time == 0) {
        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        [[CCDirector sharedDirector] replaceScene:recapScene];
    }
    
    // accelerometer data to be updated
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = _label.position.x + acceleration.y * 1000 * delta;
    newXPosition = clampf(newXPosition, 0, self.contentSize.width);
    _label.position = CGPointMake(newXPosition, _label.position.y);
}

@end
