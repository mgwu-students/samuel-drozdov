//
//  GameModes.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameModes.h"

@implementation GameModes

//When the play button is clicked the Classic scene is loaded
- (void)classic {
    CCScene *classicScene = [CCBReader loadAsScene:@"GameModes/Classic"];
    [[CCDirector sharedDirector] replaceScene:classicScene];
}

//When the play button is clicked the Zen scene is loaded
- (void)zen {
    CCScene *zenScene = [CCBReader loadAsScene:@"GameModes/Zen"];
    [[CCDirector sharedDirector] replaceScene:zenScene];
}

//When the play button is clicked the Marathon scene is loaded
- (void)marathon {
    CCScene *marathonScene = [CCBReader loadAsScene:@"GameModes/Marathon"];
    [[CCDirector sharedDirector] replaceScene:marathonScene];
}


///INSANITY Mode is going to have to be unlocked by getting gold medals on all levels
////When the play button is clicked the Insanity scene is loaded
- (void)insanity {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GameModes/Insanity"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

@end
