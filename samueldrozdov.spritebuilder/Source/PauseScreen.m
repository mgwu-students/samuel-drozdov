//
//  PauseScreen.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/16/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PauseScreen.h"

#import "GameMechanics.h"

@implementation PauseScreen {
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_yourScoreLabel;
}

-(void)onEnter {
    [super onEnter];
}

-(void)onExit {
    [super onExit];
}

// restart current game mode button
- (void)restartPS {
    CCScene *restartScene = [CCBReader loadAsScene:[GameMechanics sharedInstance].previousGameMode];
    [[CCDirector sharedDirector] replaceScene:restartScene];
}

// return to menu button
- (void)menuPS {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

// exit back to game button
- (void)continuePS {
    [[GameMechanics sharedInstance].motionManager startAccelerometerUpdates];
    [self removeFromParent];
}

@end
