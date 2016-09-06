//  Created by Sergiy Shevchuk on 9/1/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import <Foundation/Foundation.h>

@interface SSAnnotationsContainer : NSObject
@property (nonatomic, readonly) NSArray *trackAnnotations;

@property (nonatomic, readonly) NSArray *photos;
@property (nonatomic, readonly) NSArray *poiAnnotations;
@property (nonatomic, readonly) NSArray *trackPoints;
@property (nonatomic, readonly) NSArray *transport;

+ (instancetype)initContainerWithJSON:(NSData *)annotationsJSON;

@end
