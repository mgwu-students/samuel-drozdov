//
//  ColorMarket.m
//  TiltAndShoot
//
//  Created by Samuel Drozdov on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "ColorMarket.h"

@implementation ColorMarket {
    CGSize bbSize;
    CCNodeColor *_stupidButtonCover;
    
    CCColor *color1;
    CCColor *color2;
    CCColor *color3;
    CCColor *color4;
    CCColor *color5;
    
    CCNode *_backgroundColorPopup;
    CCNode *_backgroundColorNode;
    CCNodeColor *_backgroundColorNode1;
    CCNodeColor *_backgroundColorNode2;
    CCNodeColor *_backgroundColorNode3;
    CCNodeColor *_backgroundColorNode4;
    CCNodeColor *_backgroundColorNode5;
    CCNodeColor *_backgroundColorLabel2;
    CCNodeColor *_backgroundColorLabel3;
    CCNodeColor *_backgroundColorLabel4;
    CCNodeColor *_backgroundColorLabel5;
    CCLabelTTF *_points;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    bbSize = [[UIScreen mainScreen] bounds].size;
    
    //Color nodes change color of the background(bottom) and the instructions,crosshairs(top)
    color1 = [CCColor colorWithRed:0.302 green:0.427 blue:0.835];
    _stupidButtonCover.color = color1;
    _backgroundColorNode1.color = color1;
    color2 = [CCColor colorWithRed:0.251 green:0.898 blue:0.251];
    _backgroundColorNode2.color = color2;
    color3 = [CCColor colorWithRed:1.0 green:0.776 blue:0.278];
    _backgroundColorNode3.color = color3;
    color4 = [CCColor colorWithRed:1.0 green:0.278 blue:0.278];
    _backgroundColorNode4.color = color4;
    color5 = [CCColor colorWithRed:0.227 green:0.773 blue:0.796];
    _backgroundColorNode5.color = color5;
    
    [self checkBought];
    
    int stars = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue];
    _points.string = [NSString stringWithFormat:@"%d", stars];
}

-(void)checkBought {
    // hides color unlock labels
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color2Unlocked"] intValue]) {
        _backgroundColorLabel2.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color3Unlocked"] intValue]) {
        _backgroundColorLabel3.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color4Unlocked"] intValue]) {
        _backgroundColorLabel4.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color5Unlocked"] intValue]) {
        _backgroundColorLabel5.visible = false;
    }
}

// called on every touch in this scene
-(void) touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    bool colorPicked = false;
    CGPoint touches = [touch locationInWorld];
    int overallScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue];

    if(touches.y > bbSize.height*0.8) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"backgroundColor"];
        colorPicked = true;
    } else if(touches.y > bbSize.height*0.6) {
        if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color2Unlocked"] intValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:2] forKey:@"backgroundColor"];
            colorPicked = true;
        }
        if(0 == [[NSUserDefaults standardUserDefaults] objectForKey:@"Color2Unlocked"]
           && overallScore >= 100) {
            overallScore -= 100;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Color2Unlocked"];
        }
    } else if(touches.y > bbSize.height*0.4) {
        if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color3Unlocked"] intValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:3] forKey:@"backgroundColor"];
            colorPicked = true;
        }
        if(0 == [[NSUserDefaults standardUserDefaults] objectForKey:@"Color3Unlocked"]
           && overallScore >= 100) {
            overallScore -= 100;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Color3Unlocked"];
        }
    } else if(touches.y > bbSize.height*0.2) {
        if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color4Unlocked"] intValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:4] forKey:@"backgroundColor"];
            colorPicked = true;
        }
        if(0 == [[NSUserDefaults standardUserDefaults] objectForKey:@"Color4Unlocked"]
           && overallScore >= 100) {
            overallScore -= 100;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Color4Unlocked"];
        }
    } else if(touches.y > bbSize.height*0.0) {
        if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Color5Unlocked"] intValue]) {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:5] forKey:@"backgroundColor"];
            colorPicked = true;
        }
        if(0 == [[NSUserDefaults standardUserDefaults] objectForKey:@"Color5Unlocked"]
           && overallScore >= 100) {
            overallScore -= 100;
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:1] forKey:@"Color5Unlocked"];
        }
    }
    _points.string = [NSString stringWithFormat:@"%d", overallScore];
    
    // updates overall score if something was bought
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:overallScore] forKey:@"Stars"];
    [self checkBought];
    
    if(colorPicked) {
        [self returnToMenu];
    }
}

-(void)back {
    [self returnToMenu];
}

-(void)returnToMenu {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.3f]];
}


@end
