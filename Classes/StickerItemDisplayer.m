//
//  StickerItemDisplayer.m
//  Stickers
//
//  Created by ∞ on 19/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickerItemDisplayer.h"
#import "StickerView.h"

// This class is used by the table to display items that correspond to our custom UTI (type).
// We register this in the app delegate before the table is shown for the first time.

@implementation StickerItemDisplayer

- (NSSet *) displayableItemTypes;
{
	// These are the types we can handle. We'll be called to handle them.
	// (You can pick and choose which items to handle by overriding -canDisplayItem:,
	// if checking the type is not enough.)
	
	return [NSSet setWithObject:kStickerItemType];
}

- (NSString *) titleForItem:(MvrMiniItem *)item;
{
	// This reformats the item's title for display.
	
	if ([item.title length] == 0)
		return @"";
	
	unichar c = [item.title characterAtIndex:0];
	return [NSString stringWithFormat:@"%C (%d)", c, (int) c];
}

- (UIImage *) imageOfSize:(CGSize)s forItem:(MvrMiniItem *)item;
{
	// This method creates an image which is displayed over the slide on the Mover table.
	// We simply draw the same character that's on the sticker, but at a reduced size.
	
	UIGraphicsBeginImageContext(s);
	
	UIFont* f = [UIFont boldSystemFontOfSize:72];
	
	CGSize textSize = [item.title sizeWithFont:f];
	
	CGPoint p = CGPointMake(s.width / 2, s.height / 2);
	p.x -= textSize.width / 2.0;
	p.y -= textSize.height / 2.0;
	
	[item.title drawAtPoint:p withFont:f];
	
	UIImage* i = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return i;
}

@end
