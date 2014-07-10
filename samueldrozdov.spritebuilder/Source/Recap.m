//
//  Recap.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Recap.h"
#import "GameMechanics.h"

@implementation Recap {
    CCLabelTTF *_finalScoreLabel;
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    _finalScoreLabel.string = [NSString stringWithFormat:@"%d", [GameMechanics sharedInstance].score];
}

//When the restart button is clicked the Gameplay scene is loaded
- (void)restart {
    CCScene *gameplayScene = [CCBReader loadAsScene:@"GameModes"];
    [[CCDirector sharedDirector] replaceScene:gameplayScene];
}

//When the menu button is clicked the MainScene scene is loaded
- (void)menu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene];
}

@end
