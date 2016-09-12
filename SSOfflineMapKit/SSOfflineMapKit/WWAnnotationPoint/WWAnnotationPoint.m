//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWAnnotationPoint.h"
#import "WWImageAnnotation.h"
#import "WWTrackAnnotation.h"

@interface WWAnnotationPoint ()

@end

@implementation WWAnnotationPoint

#pragma mark - Class Methods

+ (instancetype)annotationWithDictionary:(NSDictionary *)dictionary {
    if ([dictionary[@"properties"][@"entity"] isEqualToString:@"image"]) {
        return [[WWImageAnnotation alloc] initWithDictionary:dictionary];
    }
        return [[WWTrackAnnotation alloc] initWithDictionary:dictionary];
}

#pragma mark - Initialisation and Dealoccation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    return self;
}

#pragma mark - Accessors

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

#pragma mark - Private

@end
