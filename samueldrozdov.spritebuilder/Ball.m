//
//  Ball.m
//  samueldrozdov
//
//  Created by Samuel Drozdov on 7/8/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Ball.h"

@implementation Ball {
    CCLabelTTF *_scoreLabel;
    int score;
}

// is called when CCB file has completed loading
-(void)didLoadFromCCB {
    score = 10;
    _scoreLabel.string = [NSString stringWithFormat:@"%d", score];
}

@end
