//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
}

//When the play button is clicked the Gameplay scene is loaded
- (void)play {
    CCScene *gameModesScene = [CCBReader loadAsScene:@"GameModes"];
    [[CCDirector sharedDirector] replaceScene:gameModesScene];
}

//When the highScores button is clicked the Scores scene is loaded
- (void)highScores {
    CCScene *scoresScene = [CCBReader loadAsScene:@"HighScores"];
    [[CCDirector sharedDirector] replaceScene:scoresScene];
}

//When the play button is clicked the Gameplay scene is loaded
- (void)setting {
}

@end
