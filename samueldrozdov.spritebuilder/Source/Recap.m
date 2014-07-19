//
//  Recap.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Recap.h"

#import "GameMechanics.h"
#import "HighScores.h"

@implementation Recap {
    CCLabelTTF *_highScoreLabel;
    CCLabelTTF *_finalScoreLabel;
    CCLabelTTF *_newHighScore;
    CCLabelTTF *_newMedal;
    
    CCNode *_bronzeCover;
    CCNode *_silverCover;
    CCNode *_goldCover;
}

- (void)onEnter
{
    [super onEnter];

}
- (void)onExit
{
    [super onExit];
    [GameMechanics sharedInstance].highScoreSet = false;
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    _newHighScore.visible = NO;
    _newMedal.visible = NO;
    
    // showing the newMedal label triumphs the newHighScore label
    if(![GameMechanics sharedInstance].newMedal && [GameMechanics sharedInstance].highScoreSet) {
        _newHighScore.visible = YES;
    } else if([GameMechanics sharedInstance].newMedal) {
        _newMedal.visible = YES;
    }
    
    [self updateLabels];
    [self updateMedals];
}

-(void)updateLabels {
    //highScoreLabel
    if([[GameMechanics sharedInstance].previousGameMode isEqual: @"GameModes/Classic"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/TimeAttack"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeAttackHighScore"]).intValue];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Marathon"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).floatValue];
    } 

    //youScoreLabel
    if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Classic"]) {
        _finalScoreLabel.string = [NSString stringWithFormat:@"%.2lf", [GameMechanics sharedInstance].classicTime];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Marathon"]) {
        _finalScoreLabel.string = [NSString stringWithFormat:@"%.2lf", [GameMechanics sharedInstance].classicTime];
    } else {
        _finalScoreLabel.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].score];
    }
}

-(void)updateMedals {
    if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Classic"]) {
        if([GameMechanics sharedInstance].classicB) _bronzeCover.visible = false;
        if([GameMechanics sharedInstance].classicS) _silverCover.visible = false;
        if([GameMechanics sharedInstance].classicG) _goldCover.visible = false;
    }
    if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Marathon"]) {
        if([GameMechanics sharedInstance].marathonB) _bronzeCover.visible = false;
        if([GameMechanics sharedInstance].marathonS) _silverCover.visible = false;
        if([GameMechanics sharedInstance].marathonG) _goldCover.visible = false;
    }
    if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/TimeAttack"]) {
        if([GameMechanics sharedInstance].timeAttackB) _bronzeCover.visible = false;
        if([GameMechanics sharedInstance].timeAttackS) _silverCover.visible = false;
        if([GameMechanics sharedInstance].timeAttackG) _goldCover.visible = false;
    }
}

//When the restart button is clicked the same Game Mode scene is loaded
- (void)restart {
    CCScene *gameplayScene = [CCBReader loadAsScene:[GameMechanics sharedInstance].previousGameMode];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

//When the menu button is clicked the MainScene scene is loaded
- (void)menu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
