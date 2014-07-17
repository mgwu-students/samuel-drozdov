//
//  HighScores.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/11/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "HighScores.h"
#import "GameMechanics.h"

@implementation HighScores {
    CCLabelTTF *_classicScore;
    CCLabelTTF *_timeAttackScore;
    CCLabelTTF *_marathonScore;
    CCLabelTTF *_insanityScore;
    
    CCNode *_classicBronze;
    CCNode *_classicSilver;
    CCNode *_classicGold;
    CCNode *_marathonBronze;
    CCNode *_marathonSilver;
    CCNode *_marathonGold;
    CCNode *_timeAttackBronze;
    CCNode *_timeAttackSilver;
    CCNode *_timeAttackGold;
    CCNode *_insanityBronze;
    CCNode *_insanitySilver;
    CCNode *_insanityGold;
}

-(id)init {
    if(self = [super init]) {
        // classic medals
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"cB"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"cS"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"cG"];
        // time attack medals
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"TB"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"TS"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"TG"];
        // marathon medals
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"mB"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"mS"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"mG"];

        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    return self;
}

//When the back button is clicked the MainScene scene is loaded
- (void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

- (void)onEnter
{
    [super onEnter];
    _classicBronze.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"cB"];
    _classicSilver.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"cB"];
    _classicGold.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"cB"];
    _marathonBronze.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"mB"];
    _marathonSilver.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"mS"];
    _marathonGold.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"mG"];
    _timeAttackBronze.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"TB"];
    _timeAttackSilver.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"TS"];
    _timeAttackGold.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"TG"];
    [self checkMedals];
    [self updateScores];
}

-(void)checkMedals {
    float classicScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue;
    int TimeAttackScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeAttackHighScore"]).intValue;
    float marathonScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).intValue;
    
    if(classicScore < 30) {
        _classicBronze.visible = true;
    } if(classicScore < 20) {
        _classicSilver.visible = true;
    } if(classicScore < 12) {
            _classicGold.visible = true;
    }
    
    if(marathonScore > 10) {
        _marathonBronze.visible = true;
    } if(marathonScore > 30) {
        _marathonSilver.visible = true;
    } if(marathonScore > 50) {
        _marathonGold.visible = true;
    }
    
    if(TimeAttackScore > 10) {
        _timeAttackBronze.visible = true;
    } if(TimeAttackScore > 17) {
        _timeAttackSilver.visible = true;
    } if(TimeAttackScore > 25) {
        _timeAttackGold.visible = true;
    }
}

-(void)updateScores {
    _classicScore.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
    _timeAttackScore.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeAttackHighScore"]).intValue];
    _marathonScore.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).floatValue];
}

@end
