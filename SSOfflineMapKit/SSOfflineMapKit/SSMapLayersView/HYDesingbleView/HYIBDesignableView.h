//
//  HYView.h
//  heyya
//
//  Created by Daria Kovalenko on 6/9/16.
//  Copyright © 2016 anahoret.com. All rights reserved.
//

#import "WWView.h"

IB_DESIGNABLE

@interface HYIBDesignableView : WWView

- (UIView *)loadViewFromNib; //override if need customize loading with nib

@end
