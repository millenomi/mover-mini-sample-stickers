//
//  StickerView.m
//  Stickers
//
//  Created by ∞ on 19/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "StickerView.h"

#import <QuartzCore/QuartzCore.h>

@implementation StickerView


- (id) initWithFrame:(CGRect) frame;
{
    if ((self = [super initWithFrame:frame])) {
		[[NSBundle mainBundle] loadNibNamed:@"StickerView" owner:self options:nil];
		
		CGRect f = contentView.bounds;
		f.origin = frame.origin;
		self.frame = f;
		
		[self addSubview:contentView];
		self.layer.cornerRadius = 20.0;
		contentView.layer.cornerRadius = 20.0;
		self.layer.shadowColor = [UIColor blackColor].CGColor;
		self.layer.shadowOffset = CGSizeMake(0, 2);
		self.layer.shadowOpacity = 0.3;
		self.clipsToBounds = NO;
    }
	
    return self;
}

@synthesize label;

- (void) dealloc
{
	[label release];
	[contentView release];
	[super dealloc];
}


@end
