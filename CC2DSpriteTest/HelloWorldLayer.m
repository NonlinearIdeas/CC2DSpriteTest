//
//  HelloWorldLayer.m
//  CC2DSpriteTest
//
//  Created by James Wucher on 1/5/14.
//  Copyright James Wucher 2014. All rights reserved.
//

const float SECONDS_TO_UPDATE_MONSTERS = 0.5f;

// Import the interfaces
#import "HelloWorldLayer.h"
#import "TouchLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

@synthesize monsters;
@synthesize player;
@synthesize arrow;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
   
   [scene addChild:[TouchLayer node]];
   
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super's" return value
	if( (self=[super init]) ) {
		
		// create and initialize a Label
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
      
      self.monsters = [NSMutableArray array];
      self.player = nil;
      secondsSinceLastUpdate = SECONDS_TO_UPDATE_MONSTERS;
		
		
		//
		// Leaderboards and Achievements
		//
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemAchievement = [CCMenuItemFont itemWithString:@"Achievements" block:^(id sender) {
			
			
			GKAchievementViewController *achivementViewController = [[GKAchievementViewController alloc] init];
			achivementViewController.achievementDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:achivementViewController animated:YES];
			
			[achivementViewController release];
		}];
		
		// Leaderboard Menu Item using blocks
		CCMenuItem *itemLeaderboard = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
			
			
			GKLeaderboardViewController *leaderboardViewController = [[GKLeaderboardViewController alloc] init];
			leaderboardViewController.leaderboardDelegate = copy_self;
			
			AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
			
			[[app navController] presentModalViewController:leaderboardViewController animated:YES];
			
			[leaderboardViewController release];
		}];

		
		CCMenu *menu = [CCMenu menuWithItems:itemAchievement, itemLeaderboard, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
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

#pragma mark GameKit delegate

-(void) achievementViewControllerDidFinish:(GKAchievementViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

-(void) leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
	AppController *app = (AppController*) [[UIApplication sharedApplication] delegate];
	[[app navController] dismissModalViewControllerAnimated:YES];
}

- (void) touchNotif:(NSNotification *) notification
{
   if([notification.object isKindOfClass:[UITouch class]])
   {
      UITouch* touch = (UITouch*)notification.object;
      CGPoint location = [self locationFromTouch:touch];
      CCLOG(@"Touched at (%f,%f)",location.x,location.y);
      self.player.position = location;
   }
}

-(void)createArrow
{
   if(self.arrow != nil)
   {
      [self removeChild:arrow];
      self.arrow = nil;
   }
   CGSize scrSize = [[CCDirector sharedDirector] winSize];
   CCSprite* arrowSprite = [CCSprite spriteWithFile:@"arrow.png"];
   arrowSprite.position = ccp(scrSize.width/2,scrSize.height/2);
   [self addChild:arrowSprite];
   self.arrow = arrowSprite;
}

-(void)createPlayer
{
   if(self.player != nil)
   {
      [self removeChild:player];
      self.player = nil;
   }
   CGSize scrSize = [[CCDirector sharedDirector] winSize];
   CCSprite* playerSprite = [CCSprite spriteWithFile:@"Icon.png"];
   playerSprite.scale = 2.0;
   playerSprite.position = ccp(scrSize.width/3,scrSize.height/3);
   [self addChild:playerSprite];
   self.player = playerSprite;
}

-(void)createMonsters
{
   const int MAX_MONSTERS = 4;
   if(self.monsters.count > 0)
   {  // Get rid of them
      for(CCSprite* sprite in monsters)
      {
         [self removeChild:sprite];
      }
      [self.monsters removeAllObjects];
   }
   CGSize scrSize = [[CCDirector sharedDirector] winSize];
   for(int idx = 0; idx < MAX_MONSTERS; idx++)
   {
      CCSprite* sprite = [CCSprite spriteWithFile:@"Icon.png"];
      float randomX = (arc4random()%100)/100.0;
      float randomY = (arc4random()%100)/100.0;
      sprite.scale = 1.0;
      sprite.position = ccp(scrSize.width*randomX,scrSize.height*randomY);
      [self addChild:sprite];
      [monsters addObject:sprite];
   }
}

-(void)updatePlayerAndMonsters:(ccTime)delta
{
   secondsSinceLastUpdate += delta;
   if(secondsSinceLastUpdate >= SECONDS_TO_UPDATE_MONSTERS)
   {  // Modify all the actions on all the monsters.
      CGPoint playerPos = player.position;
      for(CCSprite* sprite in monsters)
      {
         float randomX = (1.0)*(arc4random()%50);
         float randomY = (1.0)*(arc4random()%50);
         CGPoint position = ccp(playerPos.x+randomX,playerPos.y+randomY);
         [sprite stopAllActions];
         [sprite runAction:[CCMoveTo actionWithDuration:6.0 position:position]];
      }
      secondsSinceLastUpdate = 0.0;
   }
}

static inline float AdjustAngle(float angleRads)
{
   if(angleRads > M_PI)
   {
      while(angleRads > M_PI)
      {
         angleRads -= 2*M_PI;
      }
   }
   else if(angleRads < -M_PI)
   {
      while(angleRads < -M_PI)
      {
         angleRads += 2*M_PI;
      }
   }
   return angleRads;
}

static inline float Sign(float value)
{
   if(value >= 0)
      return 1.0f;
   return -1.0f;
}

//#define ROTATION_OPTION_1
//#define ROTATION_OPTION_2
#define ROTATION_OPTION_3

-(void)updateArrow
{
   // Calculate the angle to the player
   CGPoint toPlayer = ccpSub(self.player.position,self.arrow.position);
   // Calculate the angle of this...Note there are some inversions
   // and the actual image is rotated 90 degrees so I had to offset it
   // a bit.
   float angleToPlayerRads = -atan2f(toPlayer.y, toPlayer.x);
   angleToPlayerRads = AdjustAngle(angleToPlayerRads);
   
   // This is the angle we "wish" the arrow would be pointing.
   float targetAngle = CC_RADIANS_TO_DEGREES(angleToPlayerRads)+90;
   float errorAngle = targetAngle-self.arrow.rotation;
   
   CCLOG(@"Error Angle = %f",errorAngle);
   
   
#ifdef ROTATION_OPTION_1
   // In this option, we just set the angle of the rotated sprite directly.
   self.arrow.rotation = CC_RADIANS_TO_DEGREES(angleToPlayerRads)+90;
#endif
   
   
#ifdef ROTATION_OPTION_2
   // In this option, we apply proportional feedback to the angle
   // difference.
   const float kProp = 0.05f;
   self.arrow.rotation += kProp * (errorAngle);
#endif
   
#ifdef ROTATION_OPTION_3
   // The step to take each update in degrees.
   const float kStep = 4.0f;
   //  NOTE:  Without the "if(fabs(...)) check, the angle
   // can "dither" around the zero point when it is very close.
   if(fabs(errorAngle) > kStep)
   {
      self.arrow.rotation += Sign(errorAngle)*kStep;
   }
#endif
}



-(void)update:(ccTime)delta
{
   [self updatePlayerAndMonsters:delta];
   [self updateArrow];
}

-(CGPoint)locationFromTouch:(UITouch*)touch
{
   CGPoint touchLocation = [touch locationInView:touch.view];
   return [[CCDirector sharedDirector] convertToGL:touchLocation];
}

-(void)onEnterTransitionDidFinish
{
   [super onEnterTransitionDidFinish];
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(touchNotif:)
    name:[[TouchLayer class] KEY_TOUCH_BEGAN] object:nil];
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(touchNotif:)
    name:[[TouchLayer class] KEY_TOUCH_CONTINUE] object:nil];
   [[NSNotificationCenter defaultCenter]
    addObserver:self
    selector:@selector(touchNotif:)
    name:[[TouchLayer class] KEY_TOUCH_ENDED] object:nil];
   [self createArrow];
   [self createPlayer];
   [self createMonsters];
   [self scheduleUpdate];
}

-(void)onExitTransitionDidStart
{
   [[NSNotificationCenter defaultCenter] removeObserver:self];
   [super onExitTransitionDidStart];
}



@end
