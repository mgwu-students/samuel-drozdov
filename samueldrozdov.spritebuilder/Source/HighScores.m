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
}

//When the back button is clicked the MainScene scene is loaded
- (void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}


-(void)updateScores {
    _classicScore.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].classicScore];
    _zenScore.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].zenScore];
    _marathonScore.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].marathonScore];
    _insanityScore.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].insanityScore];
}

@end
