//  Created by Sergiy Shevchuk on 9/1/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import <Foundation/Foundation.h>

@interface SSAnnotationsContainer : NSObject
@property (nonatomic, readonly) NSArray *trackAnnotations;

+ (instancetype)initContainerWithJSON:(NSData *)annotationsJSON;

@end
