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
    int stars = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Stars"] intValue];
    _overallScore.string = [NSString stringWithFormat:@"%d",stars];
    
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

-(void)back {
    CCScene *mainScene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:mainScene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionUp duration:0.3f]];
}

#pragma mark -  Buttons

//REDO THIS ALL FOR STARSSSS

-(void)first {
    [MGWU buyProduct:@"com.SamuelDrozdov.TiltAndShoot.Stars1" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void)second {
    [MGWU buyProduct:@"com.SamuelDrozdov.TiltAndShoot.Stars2" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void)third {
    [MGWU buyProduct:@"com.SamuelDrozdov.TiltAndShoot.Stars3" withCallback:@selector(boughtProduct:) onTarget:self];
}
-(void)restore {
    [MGWU restoreProductsWithCallback:@selector(restoredProducts:) onTarget:self];
}

#pragma mark - Product Purchas Methods

-(void)boughtProduct: (NSString *)productID {
    int overallScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OverallScore"] intValue];
    
    if(productID == nil) {
        return;
    } else if([productID isEqualToString:@"com.SamuelDrozdov.TiltAndShoot.Stars1"]) {
        overallScore += 50;
    } else if([productID isEqualToString:@"com.SamuelDrozdov.TiltAndShoot.Stars2"]) {
        overallScore += 250;
    } else if([productID isEqualToString:@"com.SamuelDrozdov.TiltAndShoot.Stars3"]) {
        overallScore += 1000;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:overallScore] forKey:@"OverallScore"];
}

-(void)restoredProducts: (NSArray *)productIDs {
    if(productIDs == nil) {
        return;
    } else {
        int overallScore = [[[NSUserDefaults standardUserDefaults] objectForKey:@"OverallScore"] intValue];
        
        for (NSString* productID in productIDs) {
            if([productID isEqualToString:@"com.SamuelDrozdov.TiltAndShoot.Stars1"]) {
                overallScore += 50;
            } else if([productID isEqualToString:@"com.SamuelDrozdov.TiltAndShoot.Stars2"]) {
                overallScore += 250;
            } else if([productID isEqualToString:@"com.SamuelDrozdov.TiltAndShoot.Stars3"]) {
                overallScore += 1000;
            }
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:overallScore] forKey:@"OverallScore"];
    }
    
}

@end
