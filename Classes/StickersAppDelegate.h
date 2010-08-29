//
//  StickersAppDelegate.h
//  Stickers
//
//  Created by ∞ on 19/08/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MoverMini/MoverMini.h>

@interface StickersAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	MvrTable* table;
	
	BOOL addedStickerToTable;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController* viewController;

- (IBAction) showMoverTable;

@end

