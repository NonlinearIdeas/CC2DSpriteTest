//
//  TouchLayer.m
//  CC2DSpriteTest
//
//  Created by James Wucher on 1/5/14.
//  Copyright (c) 2014 James Wucher. All rights reserved.
//

#import "TouchLayer.h"

@implementation TouchLayer

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) )
   {
      self.touchEnabled = YES;
	}
	return self;
}

-(CGPoint)locationFromTouches:(NSSet*)touches
{
   UITouch* touch = touches.anyObject;
   CGPoint touchLocation = [touch locationInView:touch.view];
   return [[CCDirector sharedDirector] convertToGL:touchLocation];
}


-(void)registerWithTouchDispatcher
{  // NOTE:  This function is ONLY valid for CCLayer derived things.
   [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:INT_MIN+1 swallowsTouches:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
   [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] KEY_TOUCH_BEGAN] object:touch];
   return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
   [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] KEY_TOUCH_CONTINUE] object:touch];
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
   [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] KEY_TOUCH_ENDED] object:touch];
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
   [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] KEY_TOUCH_ENDED] object:touch];
}

+(NSString*) KEY_TOUCH_BEGAN
{
   return @"KEY_TOUCH_BEGAN";
}
+(NSString*) KEY_TOUCH_CONTINUE
{
   return @"KEY_TOUCH_CONTINUE";
}
+(NSString*) KEY_TOUCH_ENDED
{
   return @"KEY_TOUCH_ENDED";
}


@end
