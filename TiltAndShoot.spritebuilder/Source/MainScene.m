//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@implementation MainScene {
    CCNode *_instructions;
    CCNode *_ball;
    CCNode *_crosshair;
    CCSprite *_pointer;
    CCLabelTTF *_scoreLabel;
    CCPhysicsNode *_physicsNode;
    
    CCNode *_calibrateButton;
    CCLabelTTF *_arrowLabel;
    CCLabelTTF *_clickShootLabel;
    CCLabelTTF *_keepShootingLabel;
    CCLabelTTF *_dontHitWallsLabel;
    CCLabelTTF *_holdLabel;
    
    CMMotionManager *_motionManager;
    CGSize bbSize;
    float ballRadius;
    int score;
    int power;
    bool firstHit;
    
    CCNodeColor *_timerCover;
    CCNodeColor *_background;
    
    CCNodeGradient *_colorMarketNode;
    CCColor *color1;
    CCColor *color2;
    CCColor *color3;
    CCColor *color4;
    CCColor *color5;
}

- (void)onEnter {
    [super onEnter];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"Start"];
    [_motionManager startAccelerometerUpdates];
}
- (void)onExit {
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    // enable collisions
    _physicsNode.collisionDelegate = self;
    
    color1 = [CCColor colorWithRed:0.302 green:0.427 blue:0.835];
    color2 = [CCColor colorWithRed:0.251 green:0.898 blue:0.251];
    color3 = [CCColor colorWithRed:1.0 green:0.776 blue:0.278];
    color4 = [CCColor colorWithRed:1.0 green:0.278 blue:0.278];
    color5 = [CCColor colorWithRed:0.227 green:0.773 blue:0.796];
    
    _background.color = [self checkForBackgroundColor];
    _timerCover.color = [self checkForBackgroundColor];
    
    // find the size of the gameplay scene
    bbSize = [[UIScreen mainScreen] bounds].size;
    
    _motionManager = [[CMMotionManager alloc] init];
    _scoreLabel.visible = false;
    firstHit = false;
    ballRadius = 35.5;
    score = 0;
    power = 50;
    
    // only called the first time playing the game
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"firstTimePlaying"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"firstTimePlaying"];
        _background.color = color1;
        _timerCover.color = color1;
        _crosshair.color = [CCColor whiteColor];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"crosshairColor"];
    }
    
    // if restart is clicked the game skips the menu screen
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Start"] integerValue]) {
        _instructions.visible = false;
        _scoreLabel.visible = true;
        _keepShootingLabel.visible = true;
    }
}

-(CCColor *)checkForBackgroundColor{
    int x = [[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"] intValue];
    CCColor *color;
    if(x == 1) {
        color = color1;
    } else if(x == 2) {
        color = color2;
    } else if(x == 3) {
        color = color3;
    } else if(x == 4) {
        color = color4;
    } else if(x == 5) {
        color = color5;
    } else {
        color = color1;
    }
    return color;
}

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touches = [touch locationInWorld];
    if(touches.y >= bbSize.height*0.9) {
        CCScene *colorMarket = [CCBReader loadAsScene:@"ColorMarket"];
        [[CCDirector sharedDirector] replaceScene:colorMarket withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.3f]];
    }
    
    int ballX = _ball.positionInPoints.x;
    int ballY = _ball.positionInPoints.y;
    int crosshairX = _crosshair.position.x;
    int crosshairY = _crosshair.position.y;
    int crosshairDistToBall = sqrtf(powf(crosshairX - ballX, 2) + powf(crosshairY - ballY, 2));
    // check if the ball contains the crosshair
    if(ballRadius >= crosshairDistToBall) {
        _instructions.visible = false;
        _scoreLabel.visible = true;
        _keepShootingLabel.visible = true;
        _colorMarketNode.visible = false;
        firstHit = true;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Start"];
        // increase the score and update the labels
        score++;
        _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
        if(score >= 5) {
            _keepShootingLabel.visible = false;
            _dontHitWallsLabel.visible = true;
        }
        if(score >= 15) {
            _dontHitWallsLabel.visible = false;
        }
        
        // hitting the ball further from the center applies some more force
        [_ball.physicsBody applyForce:ccp((ballX-crosshairX)*power,(ballY-crosshairY)*power)];
        power += 5;
        
        // add time to timerCover's positon
        if(_timerCover.position.y < 85)
            _timerCover.position = ccp(_timerCover.position.x, _timerCover.position.y + 15);
        
        // load particle effect
        CCParticleSystem *hit = (CCParticleSystem *)[CCBReader load:@"HitParticle"];
        // make the particle effect clean itself up, once it is completed
        hit.autoRemoveOnFinish = TRUE;
        // place the particle effect on the ball's position
        hit.position = _ball.positionInPoints;
        [_ball.parent addChild:hit z:-1];
    } else {
        // load particle effect
        CCParticleSystem *missed = (CCParticleSystem *)[CCBReader load:@"ShootParticle"];
        // make the particle effect clean itself up, once it is completed
        missed.autoRemoveOnFinish = TRUE;
        // place the particle effect on the crosshair's position
        missed.position = _crosshair.position;
        [self addChild:missed z:0];
    }
}

// updates that happen every 1/60th second
-(void)update:(CCTime)delta {
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = _crosshair.position.x + (acceleration.x + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationX"] floatValue]) * 1500 * delta;
    CGFloat newYPosition = _crosshair.position.y + (acceleration.y + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationY"] floatValue]) * 1500 * delta;
    
    newXPosition = clampf(newXPosition, 0, bbSize.width);
    newYPosition = clampf(newYPosition, 0, bbSize.height);
    _crosshair.position = CGPointMake(newXPosition, newYPosition);
    
    // score label color changes
    if(score >= 50) {
        _scoreLabel.color = [CCColor blueColor];
    }
    if(score >= 100) {
        _scoreLabel.color = [CCColor orangeColor];
    }
    if(score >= 150) {
        _scoreLabel.color = [CCColor yellowColor];
    }
    if(score >= 200) {
        _scoreLabel.color = [CCColor redColor];
    }
    if(score >= 250 ) {
        _scoreLabel.color = [CCColor purpleColor];
    }
    if(score >= 300) {
        _scoreLabel.color = [CCColor magentaColor];
    }
    
    // finds the angle of the crosshair to the ball and moves the pointer accordingly
    float angle = ccpAngle(ccp(0,1),ccpSub(_crosshair.position, _ball.positionInPoints));
    float angleDegrees = 180*angle/M_PI;
    if(_crosshair.position.x < _ball.positionInPoints.x) {
        
        angleDegrees *= -1;
    }
    _pointer.rotation = angleDegrees - 180;
    
    // timer only starts after the game starts
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Start"] integerValue]) {
        _timerCover.position = ccp(_timerCover.position.x, _timerCover.position.y - 0.2 );
        if(_timerCover.position.y <= 10){
            [MGWU logEvent:@"LostByTime" withParams:nil];
            [self endGame];
        }
    }
}

-(void)calibrate {
    [MGWU logEvent:@"Calibrated" withParams:nil];
    
    _crosshair.position = ccp(bbSize.width/2, bbSize.height/2);
    float calibrationX = -_motionManager.accelerometerData.acceleration.x;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:calibrationX] forKey:@"calibrationX"];
    float calibrationY = -_motionManager.accelerometerData.acceleration.y;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:calibrationY] forKey:@"calibrationY"];
    _calibrateButton.visible = false;
    _holdLabel.visible = false;
    _clickShootLabel.visible = true;
    _arrowLabel.visible = true;
    _colorMarketNode.visible = false;
}

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ball:(CCNode *)nodeA wall:(CCNode *)nodeB {
    [self endGame];
}

-(void)endGame {
    int overallScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OverallScore"] intValue];
    overallScore += score;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:overallScore] forKey:@"OverallScore"];
    
    NSNumber *playCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:playCount.intValue+1] forKey:@"PlayCount"];
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"];
    NSNumber *prevScore = [NSNumber numberWithInt:score];
    if(prevScore.intValue > highScore.intValue) {
        // new highscore
        highScore = prevScore;
        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"HighScore"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:prevScore forKey:@"PreviousScore"];
    
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: playCount, @"PlayCount", prevScore, @"PreviousScore", nil];//
    
    [MGWU logEvent:@"EndGame" withParams:params];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // change scenes
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] replaceScene:recapScene];
}

@end
