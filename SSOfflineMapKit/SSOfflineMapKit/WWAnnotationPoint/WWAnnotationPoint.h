//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, WWAnnotationType) {
    WWPOIAnnotationType = 0,
    WWMainWPAnnotationType,
    WWMainTrackAnnotationType,
    WWSidetripAnnotationType,
    WWAlternateAnnotationType,
    WWImageAnnotationType
};

@interface WWAnnotationPoint : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D  coordinate;
@property (nonatomic, assign)   WWAnnotationType    annotationType;

+ (instancetype)annotationWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initAnnotationWithDictionary:(NSDictionary *)dictionary;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
