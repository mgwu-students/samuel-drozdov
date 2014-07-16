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
        
        // sets up the timer: method that updates every 1 second
        [self schedule:@selector(timer:) interval:1.0f];
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
    ball.physicsBody.elasticity = 0.9;
    // position the ball randomly in the gameplay scene, makes sure it does not laod with part of the ball of the screen
    ball.position = ccp(arc4random_uniform(bbsize.width - 60) + 30,
                        arc4random_uniform(bbsize.height - 60) + 30);
    // add the ball to the Gameplay scene in the physicsNode
    [_physicsNode addChild:ball];
    
    // reset shared counters
    [GameMechanics sharedInstance].time = 0;
    [GameMechanics sharedInstance].score = 0;
    [GameMechanics sharedInstance].previousGameMode = @"GameModes/Marathon";
    
    start = false;
    
    _instructionScoreLabel.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).intValue];
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
    
    int ballX = ball.position.x;
    int ballY = ball.position.y;
    int crosshairX = crosshair.position.x;
    int crosshairY = crosshair.position.y;
    float distFromBallCenter = powf(crosshairX - ballX, 2) + powf(crosshairY - ballY, 2);
    // check if the ball contains the crosshair
    if( powf([GameMechanics sharedInstance].ballRadius, 2) >= distFromBallCenter) {
        // starts the timer;
        start = true;
        
        // load particle effect
        CCParticleSystem *hit = (CCParticleSystem *)[CCBReader load:@"HitParticle"];
        // make the particle effect clean itself up, once it is completed
        hit.autoRemoveOnFinish = TRUE;
        // place the particle effect on the ball's position
        hit.position = ball.position;
        // add the particle effect to the same node the ball is on
        [ball.parent addChild:hit z:-1];

        // hitting the ball further from the center applies more force
        int power = ((int)distFromBallCenter / 100) + 5;
        if(power > 9) power = 9; //power does not exceed 9
        [ball.physicsBody applyImpulse:ccp((ballX-crosshairX)*(power+1),(ballY-crosshairY)*(power+1))];
        
        // increases and updates the score on the ball
        ball.score++;
        [GameMechanics sharedInstance].score++;
        [ball updateScore];
    } else {
        if(![GameMechanics sharedInstance].paused)
            [self endGame];
    }
}

#pragma mark - Time Updates

// updates that happen in 1/60th of a frame
-(void)update:(CCTime)delta {
    if(![GameMechanics sharedInstance].paused) {
        // accelerometer data to be updated
        CMAccelerometerData *accelerometerData = [GameMechanics
                                              sharedInstance].motionManager.accelerometerData;
        CMAcceleration acceleration = accelerometerData.acceleration;
        CGFloat newXPosition = crosshair.position.x + acceleration.x * 1500 * delta;
        CGFloat newYPosition = crosshair.position.y + acceleration.y * 1500 * delta;
    
        newXPosition = clampf(newXPosition, 0, bbsize.width);
        newYPosition = 9 + clampf(newYPosition, 0, bbsize.height);
        crosshair.position = CGPointMake(newXPosition, newYPosition);
    }
    
    if(![GameMechanics sharedInstance].paused) {
        [self continueGame];
    }
}

// updates that happen every 1 second
-(void)timer:(CCTime)delta {

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
    if(highScore.intValue < [GameMechanics sharedInstance].score) {
        // new highscore!
        [GameMechanics sharedInstance].highScoreSet = true;
        highScore = [NSNumber numberWithInt:(int)[GameMechanics sharedInstance].score];
        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"MarathonHighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] replaceScene:recapScene];
}

@end
