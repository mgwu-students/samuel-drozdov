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
    [[GameMechanics sharedInstance] checkMedals];
    [self updateMedals];
    [self updateScores];
}

// sets the 'covers' of the medals' visibility to false so they are visible
-(void)updateMedals {
    if([GameMechanics sharedInstance].classicB) _classicBronze.visible = false;
    if([GameMechanics sharedInstance].classicS) _classicSilver.visible = false;
    if([GameMechanics sharedInstance].classicG) _classicGold.visible = false;
    
    if([GameMechanics sharedInstance].marathonB) _marathonBronze.visible = false;
    if([GameMechanics sharedInstance].marathonS) _marathonSilver.visible = false;
    if([GameMechanics sharedInstance].marathonG) _marathonGold.visible = false;
    
    if([GameMechanics sharedInstance].timeAttackB) _timeAttackBronze.visible = false;
    if([GameMechanics sharedInstance].timeAttackS) _timeAttackSilver.visible = false;
    if([GameMechanics sharedInstance].timeAttackG) _timeAttackSilver.visible = false;
}

-(void)updateScores {
    _classicScore.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"ClassicHighScore"]).floatValue];
    _timeAttackScore.string = [NSString stringWithFormat:@"%d", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"TimeAttackHighScore"]).intValue];
    _marathonScore.string = [NSString stringWithFormat:@"%.2lf", ((NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"MarathonHighScore"]).floatValue];
}

@end
