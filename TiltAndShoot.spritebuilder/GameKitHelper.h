//
//  GameKitHelper.h
//  Timberman2
//
//  Created by Benjamin Reynolds on 8/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

//   Include the GameKit framework
#import <GameKit/GameKit.h>

//   Protocol to notify external
//   objects when Game Center events occur or
//   when Game Center async tasks are completed
@protocol GameKitHelperProtocol<NSObject>
-(void) onScoresSubmitted:(bool)success;
@end


@interface GameKitHelper : NSObject

@property (nonatomic, assign)
id<GameKitHelperProtocol> delegate;

// This property holds the last known error
// that occured while using the Game Center API's
@property (nonatomic, readonly) NSError* lastError;

+ (id) sharedGameKitHelper;

// Player authentication, info
-(void) authenticateLocalPlayer;

// Scores
-(void) submitScore:(int64_t)score category:(NSString*)category;

@end