//
//  Classic.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Classic.h"

#import <CoreMotion/CoreMotion.h>
#import "GameMechanics.h"
#import "Ball.h"
#import "Crosshair.h"
#import "PauseScreen.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

@implementation Classic {
    // time variables
    CCLabelTTF *_timeLabel;
    bool start;
    bool paused;
    
    // size of the bounding box
    CGSize bbsize;
    
    CCPhysicsNode *_physicsNode;
    CCLabelTTF *_instructionLabel;
    CCLabelTTF *_instructionLabel2;
    CCLabelTTF *_instructionScoreLabel;
    CCNode *_background;
    
    float calibration;
    
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
        
        // sets up the timer: method that updates every 0.01 second
        [self schedule:@selector(timer:) interval:0.01f];
        
        calibration = 0;
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
    // position the ball randomly in the gameplay scene, makes sure it does not laod with part of the ball of the screen
    ball.position = ccp(arc4random_uniform(bbsize.width - 60) + 30,
                        arc4random_uniform(bbsize.height - 60) + 30);
    // add the ball to the Gameplay scene in the physicsNode
    [_physicsNode addChild:ball];
    
    start = false;
    paused = false;
    
    // reset shared counters
    [GameMechanics sharedInstance].classicTime = 0;
    [GameMechanics sharedInstance].score = 10;
    [GameMechanics sharedInstance].previousGameMode = @"GameModes/Classic";
    
    ball.score = 10;
    [ball updateScore];
    _timeLabel.string = [NSString stringWithFormat:@"%.2lf", [GameMechanics sharedInstance].classicTime];
    
    _instructionScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
}

#pragma mark - Touch Updates

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _instructionLabel.visible = false;
    _instructionLabel2.visible = false;
    _instructionScoreLabel.visible = false;
    
    if(!paused && touch.locationInWorld.y > bbsize.height*2/3) {
        [self pause];
    }
    
    
    int ballX = ball.position.x;
    int ballY = ball.position.y;
    int crosshairX = crosshair.position.x;
    int crosshairY = crosshair.position.y;
    float distFromBallCenter = powf(crosshairX - ballX, 2) + powf(crosshairY - ballY, 2);
    // check if the ball contains the crosshair
    if(powf([GameMechanics sharedInstance].ballRadius, 2) >= distFromBallCenter) {
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
        if((int)distFromBallCenter / 100 <= 4) power = 4;
        else if(power > 9) power = 9; //power does not exceed 9
        [ball.physicsBody applyImpulse:ccp((ballX-crosshairX)*power,(ballY-crosshairY)*power)];
        
        // decrease and updates the score on the ball
        ball.score--;
        [GameMechanics sharedInstance].score--;
        [ball updateScore];
    } else {
        // load particle effect
        CCParticleSystem *missed = (CCParticleSystem *)[CCBReader load:@"ShootParticle"];
        // make the particle effect clean itself up, once it is completed
        missed.autoRemoveOnFinish = TRUE;
        // place the particle effect on the crosshair's position
        missed.position = crosshair.position;
        // add the particle effect to the same node the crosshair is on
        [crosshair.parent addChild:missed z:1];
    }
}

#pragma mark - Time Updates

// updates that happen in 1/60th of a frame
-(void)update:(CCTime)delta {
    // when score gets to 0 the round ends
    if(ball.score == 0) {
        [self endGame];
    }
}

// updates that happen every 0.01 second
-(void)timer:(CCTime)delta {
    if(!paused) {
        // accelerometer data to be updated
        CMAccelerometerData *accelerometerData = [GameMechanics
                                              sharedInstance].motionManager.accelerometerData;
        CMAcceleration acceleration = accelerometerData.acceleration;
        CGFloat newXPosition = crosshair.position.x + acceleration.x * 1500 * delta;
        CGFloat newYPosition = crosshair.position.y + acceleration.y * 1500 * delta;
    
        newXPosition = clampf(newXPosition, 0, bbsize.width);
        newYPosition = 8 + clampf(newYPosition, 0, bbsize.height);
        crosshair.position = CGPointMake(newXPosition, newYPosition);
    }
    
    // updates the time counter
    if(start) {
        [GameMechanics sharedInstance].classicTime += 0.01;
    }
    
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
    paused = true;
    [[GameMechanics sharedInstance].motionManager stopAccelerometerUpdates];
    
    crosshair.paused = true;
    ball.paused = true;
    
    // for Classic
    start = false;
}

-(void)continueGame {
    paused = false;
    [[GameMechanics sharedInstance].motionManager startAccelerometerUpdates];
    
    crosshair.paused = false;
    ball.paused = false;
    
    // for Classic
    start = true;
}

#pragma mark -

-(void)endGame {
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"];
    if(highScore.floatValue > [GameMechanics sharedInstance].classicTime) {
        // new highscore!
        [GameMechanics sharedInstance].highScoreSet = true;
        highScore = [NSNumber numberWithFloat:[GameMechanics sharedInstance].classicTime];
        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"ClassicHighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] replaceScene:recapScene];
}


@end
