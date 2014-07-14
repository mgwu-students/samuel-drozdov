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
    CCLabelTTF *_zenScore;
    CCLabelTTF *_marathonScore;
    CCLabelTTF *_insanityScore;
    
    CCNode *_classicBronze;
    CCNode *_classicSilver;
    CCNode *_classicGold;
    CCNode *_marathonBronze;
    CCNode *_marathonSilver;
    CCNode *_marathonGold;
    CCNode *_zenBronze;
    CCNode *_zenSilver;
    CCNode *_zenGold;
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
    _classicBronze.visible = false;
    _classicSilver.visible = false;
    _classicGold.visible = false;
    _marathonBronze.visible = false;
    _marathonSilver.visible = false;
    _marathonGold.visible = false;
    _zenBronze.visible = false;
    _zenSilver.visible = false;
    _zenGold.visible = false;
    _insanityBronze.visible = false;
    _insanitySilver.visible = false;
    _insanityGold.visible = false;
    [self checkMedals];
    [self updateScores];
}

-(void)checkMedals {
    float classicScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue;
    int zenScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ZenHighScore"]).intValue;
    int marathonScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).intValue;
    int insanityScore = ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"InsanityHighScore"]).intValue;
    
    if(classicScore < 10) {
        _classicBronze.visible = true;
    } if(classicScore < 20) {
        _classicSilver.visible = true;
    } if(classicScore < 30) {
        _classicGold.visible = true;
    }
    
    if(marathonScore > 10) {
        _marathonBronze.visible = true;
    } if(marathonScore > 20) {
        _marathonSilver.visible = true;
    } if(marathonScore > 30) {
        _marathonGold.visible = true;
    }
    
    if(zenScore > 10) {
        _zenBronze.visible = true;
    } if(zenScore > 17) {
        _zenSilver.visible = true;
    } if(zenScore > 25) {
        _zenGold.visible = true;
    }

    if(insanityScore > 5) {
        _insanityBronze.visible = true;
    } if(insanityScore > 10) {
        _insanitySilver.visible = true;
    } if(insanityScore > 15) {
        _insanityGold.visible = true;
    }
}

-(void)updateScores {
    _classicScore.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
    _zenScore.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ZenHighScore"]).intValue];
    _marathonScore.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).intValue];
    _insanityScore.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"InsanityHighScore"]).intValue];
}

@end
