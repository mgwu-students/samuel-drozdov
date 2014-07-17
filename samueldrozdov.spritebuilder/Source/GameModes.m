//
//  GameModes.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameModes.h"

@implementation GameModes

//When the back button is clicked the MainScene scene is loaded
- (void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

//When the play button is clicked the Classic scene is loaded
- (void)classic {
    CCScene *classicScene = [CCBReader loadAsScene:@"GameModes/Classic"];
    [[CCDirector sharedDirector] replaceScene:classicScene];
}

//When the play button is clicked the Time Attack scene is loaded
- (void)timeAttack {
    CCScene *timeAttackScene = [CCBReader loadAsScene:@"GameModes/TimeAttack"];
    [[CCDirector sharedDirector] replaceScene:timeAttackScene];
}

//When the play button is clicked the Marathon scene is loaded
- (void)marathon {
    CCScene *marathonScene = [CCBReader loadAsScene:@"GameModes/Marathon"];
    [[CCDirector sharedDirector] replaceScene:marathonScene];
}

@end
