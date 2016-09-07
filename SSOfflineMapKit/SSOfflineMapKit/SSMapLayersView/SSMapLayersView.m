//  Created by Sergiy Shevchuk on 9/7/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSMapLayersView.h"

@interface SSMapLayersView ()
@property (nonatomic, copy) WWResultBlock       resultCompletion;

@end

@implementation SSMapLayersView

- (IBAction)buttonClicked:(id)sender {
    NSInteger tag = [sender tag];
    UIButton *currentButton = self.buttons[tag];
    BOOL buttonState = currentButton.selected;
    if (buttonState) {
        currentButton.selected = NO;
    } else {
        currentButton.selected = YES;
    }
    if (self.resultCompletion) {
        self.resultCompletion(@(tag));
    }
}

- (void)setButtonsStateWith:(NSArray *)state completion:(WWResultBlock)completionBlock {
    if (completionBlock) {
        self.resultCompletion = completionBlock;
    }
    for (NSInteger index =0; index < state.count; index++) {
        NSNumber *buttonState = state[index];
        BOOL isButtonClicked = buttonState.boolValue;
            UIButton *currentButton = self.buttons[index];
        currentButton.selected = !isButtonClicked;
    }
}

@end
