//
//  Marathon.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Marathon.h"

@implementation Marathon {
    // time variables
    CCLabelTTF *_timeLabel;
    bool start;
    
    // size of the bounding box
    CGSize bbsize;
    float power;
    
    CCPhysicsNode *_physicsNode;
    CCNode *_inGame;
    CCNode *_instructions;
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
        
        // sets up the timer: method that updates every 0.01 second
        [self schedule:@selector(timer:) interval:0.01f];
        power = 0;
        
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
    [[GameMechanics sharedInstance] checkMedals];
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    // enable collisions
    _physicsNode.collisionDelegate = self;
    
    _inGame.visible = false;
    [self addBall];
    
    // reset shared counters
    [GameMechanics sharedInstance].classicTime = 0;
    [GameMechanics sharedInstance].previousGameMode = @"GameModes/Marathon";
    
    start = false;
    
    _instructionScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).floatValue];
}

-(void)calibrate {
    crosshair.position = ccp(bbsize.width/2, bbsize.height/2);
    [GameMechanics sharedInstance].calibration = -[GameMechanics sharedInstance].motionManager.accelerometerData.acceleration.y;
}

-(void)addBall {
    // spawns a ball randomly on the screen
    ball = (Ball*)[CCBReader load:@"Ball"];
    // elasticity is set to one so it does not slow down
    ball.physicsBody.elasticity = 0.9;
    // position the ball randomly in the gameplay scene, makes sure it does not laod with part of the ball of the screen
    ball.position = ccp(bbsize.width/2, bbsize.height/2);
    // add the ball to the Gameplay scene in the physicsNode
    [_physicsNode addChild:ball];
    
    ball.score = 0;
    [ball updateScore];
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ball:(CCNode *)nodeA wildcard:(CCNode *)nodeB {
    if(start) {
        [self endGame];
    }
    
    
}

#pragma mark - Touch Events

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _instructions.visible = false;
    _inGame.visible = true;
    
    if(![GameMechanics sharedInstance].paused && touch.locationInWorld.y > bbsize.height*4/5 && _instructions.visible == false) {
        [self pause];
    }
    /*
    if(!start) {
        [ball.physicsBody applyImpulse:ccp(arc4random_uniform(100), arc4random_uniform(100))];
    }
     */
    
    // starts the timer and balls movement;
    start = true;
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
        
        [ball.physicsBody applyForce:ccp((ballX-crosshairX)*power,(ballY-crosshairY)*power)];
        ball.score++;
        [ball updateScore];
        power += 0.5;
    }
    else {
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

// updates that happen every 0.01 second
-(void)timer:(CCTime)delta {
    
    // THIS BELONGS IN UPDATE: just put here to keep things running fast until the labels are updated
    if(![GameMechanics sharedInstance].paused) {
        // accelerometer data to be updated
        CMAccelerometerData *accelerometerData = [GameMechanics
                                                  sharedInstance].motionManager.accelerometerData;
        CMAcceleration acceleration = accelerometerData.acceleration;
        CGFloat newXPosition = crosshair.position.x + acceleration.x * 1500 * delta;
        CGFloat newYPosition = crosshair.position.y + (acceleration.y+[GameMechanics sharedInstance].calibration) * 1500 * delta;
        
        newXPosition = clampf(newXPosition, 0, bbsize.width);
        newYPosition = clampf(newYPosition, 0, bbsize.height);
        crosshair.position = CGPointMake(newXPosition, newYPosition);
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
    
    self.userInteractionEnabled = FALSE;
    crosshair.paused = true;
    ball.paused = true;
    _physicsNode.paused = true;
}

-(void)continueGame {
    [[GameMechanics sharedInstance].motionManager startAccelerometerUpdates];
    
    self.userInteractionEnabled = TRUE;
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
