//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWAnnotationPoint.h"

@interface WWAnnotationPoint ()

- (instancetype)classFabricWith:(NSDictionary *)dictionary;

@end

@implementation WWAnnotationPoint

#pragma mark - Class Methods

+ (instancetype)initAnnotationWith:(NSDictionary *)dictionary {
    WWAnnotationPoint *annotationPoint = [WWAnnotationPoint new];
    
    return annotationPoint;
}

#pragma mark - Accessors

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

#pragma mark - Private

- (instancetype)classFabricWith:(NSDictionary *)dictionary {
    
}

@end
