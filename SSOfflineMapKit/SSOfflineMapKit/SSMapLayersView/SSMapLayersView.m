//  Created by Sergiy Shevchuk on 9/7/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSMapLayersView.h"

@interface SSMapLayersView ()
@property (nonatomic, copy) WWDictionaryBlock   dictionaryCompletion;
@property (nonatomic, copy) WWResultBlock       resultCompletion;

@property (nonatomic, strong) NSDictionary  *buttonsState;

@end

@implementation SSMapLayersView

- (IBAction)buttonClicked:(id)sender {
    if (self.resultCompletion) {
        self.resultCompletion(@([sender tag]));
    }
}

- (void)setButtonsStateWith:(NSDictionary *)state dictionaryCompletion:(WWDictionaryBlock)completionBlock {
    
}

- (void)setButtonsStateWith:(NSArray *)state completion:(WWResultBlock)completionBlock {
    if (completionBlock) {
        self.resultCompletion = completionBlock;
    }
    for (NSInteger index =0; index >= state.count; index++) {
        NSNumber *buttonState = state[index];
        BOOL isButtonClicked = buttonState.boolValue;
        if (isButtonClicked) {
            
        }
    }
}

@end
