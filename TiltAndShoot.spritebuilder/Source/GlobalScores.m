//
//  GlobalScores.m
//  TiltAndShoot
//
//  Created by Samuel Drozdov on 8/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GlobalScores.h"

@implementation GlobalScores {
    CCNodeColor *_background;
    CCNodeColor *_stupidButtonCover;
    CCTextField *_textName;
    
    CCLabelTTF *_name1;
    CCLabelTTF *_name2;
    CCLabelTTF *_name3;
    CCLabelTTF *_name4;
    CCLabelTTF *_name5;
    
    CCLabelTTF *_score1;
    CCLabelTTF *_score2;
    CCLabelTTF *_score3;
    CCLabelTTF *_score4;
    CCLabelTTF *_score5;
}

- (void)didLoadFromCCB {
    _background.color = [self checkForBackgroundColor];
    _stupidButtonCover.color = [self checkForBackgroundColor];
    
    _textName.string = [[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"];
    
   // [MGWU getHighScoresForLeaderboard:@"defaultLeaderboard" withCallback:@selector(receivedScores:) onTarget:self];
}

-(void)updateName {
    [[NSUserDefaults standardUserDefaults] setObject:_textName.string forKey:@"UserName"];
}

- (void)receivedScores:(NSDictionary*)scores
{
    _name1.string = [[scores objectForKey:@"all"][0] objectForKey:@"name"];
    _name2.string = [[scores objectForKey:@"all"][1] objectForKey:@"name"];
    _name3.string = [[scores objectForKey:@"all"][2] objectForKey:@"name"];
    _name4.string = [[scores objectForKey:@"all"][3] objectForKey:@"name"];
    _name5.string = [[scores objectForKey:@"all"][4] objectForKey:@"name"];
    

    _score1.string = [NSString stringWithFormat:@"%d",[[[scores objectForKey:@"all"][0] objectForKey:@"score"] intValue]];
    _score2.string = [NSString stringWithFormat:@"%d",[[[scores objectForKey:@"all"][1] objectForKey:@"score"] intValue]];
    _score3.string = [NSString stringWithFormat:@"%d",[[[scores objectForKey:@"all"][2] objectForKey:@"score"] intValue]];
    _score4.string = [NSString stringWithFormat:@"%d",[[[scores objectForKey:@"all"][3] objectForKey:@"score"] intValue]];
    _score5.string = [NSString stringWithFormat:@"%d",[[[scores objectForKey:@"all"][4] objectForKey:@"score"] intValue]];
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
        color = [CCColor colorWithRed:0.227 green:0.773 blue:0.796];
    } else {
        color = [CCColor colorWithRed:0.302 green:0.427 blue:0.835];
    }
    return color;
}

-(void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionRight duration:0.3f]];
}

@end
