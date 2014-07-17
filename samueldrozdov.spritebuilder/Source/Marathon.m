//
//  Marathon.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Marathon.h"

#import <CoreMotion/CoreMotion.h>
#import "GameMechanics.h"
#import "Ball.h"
#import "Crosshair.h"
#import "PauseScreen.h"

@implementation Marathon {
    // time variables
    CCLabelTTF *_timeLabel;
    bool start;
    
    // size of the bounding box
    CGSize bbsize;
    
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_instructionLabel;
    CCLabelTTF *_instructionLabel2;
    CCLabelTTF *_instructionScoreLabel;
    CCNode *_background;
    
    Ball *ball;
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
    
    // enable collisions
    _physicsNode.collisionDelegate = self;
    
    [self addBall];
    
    // sets up the timer: method that updates every 0.01 second
    [self schedule:@selector(timer:) interval:0.01f];
    
    // reset shared counters
    [GameMechanics sharedInstance].classicTime = 0;
    [GameMechanics sharedInstance].previousGameMode = @"GameModes/Marathon";
    
    start = false;
    
    _instructionScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).floatValue];
}

-(void)addBall {
    // spawns a ball randomly on the screen
    ball = (Ball*)[CCBReader load:@"Ball"];
    // elasticity is set to one so it does not slow down
    ball.physicsBody.elasticity = 0.9;
    // position the ball randomly in the gameplay scene, makes sure it does not laod with part of the ball of the screen
    ball.position = ccp(arc4random_uniform(bbsize.width - 120) + 60,
                        arc4random_uniform(bbsize.height - 120) + 60);
    // add the ball to the Gameplay scene in the physicsNode
    [_physicsNode addChild:ball];
    
    
    // only for marathon
    ball.score = 6;
    [ball updateScore];
    
    if(start)
        [ball.physicsBody applyImpulse:ccp(arc4random_uniform(100)+20, arc4random_uniform(100)+20)];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ball:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    if(start) {
        ball.score--;
        [ball updateScore];
    }
}

#pragma mark - Touch Events

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _instructionLabel.visible = false;
    _instructionLabel2.visible = false;
    _instructionScoreLabel.visible = false;
    
    if(![GameMechanics sharedInstance].paused && touch.locationInWorld.y > bbsize.height*4/5) {
        [self pause];
    }
    
    if(!start) {
        [ball.physicsBody applyImpulse:ccp(arc4random_uniform(100), arc4random_uniform(100))];
    }
    
    // starts the timer and balls movement;
    start = true;
    
    int ballX = ball.position.x;
    int ballY = ball.position.y;
    int crosshairX = crosshair.position.x;
    int crosshairY = crosshair.position.y;
    float distFromBallCenter = powf(crosshairX - ballX, 2) + powf(crosshairY - ballY, 2);
    // check if the ball contains the crosshair
    if( powf([GameMechanics sharedInstance].ballRadius, 2) >= distFromBallCenter) {
        
        // load particle effect
        CCParticleSystem *hit = (CCParticleSystem *)[CCBReader load:@"HitParticle"];
        // make the particle effect clean itself up, once it is completed
        hit.autoRemoveOnFinish = TRUE;
        // place the particle effect on the ball's position
        hit.position = ball.position;
        // add the particle effect to the same node the ball is on
        [ball.parent addChild:hit z:-1];
        
        if(start) {
            [ball removeFromParent];
            [self addBall];
        }
        
    } else {

    }
}

#pragma mark - Time Updates

// updates that happen every 0.01 second
-(void)timer:(CCTime)delta {
    
    // THIS BELONGS IN UPDATE: just put here to keep things running fast until the labels are updated
    if(![GameMechanics sharedInstance].paused) {
        // accelerometer data to be updated
        CMAccelerometerData *accelerometerData = [GameMechanics
                                                  sharedInstance].motionManager.accelerometerData;
        CMAcceleration acceleration = accelerometerData.acceleration;
        CGFloat newXPosition = crosshair.position.x + acceleration.x * 1500 * delta;
        CGFloat newYPosition = crosshair.position.y + acceleration.y * 1500 * delta;
        
        newXPosition = clampf(newXPosition, 0, bbsize.width);
        newYPosition = 7 + clampf(newYPosition, 0, bbsize.height);
        crosshair.position = CGPointMake(newXPosition, newYPosition);
    }
    
    // if ball reaches 0 the game ends
    if(ball.score == 0) {
        [self endGame];
    }
    
    // updates the time counter
    if(start && ![GameMechanics sharedInstance].paused) {
        [GameMechanics sharedInstance].classicTime += 0.01;
    }
    if(![GameMechanics sharedInstance].paused) {
        [self continueGame];
    }
    
    // this update is making the game slow
    _timeLabel.string = [NSString stringWithFormat:@"%.2lf", [GameMechanics sharedInstance].classicTime];
}

#pragma mark - Pause/Continue

-(void)pause {
    [self pauseGame];
    
    PauseScreen *pausePopover = (PauseScreen *)[CCBReader load:@"PauseScreen"];
    pausePopover.position = ccp(bbsize.width/2, bbsize.width/2);
    pausePopover.zOrder = INT_MAX;
    
    [self addChild:pausePopover];
}

-(void)pauseGame {
    [GameMechanics sharedInstance].paused = true;
    [[GameMechanics sharedInstance].motionManager stopAccelerometerUpdates];
    
    crosshair.paused = true;
    ball.paused = true;
    _physicsNode.paused = true;
}

-(void)continueGame {
    [[GameMechanics sharedInstance].motionManager startAccelerometerUpdates];
    
    crosshair.paused = false;
    ball.paused = false;
    _physicsNode.paused = false;
}

#pragma mark -

-(void)endGame {
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"];
    if(highScore.floatValue < [GameMechanics sharedInstance].classicTime) {
        // new highscore!
        [GameMechanics sharedInstance].highScoreSet = true;
        highScore = [NSNumber numberWithFloat:[GameMechanics sharedInstance].classicTime];
        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"MarathonHighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] replaceScene:recapScene];
}

@end
