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
        // classic medals
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"cB"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"cS"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"cG"];
        // zen medals
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"zB"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"zS"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"zG"];
        // marathon medals
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"mB"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"mS"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"mG"];
        // insanity medals
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"iB"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"iS"];
        [[NSUserDefaults standardUserDefaults] setObject:false forKey:@"iG"];
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
    _zenBronze.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"zB"];
    _zenSilver.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"zS"];
    _zenGold.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"zG"];
    _insanityBronze.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"iB"];
    _insanitySilver.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"iS"];
    _insanityGold.visible = (bool)[[NSUserDefaults standardUserDefaults] objectForKey:@"iG"];
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
