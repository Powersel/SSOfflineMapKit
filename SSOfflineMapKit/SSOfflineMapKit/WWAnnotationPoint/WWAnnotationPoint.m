//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWAnnotationPoint.h"

#import "WWImageAnnotation.h"
#import "WWPOIAnnotation.h"
#import "WWTrackAnnotation.h"

typedef NS_ENUM(NSUInteger, WWAnnotationPrivateTypes) {
    WWPOIType = 0,
    WWTrackType,
    WWImageType
};

@interface WWAnnotationPoint ()

- (instancetype)clasterWithDictionary:(NSDictionary *)dictionary;

@end

@implementation WWAnnotationPoint

#pragma mark - Class Methods

+ (instancetype)annotationWithDictionary:(NSDictionary *)dictionary {
    WWAnnotationPoint *annotationPoint = [[WWAnnotationPoint alloc] clasterWithDictionary:dictionary];
    
    return annotationPoint;
}

#pragma mark - Initialisation and Dealoccation

- (instancetype)initAnnotationWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        
    }
    
    return self;
}

#pragma mark - Accessors

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

#pragma mark - Private

- (instancetype)clasterWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *annoTypes = @{@"poi":[NSNumber numberWithInteger:WWPOIType],
                                @"image":[NSNumber numberWithInteger:WWImageType],
                                @"track":[NSNumber numberWithInteger:WWTrackType]};
    NSString *entityValue = dictionary[@"properties"][@"entity"];
    NSNumber *annotationType = annoTypes[entityValue];
    
    if (annotationType.integerValue) {
        switch (annotationType.integerValue) {
            case WWPOIType:
                return [[WWPOIAnnotation alloc] initAnnotationWithDictionary:dictionary];
            case WWTrackType:
                return [[WWTrackAnnotation alloc] initAnnotationWithDictionary:dictionary];
            case WWImageType:
                return [[WWImageAnnotation alloc] initAnnotationWithDictionary:dictionary];
        }
    }
    
    return nil;
}

@end
