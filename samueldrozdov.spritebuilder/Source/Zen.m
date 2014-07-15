//
//  Zen.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Zen.h"

#import "Classic.h"
#import <CoreMotion/CoreMotion.h>
#import "GameMechanics.h"
#import "Ball.h"
#import "Crosshair.h"

@implementation Zen {
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
    
    // reset shared counters
    [GameMechanics sharedInstance].time = 30;
    [GameMechanics sharedInstance].score = 0;
    [GameMechanics sharedInstance].previousGameMode = @"GameModes/Zen";
    
    ballRadius = 30;
    start = false;
    
    _instructionScoreLabel.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ZenHighScore"]).intValue];
}

#pragma mark - Touch Updates

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    _instructionLabel.visible = false;
    _instructionLabel2.visible = false;
    _instructionScoreLabel.visible = false;
    
    int ballX = ball.position.x;
    int ballY = ball.position.y;
    int crosshairX = crosshair.position.x;
    int crosshairY = crosshair.position.y;
    float distFromBallCenter = powf(crosshairX - ballX, 2) + powf(crosshairY - ballY, 2);
    // check if the ball contains the crosshair
    if( powf(ballRadius, 2) >= distFromBallCenter) {
        // starts the timer;
        start = true;
        
        // load particle effect
        CCParticleSystem *hit = (CCParticleSystem *)[CCBReader load:@"Hit"];
        // make the particle effect clean itself up, once it is completed
        hit.autoRemoveOnFinish = TRUE;
        // place the particle effect on the balls position
        hit.position = ball.position;
        // add the particle effect to the same node the ball is on
        [ball.parent addChild:hit z:-1];

        // hitting the ball further from the center applies more force
        int power = ((int)distFromBallCenter / 100) + 5;
        if((int)distFromBallCenter / 100 <= 4) power = 4;
        else if(power > 9) power = 9; //power does not exceed 9
        
        [ball.physicsBody applyImpulse:ccp((ballX-crosshairX)*power,(ballY-crosshairY)*power)];
        
        // increases and updates the score
        ball.score++;
        [GameMechanics sharedInstance].score++;
        [ball updateScore];
    } else {
        
    }
}

#pragma mark - Time Updates

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
        [self endGame];
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
    
    _timeLabel.string = [NSString stringWithFormat:@"%ld", (long)[GameMechanics sharedInstance].time];
}

-(void)endGame {
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZenHighScore"];
    if(highScore.intValue < [GameMechanics sharedInstance].score) {
        // new highscore!
        [GameMechanics sharedInstance].highScoreSet = true;
        highScore = [NSNumber numberWithInt:(int)[GameMechanics sharedInstance].score];
        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"ZenHighScore"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] replaceScene:recapScene];
}

@end
