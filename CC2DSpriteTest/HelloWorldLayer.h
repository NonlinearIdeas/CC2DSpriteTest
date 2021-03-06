//
//  HelloWorldLayer.h
//  CC2DSpriteTest
//
//  Created by James Wucher on 1/5/14.
//  Copyright James Wucher 2014. All rights reserved.
//


#import <GameKit/GameKit.h>

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorldLayer
@interface HelloWorldLayer : CCLayer <GKAchievementViewControllerDelegate, GKLeaderboardViewControllerDelegate>
{
   CCSprite* arrow;
   CCSprite* player;
   NSMutableArray* monsters;
   float secondsSinceLastUpdate;
}

// NOTE:  This is for keeping references to the monsters ONLY.
// Actual memory retention is done by adding them to the layer.
@property (nonatomic,retain) NSMutableArray* monsters;
@property (nonatomic, retain) CCSprite* player;
@property (nonatomic, retain) CCSprite* arrow;

// returns a CCScene that contains the HelloWorldLayer as the only child
+(CCScene *) scene;

@end
