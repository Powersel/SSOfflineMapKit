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
    currentButton.selected = currentButton.selected ? NO : true;
    if (self.resultCompletion) {
        self.resultCompletion(@(tag));
    }
}

- (void)setButtonsStateWith:(NSArray *)state completion:(WWResultBlock)completionBlock {
    if (completionBlock) {
        self.resultCompletion = completionBlock;
    }
    
    for (NSInteger index = 0; index < state.count; index++) {
        UIButton *currentButton = self.buttons[index];
        NSNumber *isSelected = state[index];
        currentButton.selected = isSelected.boolValue;
    }
}

@end
