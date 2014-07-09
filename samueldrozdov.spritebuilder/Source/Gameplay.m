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
    
    // size of the bounding box
    CGSize bbsize;
    
    CCPhysicsNode *_physicsNode;
    CCNode *_background;
    
    Ball *ball;
    int ballRadius;
    Crosshair *crosshair;
}

- (id)init
{
    if (self = [super init])
    {
        crosshair = (Crosshair*)[CCBReader load:@"Crosshair"];
        [self addChild:crosshair z:10]; // high 'z' value so its visible and over the other nodes
        _motionManager = [[CMMotionManager alloc] init];
        
        // find the size of the gameplay scene
        bbsize = [[UIScreen mainScreen] bounds].size;
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    crosshair.position = ccp(bbsize.width/2, bbsize.height/2);
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
    // position the ball randomly in the gameplay scene
    ball.position = ccp(arc4random_uniform(bbsize.width - 60),arc4random_uniform(bbsize.height - 60));
    // add the ball to the Gameplay scene in the physicsNode
    [_physicsNode addChild:ball];
    
    [ball.physicsBody applyForce:ccp(12000,12000)];
    
    
    ballRadius = 30;
    time = 900;
}


// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    
    // outcomes if the crosshair overlaps the ball when the scene is touched
    if(CGRectContainsPoint(ball.boundingBox, crosshair.position)) {
        int d1 = -1;//pos or neg for a random direction. make better
        int d2 = 1;
        [ball.physicsBody applyForce:ccp(12000*d1,12000*d2)];
        
        ball.score++;
        [ball updateScore];
        
    } else {
        // background turns red for a moment when the ball is not clicked
        CCColor *origColor = _background.color;
        _background.color = [CCColor redColor];
        _background.color = origColor;
    }
}

// call at the end of every touch
-(void) touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //
}

// updates that happen in time
- (void)update:(CCTime)delta {
    
    // updates the time counter
    time -= .01;
    _timeLabel.string = [NSString stringWithFormat:@"%d", time];
    
    
    // accelerometer data to be updated
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = crosshair.position.x + acceleration.x * 1000 * delta;
    CGFloat newYPosition = crosshair.position.y + acceleration.y * 1000 * delta;
    
    newXPosition = clampf(newXPosition, 0, bbsize.width);
    newYPosition = clampf(newYPosition, 0, bbsize.height);
    crosshair.position = CGPointMake(newXPosition, newYPosition);
    
    
    // when time runs out the Recap scene is loaded
    if(time == 0) {
        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        [[CCDirector sharedDirector] replaceScene:recapScene];
    }
    
}

@end
