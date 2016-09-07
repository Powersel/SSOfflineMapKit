//
//  SSMapLayersView.h
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 9/7/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import "HYIBDesignableView.h"
#import "WWBlockTypeDef.h"

typedef NS_ENUM(NSUInteger, WWLayerButtons) {
    WWPOIButton = 0,
    WWMainWPButton,
    WWMainTrackButton,
    WWSidetripsButton,
    WWAlternatesButton,
    WWImagesButton
};

@interface SSMapLayersView : HYIBDesignableView
@property (strong, nonatomic) IBOutlet UIButton *POIButton;
@property (strong, nonatomic) IBOutlet UIButton *mainWPButton;
@property (strong, nonatomic) IBOutlet UIButton *mainTrackButton;
@property (strong, nonatomic) IBOutlet UIButton *sidetripsButton;
@property (strong, nonatomic) IBOutlet UIButton *alternatesButton;
@property (strong, nonatomic) IBOutlet UIButton *imagesButton;

@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *buttons;

- (IBAction)buttonClicked:(id)sender;

- (void)setButtonsStateWith:(NSArray *)state completion:(WWResultBlock)completionBlock;

@end
