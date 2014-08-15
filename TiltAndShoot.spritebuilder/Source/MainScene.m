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
#import "Star.h"

#define gkLeaderboard @"TASLeaderboard"

@implementation MainScene {
    CCNode *_instructions;
    CCNode *_ball;
    CCSprite *_crosshair;
    CCSprite *_pointer;
    CCLabelTTF *_scoreLabel;
    CCPhysicsNode *_physicsNode;
    
    CCNodeColor *_stupidScoreCover;
    CCNodeColor *_stupidShopCover;
    CCNode *_calibrateButton;
    CCLabelTTF *_arrowLabel;
    CCLabelTTF *_clickShootLabel;
    CCLabelTTF *_keepShootingLabel;
    CCLabelTTF *_dontHitWallsLabel;
    CCNode *_holdLabel;
    
    CMMotionManager *_motionManager;
    CGSize bbSize;
    float ballRadius;
    int score;
    int power;
    bool firstHit;
    bool start;
    CCLabelTTF *_startLabel;
    bool starActive;
    
    CCSprite *_endGameButton;
    CCNodeColor *_stupidEndCover;
    
    CCNodeColor *_timerCover;
    CCNodeColor *_background;
    CCLabelTTF *_points;
    
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
    // plays an animation if openning the game
    if([[NSUserDefaults standardUserDefaults] integerForKey:@"LoadedScene"] == 1) {
        CCAnimationManager *animationManager = self.animationManager;
        [animationManager runAnimationsForSequenceNamed:@"Animated Timeline"];
        
        [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"LoadedScene"];
    }
    
    // only called the first time playing the game
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"firstTimePlaying"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"Player" forKey:@"UserName"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SelectedCrosshair"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"backgroundColor"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"firstTimePlaying"];
    }
    
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
    _startLabel.color = [self checkForBackgroundColor];
    _stupidScoreCover.color = [self checkForBackgroundColor];
    _stupidShopCover.color = [self checkForBackgroundColor];
    _stupidEndCover.color = [self checkForBackgroundColor];
    [self crosshairSelect];
    
    int stars = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue];
    _points.string = [NSString stringWithFormat:@"%d",stars];
    
    // find the size of the gameplay scene
    bbSize = [[UIScreen mainScreen] bounds].size;
    
    _motionManager = [[CMMotionManager alloc] init];
    _scoreLabel.visible = false;
    firstHit = false;
    start = false;
    starActive = false;
    ballRadius = 35.5;
    score = 0;
    power = 50;
    
    // if restart is clicked the game skips the menu screen
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Start"] integerValue]) {
        _instructions.visible = false;
        _scoreLabel.visible = true;
        _keepShootingLabel.visible = true;
        _colorMarketNode.visible = false;
        _endGameButton.visible = true;
        start = true;
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

-(void)crosshairSelect {
    int crosshairSelection = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedCrosshair"] intValue];
    if(crosshairSelection == 1) {
        [_crosshair setTexture:[[CCSprite spriteWithImageNamed:@"Assets/Sights/sight1.png"]texture]];
    } else if(crosshairSelection == 2) {
        [_crosshair setTexture:[[CCSprite spriteWithImageNamed:@"Assets/Sights/sight2.png"]texture]];
    } else if(crosshairSelection == 3) {
        [_crosshair setTexture:[[CCSprite spriteWithImageNamed:@"Assets/Sights/sight3.png"]texture]];
    } else if(crosshairSelection == 4) {
        [_crosshair setTexture:[[CCSprite spriteWithImageNamed:@"Assets/Sights/sight4.png"]texture]];
    } else if(crosshairSelection == 5) {
        [_crosshair setTexture:[[CCSprite spriteWithImageNamed:@"Assets/Sights/sight5.png"]texture]];
    }
}



#pragma mark - Game Mechancis

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CCActionFiniteTime *shrink = [CCActionScaleTo actionWithDuration:0.1 scale:0.9f];
    CCActionFiniteTime *grow = [CCActionScaleTo actionWithDuration:0.1 scale:1.0f];
    CCActionSequence *action = [CCActionSequence actions:shrink, grow, nil];
    [_crosshair runAction:action];
    
    int ballX = _ball.positionInPoints.x;
    int ballY = _ball.positionInPoints.y;
    int crosshairX = _crosshair.positionInPoints.x;
    int crosshairY = _crosshair.positionInPoints.y;
    int crosshairDistToBall = sqrtf(powf(crosshairX - ballX, 2) + powf(crosshairY - ballY, 2));
    // check if the ball contains the crosshair
    if(start && ballRadius >= crosshairDistToBall) {
        
        _instructions.visible = false;
        _scoreLabel.visible = true;
        _keepShootingLabel.visible = true;
        _colorMarketNode.visible = false;
        _points.visible = false;
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
        
        // polish to the score label
        CCActionFiniteTime *grow = [CCActionScaleTo actionWithDuration:0.3 scale:1.15f];
        CCActionFiniteTime *shrink = [CCActionScaleTo actionWithDuration:0.2 scale:1.0f];
        CCActionSequence *action = [CCActionSequence actions:grow, shrink, nil];
        if(score % 50 == 0) {
            [_scoreLabel runAction:action];
        }
        
        // load particle effect
        CCParticleSystem *hit = (CCParticleSystem *)[CCBReader load:@"HitParticle"];
        // make the particle effect clean itself up, once it is completed
        hit.autoRemoveOnFinish = TRUE;
        // place the particle effect on the ball's position
        hit.position = _ball.positionInPoints;
        [_ball.parent addChild:hit z:-1];
    } else {
        /*
        // load particle effect
        CCParticleSystem *missed = (CCParticleSystem *)[CCBReader load:@"ShootParticle"];
        // make the particle effect clean itself up, once it is completed
        missed.autoRemoveOnFinish = TRUE;
        // place the particle effect on the crosshair's position
        missed.position = _crosshair.positionInPoints;
        [_crosshair addChild:missed z:0];
         */
    }
    
    if(score >= 15 && score % 5 == 0 && !starActive) {
        starActive = true;
        Star *star = (Star *)[CCBReader load:@"Star"];
        star.position = ccp((arc4random_uniform(bbSize.width*0.7)+bbSize.width*0.15),(arc4random_uniform(bbSize.height*0.7)+bbSize.height*0.15));
        [_physicsNode addChild:star];
    }
}

// updates that happen every 1/60th second
-(void)update:(CCTime)delta {
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    CGFloat newXPosition = _crosshair.position.x + (acceleration.x + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationX"] floatValue]) * 1500 * delta;
    CGFloat newYPosition = _crosshair.position.y + (acceleration.y + [[[NSUserDefaults standardUserDefaults] objectForKey:@"calibrationY"] floatValue]) * 1500 * delta;
    
    //Keep the crosshair within the raidus of the ball
    newXPosition = clampf(newXPosition, _ball.positionInPoints.x - 30, _ball.positionInPoints.x + 30);
    newYPosition = clampf(newYPosition, _ball.positionInPoints.y - 30, _ball.positionInPoints.y + 30);
    CGPoint cross1 = CGPointMake(newXPosition, newYPosition);
    CGPoint distV = ccpNormalize(ccpSub(cross1,_ball.positionInPoints));

    float dist1 = ccpLength(ccpSub(cross1, _ball.positionInPoints));
    float dist2 = ccpLength(ccpMult(distV, 30));
    
    if(dist2 < dist1) {
        _crosshair.positionInPoints = ccpAdd(_ball.positionInPoints, ccpMult(distV, 30));
    } else {
        newXPosition = clampf(newXPosition, _ball.positionInPoints.x - 30, _ball.positionInPoints.x + 30);
        newYPosition = clampf(newYPosition, _ball.positionInPoints.y - 30, _ball.positionInPoints.y + 30);
        _crosshair.positionInPoints = CGPointMake(newXPosition, newYPosition);
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
        if(_timerCover.position.y <= 10) {
            [MGWU logEvent:@"LostByTime" withParams:nil];
            [self endGame];
        }
    }
}

-(void)endGame {
    [[GameKitHelper sharedGameKitHelper] submitScore:score  category:gkLeaderboard];
    
    NSNumber *playCount = [[NSUserDefaults standardUserDefaults] objectForKey:@"PlayCount"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:playCount.intValue+1] forKey:@"PlayCount"];
    [MGWU submitHighScore:score byPlayer:[[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"] forLeaderboard:@"defaultLeaderboard"];
    
    NSNumber *highScore = [[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"];
    NSNumber *prevScore = [NSNumber numberWithInt:score];
    if(prevScore.intValue > highScore.intValue) {
        // new highscore
        highScore = prevScore;
        [[NSUserDefaults standardUserDefaults] setObject:highScore forKey:@"HighScore"];
    }
    [[NSUserDefaults standardUserDefaults] setObject:prevScore forKey:@"PreviousScore"];
    
    //Analytics
    NSDictionary *params = [[NSDictionary alloc] initWithObjectsAndKeys: playCount, @"PlayCount", prevScore, @"PreviousScore", nil];
    [MGWU logEvent:@"EndGame" withParams:params];
    
    [[NSUserDefaults standardUserDefaults] synchronize]; //idk what this does
    
    _endGameButton.visible = false;
    // change scenes
    CCScene *recapScene = [CCBReader loadAsScene:@"Recap"];
    [[CCDirector sharedDirector] replaceScene:recapScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.3f]];
}

#pragma mark - Physics

- (void)ccPhysicsCollisionPostSolve:(CCPhysicsCollisionPair *)pair ball:(CCNode *)nodeA wall:(CCNode *)nodeB {
    [self endGame];
}

- (BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair ball:(CCNode *)nodeA star:(CCNode *)nodeB {
    starActive = false;
    [nodeB removeFromParent];
    
    int stars = [[[NSUserDefaults standardUserDefaults]  objectForKey:@"Stars"] integerValue];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:stars+1] forKey:@"Stars"];
    
    CCLabelTTF *plus = [[CCLabelTTF alloc] initWithString:@"+1" fontName:@"Futura-Medium" fontSize:25];
    plus.positionInPoints = nodeB.positionInPoints;
    [self addChild:plus];

    CCActionFiniteTime *fade = [CCActionFadeTo actionWithDuration:0.5 opacity:0.0];
    CCActionFiniteTime *slide = [CCActionMoveTo actionWithDuration:0.5 position:ccp(plus.positionInPoints.x,plus.positionInPoints.y+15)];
    CCActionSequence *action = [CCActionSequence actions:slide, fade, [CCActionRemove action], nil];
    [plus runAction:action];
    
    return false;
}

#pragma mark - Buttons

//start button
-(void)calibrate {
    [MGWU logEvent:@"Calibrated" withParams:nil];
    
    start = true;
    _crosshair.position = ccp(bbSize.width/2, bbSize.height/2);
    [self.animationManager runAnimationsForSequenceNamed:@"StartGame Timeline"];
    float calibrationX = -_motionManager.accelerometerData.acceleration.x;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:calibrationX] forKey:@"calibrationX"];
    float calibrationY = -_motionManager.accelerometerData.acceleration.y;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithFloat:calibrationY] forKey:@"calibrationY"];
    _calibrateButton.visible = false;
    _holdLabel.visible = false;
    _clickShootLabel.visible = true;
    _arrowLabel.visible = true;
    _endGameButton.visible = true;
}

-(void)shop {
    [MGWU logEvent:@"ThemeCustomizationMenu" withParams:nil];
    CCScene *colorMarket = [CCBReader loadAsScene:@"ColorMarket"];
    [[CCDirector sharedDirector] replaceScene:colorMarket withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.3f]];
}

-(void)appPurchases {
    [MGWU logEvent:@"InAppPurchasesMenu" withParams:nil];
    CCScene *colorMarket = [CCBReader loadAsScene:@"PointsMarket"];
    [[CCDirector sharedDirector] replaceScene:colorMarket withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.3f]];
}

//only visible during gameplay
-(void)end {
    [MGWU logEvent:@"GameEndButtonPressed" withParams:nil];
    [self endGame];
}

#pragma mark - Game Center

//Calls GameCenter
-(void)scores {
    [self showLeaderboardAndAchievements:YES];
}

//GameCenter
-(void)showLeaderboardAndAchievements:(BOOL)shouldShowLeaderboard
{
    GKGameCenterViewController *gcViewController = [[GKGameCenterViewController alloc] init];
    gcViewController.gameCenterDelegate = self;
    
    if (shouldShowLeaderboard) {
        gcViewController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gcViewController.leaderboardIdentifier = gkLeaderboard;
    }
    else{
        gcViewController.viewState = GKGameCenterViewControllerStateAchievements;
    }
    
    // [self presentViewController:gcViewController animated:YES completion:nil];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:gcViewController animated:YES completion:nil];
    
}
-(void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [gameCenterViewController dismissViewControllerAnimated:YES completion:nil];
}


@end
