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
    CCLabelTTF *_points;
    
    CCColor *color1;
    CCColor *color2;
    CCColor *color3;
    CCColor *color4;
    CCColor *color5;
    
    CCNodeColor *_background;
    CCNodeColor *_backgroundColorNode1;
    CCNodeColor *_backgroundColorNode2;
    CCNodeColor *_backgroundColorNode3;
    CCNodeColor *_backgroundColorNode4;
    CCNodeColor *_backgroundColorNode5;
    
    bool background2Unlocked;
    bool background3Unlocked;
    bool background4Unlocked;
    bool background5Unlocked;
    CCSprite *_backStar2;
    CCSprite *_backStar3;
    CCSprite *_backStar4;
    CCSprite *_backStar5;
    
    CCSprite *_selectedCircle;
    bool crosshair2Unlocked;
    bool crosshair3Unlocked;
    bool crosshair4Unlocked;
    bool crosshair5Unlocked;
    CCSprite *_crossStar2;
    CCSprite *_crossStar3;
    CCSprite *_crossStar4;
    CCSprite *_crossStar5;
    CCNode *_cPosition1;
    CCNode *_cPosition2;
    CCNode *_cPosition3;
    CCNode *_cPosition4;
    CCNode *_cPosition5;
}

// is called when CCB file has completed loading
- (void)didLoadFromCCB {
    // tell this scene to accept touches
    self.userInteractionEnabled = TRUE;
    
    bbSize = [[UIScreen mainScreen] bounds].size;
    
    //Color nodes change color of the background(bottom) and the instructions,crosshairs(top)
    color1 = [CCColor colorWithRed:0.302 green:0.427 blue:0.835];
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
    [self pickCrosshair];
    [self pickBackground];
    
    int stars = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue];
    _points.string = [NSString stringWithFormat:@"%d", stars];
}


-(void)checkBought {
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Background2"] intValue]) {
        background2Unlocked = true;
        _backStar2.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Background3"] intValue]) {
        background3Unlocked = true;
        _backStar3.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Background4"] intValue]) {
        background4Unlocked = true;
        _backStar4.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Background5"] intValue]) {
        background5Unlocked = true;
        _backStar5.visible = false;
    }
    
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Crosshair2"] intValue]) {
        crosshair2Unlocked = true;
        _crossStar2.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Crosshair3"] intValue]) {
        crosshair3Unlocked = true;
        _crossStar3.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Crosshair4"] intValue]) {
        crosshair4Unlocked = true;
        _crossStar4.visible = false;
    }
    if(1 == [[[NSUserDefaults standardUserDefaults] objectForKey:@"Crosshair5"] intValue]) {
        crosshair5Unlocked = true;
        _crossStar5.visible = false;
    }
}

-(CCColor *)checkForBackgroundColor {
    int x = [[[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"] intValue];
    CCColor *color;
    if(x == 1) {
        color = color1;
    } else if(x == 2) {
        color = color2;
    } else if(x == 3) {
        color = color3;
    } else if(x == 4) {
        color = color4;
    } else if(x == 5) {
        color = color5;
    } else {
        color = color1;
    }
    return color;
}

-(void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.3f]];
}

#pragma mark - Crosshair Selecting Mechanics

-(void)cross1 {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"SelectedCrosshair"];
    [self pickCrosshair];
}

-(void)cross2 {
    if(!crosshair2Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 150) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Crosshair2"];
            [self boughtCrosshair];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"SelectedCrosshair"];
    [self pickCrosshair];
}

-(void)cross3 {
    if(!crosshair3Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 150) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Crosshair3"];
            [self boughtCrosshair];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"SelectedCrosshair"];
    [self pickCrosshair];
}

-(void)cross4 {
    if(!crosshair4Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 150) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Crosshair4"];
            [self boughtCrosshair];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"SelectedCrosshair"];
    [self pickCrosshair];
}

-(void)cross5 {
    if(!crosshair5Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 150) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Crosshair5"];
            [self boughtCrosshair];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"SelectedCrosshair"];
    [self pickCrosshair];
}

-(void)boughtCrosshair {
    int stars = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue];
    [[NSUserDefaults standardUserDefaults] setInteger:(stars-150) forKey:@"Stars"];
    _points.string = [NSString stringWithFormat:@"%d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue]];
    [self checkBought];
}

-(void)pickCrosshair { //Positions are weriddd
    int selectedCrosshair = [[[NSUserDefaults standardUserDefaults] objectForKey:@"SelectedCrosshair"] integerValue];
    if(selectedCrosshair == 1) {
        _selectedCircle.position = _cPosition1.parent.positionInPoints;
    } else if(selectedCrosshair == 2) {
        _selectedCircle.position = _cPosition2.parent.positionInPoints;
    } else if(selectedCrosshair == 3) {
        _selectedCircle.position = _cPosition3.parent.positionInPoints;
    } else if(selectedCrosshair == 4) {
        _selectedCircle.position = _cPosition4.parent.positionInPoints;
    } else if(selectedCrosshair == 5) {
        _selectedCircle.position = _cPosition5.parent.positionInPoints;
    }
}

#pragma mark - Background Selecting Mechanics

-(void)background1 {
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"backgroundColor"];
    [self pickBackground];
}

-(void)background2 {
    if(!background2Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 50) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Background2"];
            [self boughtBackground];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:2 forKey:@"backgroundColor"];
    [self pickBackground];
}

-(void)background3 {
    if(!background3Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 50) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Background3"];
            [self boughtBackground];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:3 forKey:@"backgroundColor"];
    [self pickBackground];
}

-(void)background4 {
    if(!background4Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 50) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Background4"];
            [self boughtBackground];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:@"backgroundColor"];
    [self pickBackground];
}

-(void)background5 {
    if(!background5Unlocked) {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue] >= 50) {
            [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"Background5"];
            [self boughtBackground];
        }
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:5 forKey:@"backgroundColor"];
    [self pickBackground];
}

-(void)boughtBackground {
    int stars = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue];
    [[NSUserDefaults standardUserDefaults] setInteger:(stars-50) forKey:@"Stars"];
    _points.string = [NSString stringWithFormat:@"%d", [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue]];
    [self checkBought];
}

-(void)pickBackground {
    _background.color = [self checkForBackgroundColor];
    _stupidButtonCover.color = [self checkForBackgroundColor];
}


@end
