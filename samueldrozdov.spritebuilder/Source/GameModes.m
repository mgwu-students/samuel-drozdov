//
//  GameModes.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameModes.h"

@implementation GameModes

//When the play button is clicked the Gameplay scene is loaded
- (void)classic {
    CCScene *classicScene = [CCBReader loadAsScene:@"Classic"];
    [[CCDirector sharedDirector] replaceScene:classicScene];
}

//When the play button is clicked the Gameplay scene is loaded
- (void)zen {
    CCScene *zenScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:zenScene];
}

//When the play button is clicked the Gameplay scene is loaded
- (void)marathon {
    CCScene *marathonScene = [CCBReader loadAsScene:@"Gameplay"];
    [[CCDirector sharedDirector] replaceScene:marathonScene];
}


///INSANITY Mode is going to have to be unlocked by getting gold medals on all levels
////When the play button is clicked the Gameplay scene is loaded
//- (void)insanity {
//    CCScene *gameplayScene = [CCBReader loadAsScene:@"Gameplay"];
//    [[CCDirector sharedDirector] replaceScene:gameplayScene];
//}

@end
