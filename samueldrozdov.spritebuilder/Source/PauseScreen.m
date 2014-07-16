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
    [self updateLabels];
}

-(void)onExit {
    [super onExit];
}


-(void)updateLabels {
    //highScoreLabel
    if([[GameMechanics sharedInstance].previousGameMode isEqual: @"GameModes/Classic"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Zen"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ZenHighScore"]).intValue];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Marathon"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).intValue];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Insanity"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"InsanityHighScore"]).intValue];
    }
    
    //youScoreLabel
    if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Classic"]) {
        _yourScoreLabel.string = [NSString stringWithFormat:@"%.2lf", [GameMechanics sharedInstance].classicTime];
    } else {
        _yourScoreLabel.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].score];
    }
}

// restart current game mode, button
- (void)restartPS {
    CCScene *restartScene = [CCBReader loadAsScene:[GameMechanics sharedInstance].previousGameMode];
    [[CCDirector sharedDirector] replaceScene:restartScene];
}

// return to menu, button
- (void)menuPS {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

// exit back to game, button
- (void)continuePS {
    [[GameMechanics sharedInstance].motionManager startAccelerometerUpdates];
    [self removeFromParent];
}

@end
