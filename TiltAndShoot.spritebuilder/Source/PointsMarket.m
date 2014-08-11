//
//  PointsMarket.m
//  TiltAndShoot
//
//  Created by Samuel Drozdov on 8/4/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "PointsMarket.h"

@implementation PointsMarket {
    CCLabelTTF *_overallScore;
    CCNodeColor *_background;
    CCNodeColor *_stupidBackCover;
}

- (void)didLoadFromCCB {
    int overallScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OverallScore"] intValue];
    _overallScore.string = [NSString stringWithFormat:@"%d",overallScore];
    
    _background.color = [self checkForBackgroundColor];
    _stupidBackCover.color = [self checkForBackgroundColor];
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

-(void)first {
    [MGWU buyProduct:@"com.xxx.xxx.productID1" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void)second {
    [MGWU buyProduct:@"com.xxx.xxx.productID2" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void)third {
    [MGWU buyProduct:@"com.xxx.xxx.productID3" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void)restore {
    [MGWU restoreProductsWithCallback:@selector(restoredProducts:) onTarget:self];
}

//???

-(void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:0.3f]];
}

@end
