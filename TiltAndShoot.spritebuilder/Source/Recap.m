//
//  Recap.m
//  TiltAndShoot
//
//  Created by Samuel Drozdov on 7/21/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Recap.h"

@implementation Recap {
    CCLabelTTF *_finalScoreLabel;
    CCLabelTTF *_yourHighScoreLabel;
    
    CCLabelTTF *_newHighScore;
    CCLabelTTF *_newGlobalHighScore;
    
    CCNode *_bronzeCover;
    CCNode *_silverCover;
    CCNode *_goldCover;
    CCNodeColor *_background;
    CCNodeColor *_stupidBestBackground;
    CCNodeColor *_stupidScoreBackground;
    
    CCLabelTTF *_add50;
    CCLabelTTF *_add100;
    CCLabelTTF *_add150;
    CCLabelTTF *_overallScoreLabel;
}

- (void)onEnter {
    [super onEnter];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"Start"];
}
- (void)onExit {
    [super onExit];
}

- (void)didLoadFromCCB {
    int prevScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"PreviousScore"]).intValue;
    int yourHighScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"HighScore"]).intValue;
    
    _finalScoreLabel.string = [NSString stringWithFormat:@"%d", prevScore];
    _yourHighScoreLabel.string = [NSString stringWithFormat:@"%d", yourHighScore];
    
    int overallScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OverallScore"] intValue];
    
    if(prevScore >= 50) {
        _bronzeCover.visible = false;
        _add50.visible = true;
        overallScore += 25;
    }
    if(prevScore >= 100) {
        _silverCover.visible = false;
        _add100.visible = true;
        overallScore += 50;
    }
    if(prevScore >= 150) {
        _goldCover.visible = false;
        _add150.visible = true;
        overallScore += 75;
    }
    
    if(prevScore == yourHighScore) {
        _newHighScore.visible = true;
    }
    
    _overallScoreLabel.string = [NSString stringWithFormat:@"%d", overallScore];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:overallScore] forKey:@"OverallScore"];
    
    _background.color = [self checkForBackgroundColor];
    _stupidBestBackground.color = [self checkForBackgroundColor];
    _stupidScoreBackground.color = [self checkForBackgroundColor];
    _bronzeCover.color = [self checkForBackgroundColor];
    _silverCover.color = [self checkForBackgroundColor];
    _goldCover.color = [self checkForBackgroundColor];
}

-(CCColor *)checkForBackgroundColor{
    int x = [[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"] intValue];
    CCColor *color;
    if(x == 1) {
        color = [CCColor colorWithRed:0.302 green:0.427 blue:0.835];
    } else if(x == 2) {
        color = [CCColor colorWithRed:0.251 green:0.898 blue:0.251];
    } else if(x == 3) {
        color = [CCColor colorWithRed:1.0 green:0.776 blue:0.278];
    } else if(x == 4) {
        color = [CCColor colorWithRed:1.0 green:0.278 blue:0.278];
    } else if(x == 5) {
        color = [CCColor colorWithRed:0.471 green:0.298 blue:0.839];
    } else {
        color = [CCColor colorWithRed:0.227 green:0.773 blue:0.796];
    }
    return color;
}

-(void)restart {
    [MGWU logEvent:@"ClickedRestart" withParams:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Start"];
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

-(void)menu {
    [MGWU logEvent:@"ClickedMenu" withParams:nil];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"Start"];
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
