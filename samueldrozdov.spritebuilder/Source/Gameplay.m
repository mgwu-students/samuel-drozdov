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
    
    CCNode* ball;
    
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
    
    time = 900;
    
    // loads the Ball.ccb we have set up in Spritebuilder
    ball = [CCBReader load:@"Ball"];
    // position the Ball in the screen
    CGSize bbsize = [[UIScreen mainScreen] bounds].size;
    NSLog(@"%f %f",bbsize.width*2,bbsize.height*2);
    ball.position = ccp((bbsize.width * 2 * arc4random()),(bbsize.height * 2 * arc4random()));
    // add the Ball to the Gameplay scene
    [self addChild:ball];
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
