//
//  StickersAppDelegate.m
//  Stickers
//
//  Created by ∞ on 19/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "StickersAppDelegate.h"
#import "StickerView.h"
#import "StickerItemDisplayer.h"

@interface StickersAppDelegate ()

- (unichar) kewlUnicodeStickerCharacterForDevice;

@end


@implementation StickersAppDelegate

@synthesize window, viewController;


#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    [window makeKeyAndVisible];
	
	// Display our own sticker -- for Mover Mini stuff, see below.
	
	StickerView* sv = [[[StickerView alloc] initWithFrame:CGRectZero] autorelease];
	[sv sizeToFit];
	sv.center = CGPointMake(CGRectGetMidX(window.bounds), CGRectGetMidY(window.bounds));
	[self.viewController.view addSubview:sv];
	
	sv.label.text = [NSString stringWithFormat:@"%C", [self kewlUnicodeStickerCharacterForDevice]];
	sv.transform = CGAffineTransformMakeRotation(5 * M_PI/180);	
	
	
	// ----- INITIALIZING MOVER MINI -----
	// 1. Can we use it?
	
	if (!MvrMiniIsAvailable())
		return YES;
	
	// 2. Set up the table and start the engine (so we can receive incoming stuff in the background as we run).
	
	table = [[MvrTable alloc] initAttachedToWindow:window];
	[table.engine start];
	
	// 3. Add an "Add to collection" command for received stickers.
	
	MvrMiniItemAction* addToCollection = [MvrMiniItemAction
										  actionWithTitle:@"Add '%(title)' To Collection" 
										  replaceFormatSpecifiers:YES
										  target:self
										  action:@selector(addToCollection:)];
	table.itemActions = [NSArray arrayWithObject:addToCollection];
	
	// 4. Register our displayer, so we can draw the sticker inside the Mover slide.
	// See StickerItemDisplayer.m for comments on this.

	[StickerItemDisplayer addDisplayer];
		
	return YES;
}

- (IBAction) showMoverTable;
{
	// This method is called when you tap the "Trade!" button on the main screen.
	
	// Always check!
	if (!MvrMiniIsAvailable())
		return;
	
	// We only add the sticker once.
	// A better app would check if our MvrMiniItem is still on the table by checking
	// in the engine's knownItems set, but we are lazy.
	if (!addedStickerToTable) {
		// Our item's content is just the letter on the sticker, in UTF-8.
		NSString* letterString = [NSString stringWithFormat:@"%C", [self kewlUnicodeStickerCharacterForDevice]];
		NSData* letter = [letterString dataUsingEncoding:NSUTF8StringEncoding];
		
		// And this is our slide!
		MvrMiniItem* item = [MvrMiniItem itemWithData:letter title:letterString type:kStickerItemType userInfo:nil];
		
		// We add it to the table and show it.
		[table showByAddingItem:item];
		addedStickerToTable = YES;
	} else
		[table show]; // Just show the table (easy!)
}

- (void) addToCollection:(MvrMiniItem*) item;
{
	// This method is called when the user taps 'Add to collection' on a received item.
	// We read the string the other device wrote into the item in -showMoverTable...
	NSString* str = [[[NSString alloc]
					  initWithContentsOfFile:item.path // <<--- reading from the item via .path!
					  encoding:NSUTF8StringEncoding 
					  error:NULL] autorelease];
	
	// ... and then add the sticker to our collection.
	// In this case, we don't need to actually *keep* the file associated to the
	// item, so we don't do anything to it -- Mover Mini will clear the table
	// periodically and delete the file when its time has come.
	// If we wanted to keep it around, we would use
	// -[MvrMiniItem makePersistentByMovingToPath:error:] to save it somewhere else.
	
	StickerView* sv = [[[StickerView alloc] initWithFrame:CGRectZero] autorelease];
	[sv sizeToFit];
	sv.center = CGPointMake(CGRectGetMidX(window.bounds), CGRectGetMidY(window.bounds));
	
	sv.label.text = str;
	sv.transform = CGAffineTransformMakeRotation((arc4random() % 3) * M_PI/180);
	sv.alpha = 0.0;
	
	[viewController.view addSubview:sv];
	
	[UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 sv.alpha = 1.0;
					 }
					 completion:NULL];
	
	[table hide];
}

- (unichar) kewlUnicodeStickerCharacterForDevice;
{
	// This method picks which sticker you get.
	
	NSString* dev = [[UIDevice currentDevice] uniqueIdentifier];
	NSInteger sum = 0;
	
	NSInteger i; for (i = 0; i < [dev length]; i++)
		sum += (NSInteger) [dev characterAtIndex:i];
	
	return (unichar) (sum % (0x17E - 0xA1)) + 0xA1;
}

@end
