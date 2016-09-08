//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, WWAnnotationType) {
    WWPOIAnnotation = 0,
    WWMainWPAnnotation,
    WWMainTrackAnnotation,
    WWSidetripAnnotation,
    WWAlternateAnnotation,
    WWImageAnnotation
};

@interface WWAnnotationPoint : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D  coordinate;
@property (nonatomic, assign)   WWAnnotationType    annotationType;

+ (instancetype)initAnnotationWith:(NSDictionary *)dictionary;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
