//
//  HYView.h
//  heyya
//
//  Created by Daria Kovalenko on 6/9/16.
//  Copyright © 2016 anahoret.com. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface HYIBDesignableView : UIView

- (UIView *)loadViewFromNib; //override if need customize loading with nib

@end
