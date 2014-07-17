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
    
    if([GameMechanics sharedInstance].highScoreSet) {
        _newHighScore.visible = YES;
    }
    
    [self updateLabels];
}

-(void)updateLabels {
    //highScoreLabel
    if([[GameMechanics sharedInstance].previousGameMode isEqual: @"GameModes/Classic"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/TimeAttack"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ZenHighScore"]).intValue];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Marathon"]) {
        _highScoreLabel.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).floatValue];
    } 
    
    //youScoreLabel
    //youScoreLabel
    if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Classic"]) {
        _finalScoreLabel.string = [NSString stringWithFormat:@"%.2lf", [GameMechanics sharedInstance].classicTime];
    } else if([[GameMechanics sharedInstance].previousGameMode isEqual:@"GameModes/Marathon"]) {
        _finalScoreLabel.string = [NSString stringWithFormat:@"%.2lf", [GameMechanics sharedInstance].classicTime];
    } else {
        _finalScoreLabel.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].score];
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
