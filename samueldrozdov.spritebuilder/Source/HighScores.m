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
    [self checkMedals];
    [self updateScores];
}

-(void)checkMedals {
    float classicScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue;
    int timeAttackScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeAttackHighScore"]).intValue;
    float marathonScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).intValue;
    
    if(classicScore < 30) {
        _classicBronze.visible = false;
    } if(classicScore < 20) {
        _classicSilver.visible = false;
    } if(classicScore < 12) {
        _classicGold.visible = false;
    }
    
    if(marathonScore > 10) {
        _marathonBronze.visible = false;
    } if(marathonScore > 30) {
        _marathonSilver.visible = false;
    } if(marathonScore > 50) {
        _marathonGold.visible = false;
    }
    
    if(timeAttackScore > 10) {
        _timeAttackBronze.visible = false;
    } if(timeAttackScore > 17) {
        _timeAttackSilver.visible = false;
    } if(timeAttackScore > 25) {
        _timeAttackGold.visible = false;
    }
}

-(void)updateScores {
    _classicScore.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
    _timeAttackScore.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeAttackHighScore"]).intValue];
    _marathonScore.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).floatValue];
}

@end
