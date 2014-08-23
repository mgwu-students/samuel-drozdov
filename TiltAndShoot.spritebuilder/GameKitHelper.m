//
//  GameKitHelper.m
//  Timberman2
//
//  Created by Benjamin Reynolds on 8/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "GameKitHelper.h"

@interface GameKitHelper ()
<GKGameCenterControllerDelegate> {
    BOOL _gameCenterFeaturesEnabled;
}
@end

@implementation GameKitHelper

#pragma mark Singleton stuff

+(id) sharedGameKitHelper {
    static GameKitHelper *sharedGameKitHelper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedGameKitHelper =
        [[GameKitHelper alloc] init];
    });
    return sharedGameKitHelper;
}

#pragma mark Player Authentication

-(void) authenticateLocalPlayer {
    
    GKLocalPlayer* localPlayer = [GKLocalPlayer localPlayer];
    
    __weak GKLocalPlayer *blockLocalPlayer = localPlayer;
    
    localPlayer.authenticateHandler =
    ^(UIViewController *viewController,
      NSError *error) {
        
        [self setLastError:error];
        
        if ([CCDirector sharedDirector].isPaused)
            [[CCDirector sharedDirector] resume];
        
        if (blockLocalPlayer.authenticated) {
            _gameCenterFeaturesEnabled = YES;
        } else if(viewController) {
            [[CCDirector sharedDirector] pause];
            [self presentViewController:viewController];
        } else {
            _gameCenterFeaturesEnabled = NO;
        }
    };
}

#pragma mark Property setters

-(void) setLastError:(NSError*)error {
    _lastError = [error copy];
    if (_lastError) {
        NSLog(@"GameKitHelper ERROR: %@", [[_lastError userInfo]
                                           description]);
    }
}

#pragma mark UIViewController stuff

-(UIViewController*) getRootViewController {
    return [UIApplication
            sharedApplication].keyWindow.rootViewController;
}

-(void)presentViewController:(UIViewController*)vc {
    UIViewController* rootVC = [self getRootViewController];
    [rootVC presentViewController:vc animated:YES
                       completion:nil];
}

#pragma mark - Scores

-(void) submitScore:(int64_t)score
           category:(NSString*)category {
    //1: Check if Game Center
    //   features are enabled
    if (!_gameCenterFeaturesEnabled) {
        CCLOG(@"Player not authenticated");
        return;
    }
    
    //2: Create a GKScore object
    GKScore* gkScore =
    [[GKScore alloc]
     initWithCategory:category];
    
    //3: Set the score value
    gkScore.value = score;
    
    //4: Send the score to Game Center
    [gkScore reportScoreWithCompletionHandler:
     ^(NSError* error) {
         
         [self setLastError:error];
         
         BOOL success = (error == nil);
         
         if ([_delegate
              respondsToSelector:
              @selector(onScoresSubmitted:)]) {
             
             [_delegate onScoresSubmitted:success];
         }
     }];
}

@end