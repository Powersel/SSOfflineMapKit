//
//  HYView.m
//  heyya
//
//  Created by Daria Kovalenko on 6/9/16.
//  Copyright © 2016 anahoret.com. All rights reserved.
//

#import "HYIBDesignableView.h"

@interface HYIBDesignableView ()

- (void)xibSetup;

@end

@implementation HYIBDesignableView
#pragma mark - Initializers

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    [self xibSetup];
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self xibSetup];
    
    return self;
}

#pragma mark - Public

- (UIView *)loadViewFromNib {
    NSBundle *bandle = [NSBundle bundleForClass:[self class]];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bandle];
    UIView *view = [[nib instantiateWithOwner:self options:nil] firstObject];
    
    return view;
}

- (void)prepareForInterfaceBuilder {
    [self xibSetup];
}

#pragma mark - Private

- (void)xibSetup {
    UIView *view = [self loadViewFromNib];
    view.frame = self.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:view];
}

@end
