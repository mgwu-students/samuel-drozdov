//
//  Insanity.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Insanity.h"
#import <CoreMotion/CoreMotion.h>
#import "GameMechanics.h"
#import "Ball.h"
#import "Crosshair.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation Insanity {
    // time variables
    CCLabelTTF *_timeLabel;
    bool start;
    
    // size of the bounding box
    CGSize bbsize;
    
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_instructionLabel;
    CCNode *_background;
    
    Ball *ball;
    int ballRadius;
    Crosshair *crosshair;
}

- (id)init
{
    if (self = [super init])
    {
        // sets up crosshair along with the accelerometer
        crosshair = (Crosshair*)[CCBReader load:@"Crosshair"];
        [self addChild:crosshair z:10]; // high 'z' value so its visible and over the other nodes
        
        // find the size of the gameplay scene
        bbsize = [[UIScreen mainScreen] bounds].size;
        
        // sets up the timer: method that updates every 1 second
        [self schedule:@selector(timer:) interval:1.0f];
        // sets up the timer: method that updates every 1/2 second
        [self schedule:@selector(colorTimer:) interval:0.5f];
    }
    return self;
}

- (void)onEnter
{
    [super onEnter];
    crosshair.position = ccp(bbsize.width/2, bbsize.height/2);
    [[GameMechanics sharedInstance].motionManager startAccelerometerUpdates];
}
- (void)onExit
{
    [super onExit];
    [[GameMechanics sharedInstance].motionManager stopAccelerometerUpdates];
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // spawns a ball randomly on the screen
    ball = (Ball*)[CCBReader load:@"Ball"];
    // elasticity is set to one so it does not slow down
    ball.physicsBody.elasticity = 1;
    // position the ball randomly in the gameplay scene, makes sure it does not laod with part of the ball of the screen
    ball.position = ccp(arc4random_uniform(bbsize.width - 60) + 30,
                        arc4random_uniform(bbsize.height - 60) + 30);
    // add the ball to the Gameplay scene in the physicsNode
    [_physicsNode addChild:ball];
    
    // reset shared counters
    [GameMechanics sharedInstance].time = 30;
    [GameMechanics sharedInstance].score = 0;
    [GameMechanics sharedInstance].previousGameMode = @"GameModes/Insanity";
    
    ballRadius = 30;
    start = false;
}

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _instructionLabel.visible = false;
    
    int ballX = ball.position.x;
    int ballY = ball.position.y;
    int crosshairX = crosshair.position.x;
    int crosshairY = crosshair.position.y;
    float distFromBallCenter = powf(crosshairX - ballX, 2) + powf(crosshairY - ballY, 2);
    // check if the ball contains the crosshair
    if( powf(ballRadius, 2) >= distFromBallCenter) {
        // starts the timer;
        start = true;
        // gets a positive angle in degrees
        float hitAngle = ((int)RADIANS_TO_DEGREES(atan2f(crosshairY - ballY,
                                                         ballX - crosshairX) + 360)) % 360;
        // hitting the ball further from the center applies more force
        int power = ((int)distFromBallCenter / 100) + 1;
        if(power > 3) power = 3; //power does not exceed 4
        
        // ball moves in direction depending on where it is hit
        int xDirection = 0;
        int yDirection = 0;
        //**this works for now but it should be better and use the angle
        if(hitAngle > 92 && hitAngle < 268) {
            yDirection = -1;
        } else if((hitAngle < 88 && hitAngle > 2) || (hitAngle > 272 && hitAngle < 358)) {
            yDirection = 1;
        }
        if(hitAngle > 182 && hitAngle < 358) {
            xDirection = -1;
        } else if(hitAngle > 2 && hitAngle < 178) {
            xDirection = 1;
        }
        
        [ball.physicsBody applyImpulse:ccp(xDirection * (power * 20 + 50),
                                           yDirection * (power * 20 + 50))];
        
        // increases and updates the score on the ball
        ball.score++;
        [GameMechanics sharedInstance].score++;
        [ball updateScore];
    } else {
        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        [[CCDirector sharedDirector] replaceScene:recapScene];
    }
}

// updates that happen in 1/60th of a frame
-(void)update:(CCTime)delta {
    // accelerometer data to be updated
    CMAccelerometerData *accelerometerData = [GameMechanics
                                              sharedInstance].motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = crosshair.position.x + acceleration.x * 1300 * delta;
    CGFloat newYPosition = crosshair.position.y + acceleration.y * 1300 * delta;
    
    newXPosition = clampf(newXPosition, 0, bbsize.width);
    newYPosition = clampf(newYPosition, 0, bbsize.height);
    crosshair.position = CGPointMake(newXPosition, newYPosition);
    
    // when time runs out the Recap scene is loaded
    if([GameMechanics sharedInstance].time == 0) {
        CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
        [[CCDirector sharedDirector] replaceScene:recapScene];
    } else if([GameMechanics sharedInstance].time <= 5) { // counter turns red when at 5 seconds
        _timeLabel.color = [CCColor redColor];
    }
}

// updates that happen every 1 second
-(void)timer:(CCTime)delta {
    // updates the time counter
    if(start) {
        [GameMechanics sharedInstance].time--;
    }
    
    _timeLabel.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].time];
}

// updates that happen every 1/2 second
-(void)colorTimer:(CCTime)delta {
    
    _background.color = [CCColor colorWithRed:(random()%100)/(float)100 green:(random()%100)/(float)100 blue:(random()%100)/(float)100 alpha:1];
    ball.color = [CCColor colorWithRed:(random()%100)/(float)100 green:(random()%100)/(float)100 blue:(random()%100)/(float)100 alpha:1];
}

@end
