//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWAnnotationPoint.h"

#import "WWImageAnnotation.h"
#import "WWPOIAnnotation.h"
#import "WWTrackAnnotation.h"

typedef NS_ENUM(NSUInteger, WWAnnotationPrivateType) {
    WWTypePOI = 0,
    WWTypeTrack,
    WWTypeImage,
    WWTypeCount,
    WWTypeUndefined
};

@interface WWAnnotationPoint ()

@end

@implementation WWAnnotationPoint

#pragma mark - Class Methods

+ (instancetype)annotationWithDictionary:(NSDictionary *)dictionary {
    NSDictionary *annoTypes = @{
                                @"poi"      :   @(WWTypePOI),
                                @"image"    :   @(WWTypeImage),
                                @"track"    :   @(WWTypeTrack)
                                };
    NSString *entityValue = dictionary[@"properties"][@"entity"];
    NSNumber *annotationType = annoTypes[entityValue];
    WWAnnotationPrivateType type = !annotationType ? WWTypeUndefined : annotationType.integerValue;
    
    return (type < WWTypeCount) ? [[[self classWithType:type] alloc] initWithDictionary:dictionary] : nil;
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
//
//- (instancetype)clasterWithDictionary:(NSDictionary *)dictionary {
//    NSDictionary *annoTypes = @{@"poi":[NSNumber numberWithInteger:WWTypePOI],
//                                @"image":[NSNumber numberWithInteger:WWTypeImage],
//                                @"track":[NSNumber numberWithInteger:WWTypeTrack]};
//    NSString *entityValue = dictionary[@"properties"][@"entity"];
//    NSNumber *annotationType = annoTypes[entityValue];
//    
//    WWAnnotationPrivateType type = [annotationType integerValue];
//    return (type < WWTypeCount) ? [[[self classWithType:type] alloc] initWithDictionary:dictionary] : nil;
//}

+ (Class)classWithType:(WWAnnotationPrivateType)annotationType {
    return @[[WWPOIAnnotation class],
             [WWTrackAnnotation class],
             [WWImageAnnotation class]][annotationType];
}

@end
