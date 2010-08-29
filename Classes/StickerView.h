//
//  StickerView.h
//  Stickers
//
//  Created by ∞ on 19/08/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StickerView : UIView {
	IBOutlet UILabel* label;
	IBOutlet UIView* contentView;
}

@property(readonly) UILabel* label;

@end
