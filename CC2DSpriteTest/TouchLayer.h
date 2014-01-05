//
//  TouchLayer.h
//  CC2DSpriteTest
//
//  Created by James Wucher on 1/5/14.
//  Copyright (c) 2014 James Wucher. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "cocos2d.h"



@interface TouchLayer : CCLayer<CCTouchOneByOneDelegate>

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event;
- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event;

// Using NSNotificationCenter to pass the actual UITouch object to
// Interested parties.  This is not optimal, but quick for this
// demonstration application.
+(NSString*) KEY_TOUCH_BEGAN;
+(NSString*) KEY_TOUCH_CONTINUE;
+(NSString*) KEY_TOUCH_ENDED;

@end
