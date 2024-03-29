//
//  HelloWorldLayer.m
//  NSKeyedArchiverBug
//
//  Created by Martin Walsh on 30/10/2013.
//  Copyright Pedro LTD 2013. All rights reserved.
//


// Import the interfaces
#import "HelloWorldLayer.h"

// Needed to obtain the Navigation Controller
#import "AppDelegate.h"

#pragma mark Simple Object / NSCoding
@implementation SimpleAsset

-(id)init
{
	if((self = [super init])){
        _counter = 0;
	}
	
	return self;
}

-(id) initWithCoder:(NSCoder *) aDecoder {
	
	self = [super init];
	if(self != nil) {
		self.counter = [aDecoder decodeIntForKey:@"counter"];
        
	}
	return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    
	[aCoder encodeInt:self.counter forKey:@"counter"];
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"counter: %d",self.counter];
}

@end

#pragma mark - HelloWorldLayer

// HelloWorldLayer implementation
@implementation HelloWorldLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorldLayer *layer = [HelloWorldLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
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
		CCLabelTTF *label = [CCLabelTTF labelWithString:@"NSKeyedArchiverBug" fontName:@"Marker Felt" fontSize:32];

		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
	
		// position the label on the center of the screen
		label.position =  ccp( size.width /2 , size.height/2 );
		
		// add the label as a child to this Layer
		[self addChild: label];
		
		
		// Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		
		// to avoid a retain-cycle with the menuitem and blocks
		__block id copy_self = self;
		
		// Achievement Menu Item using blocks
		CCMenuItem *itemBug = [CCMenuItemFont itemWithString:@"Start Test" block:^(id sender) {
            
            [copy_self archiveTest:16];
			[copy_self archiveTest:32];
            [copy_self archiveTest:64];
            [copy_self archiveTest:128];
        }];
		
		
		CCMenu *menu = [CCMenu menuWithItems:itemBug, nil];
		
		[menu alignItemsHorizontallyWithPadding:20];
		[menu setPosition:ccp( size.width/2, size.height/2 - 50)];
		
		// Add the menu to the layer
		[self addChild:menu];

	}
	return self;
}

-(void) archiveTest:(int) count {
    
    CCLOG(@"[archiveTest] Started");
    
    NSInteger entries = count;
    NSMutableArray* saveData = [[NSMutableArray alloc] init];
    
    CCLOG(@"[archiveTest] Populating Array");
    
    for(int i=0;i<entries;i++) {
        SimpleAsset* newAsset = [[SimpleAsset alloc] init];
        [newAsset setCounter:i];
        [saveData addObject:newAsset];
    }
    
    CCLOG(@"[archiveTest] Populated Array Count: %d",[saveData count]);
    
    // Output Array
    for(id object in saveData) {
        CCLOG(@"%@",object);
    }
    
    // Convert Array -> Data (This bit that breaks)
    CCLOG(@"[archiveTest] Archiving Array");
    NSData *data       = [NSKeyedArchiver archivedDataWithRootObject:saveData];
    
    CCLOG(@"[archiveTest] Completed");
    
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

@end
