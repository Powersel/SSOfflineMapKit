//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWTrackAnnotation.h"

typedef NS_ENUM(NSUInteger, WWPrivateTrackpointType) {
    WWPrivateMainWPType = 0,
    WWPrivateMainTrackType,
    WWPrivateSidetripType,
    WWPrivateAlternateType,
    WWPrivateTrackpointsCount,
    WWTrackTypeUndefined
};

@interface WWTrackAnnotation ()
@property (nonatomic, strong) NSArray *waypointsCoordinates;

@property (nonatomic, strong) NSNumber    *startLatitude;
@property (nonatomic, strong) NSNumber    *startLongitude;

@property (nonatomic, strong) NSString    *waypointTitle;
@property (nonatomic, strong) NSString    *annotationDescription;

@property (nonatomic, strong) NSURL       *imageURL;

@property (nonatomic, assign) CLLocationCoordinate2D waypointCoordinates;

- (void)setAnnotationCoordinatesWithArray:(NSArray *)array;
- (void)setAnnotationTypeWithDictionary:(NSDictionary *)dictionary;
- (void)setTrackpointAnnotationTypeWithDictionary:(NSDictionary *)dictionary;

@end

@implementation WWTrackAnnotation

#pragma mark - Initializatios and Dealoccation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    self.imageURL = [NSURL URLWithString:dictionary[@"properties"][@"640"]];
    self.waypointsCoordinates = dictionary[@"geometry"][@"coordinates"];
    
    self.waypointTitle = dictionary[@"properties"][@"title"];
    self.annotationDescription = dictionary[@"properties"][@"notes"];
    
    [self setAnnotationTypeWithDictionary:dictionary];
    
    return self;
}

#pragma mark - Accessors

- (CLLocationCoordinate2D)coordinate {
    return self.waypointCoordinates;
}

- (NSString *)title {
    return self.waypointTitle;
}

- (NSString *)subtitle {
    return self.waypointTitle;
}

#pragma mark - Private

- (void)setAnnotationCoordinatesWithArray:(NSArray *)array {
    NSArray *startCoordinates = array.firstObject;
    
    self.startLatitude = startCoordinates.firstObject;
    self.startLongitude = startCoordinates.lastObject;
    
    CLLocationDegrees longitude = self.startLatitude.doubleValue;
    CLLocationDegrees latitude = self.startLongitude.doubleValue;
    CLLocationCoordinate2D noteCoordinates = CLLocationCoordinate2DMake(latitude, longitude);
    self.waypointCoordinates = noteCoordinates;
}

- (void)setAnnotationTypeWithDictionary:(NSDictionary *)dictionary {
    NSString *pointUndefinedType = dictionary[@"entity"];
    if ([pointUndefinedType isEqualToString:@"track"]) {
        [self setAnnotationCoordinatesWithArray:self.waypointsCoordinates];
        self.annotationType = WWMainWPAnnotationType;
    } else {
        [self setAnnotationCoordinatesWithArray:self.waypointsCoordinates];
        self.annotationType = WWPOIAnnotationType;
    }
}

- (void)setTrackpointAnnotationTypeWithDictionary:(NSDictionary *)dictionary {
    
}

//- (void)setTrackpointAnnotationTypeWithDictionary:(NSDictionary *)dictionary {
//    NSArray *annotationCoordinates = self.waypointsCoordinates;
//    NSNumber *mainWPCumDistance = dictionary[@"properties"][@"cum_distance"];
//    if (<#condition#>) {
//        <#statements#>
//    }
//    if ([dictionary[@"properties"][@"alt_route"]isEqualToString:@""]) {
//        [self setAnnotationCoordinatesWithArray:annotationCoordinates];
//        self.annotationType = WWMainTrackAnnotationType;
//    } else {
//        [self setAnnotationCoordinatesWithArray:annotationCoordinates];
//        self.annotationType = WWAlternateAnnotationType;
//    } else if (![dictionary[@"properties"][@"sidetrip"]isEqualToString:@""]) {
//        [self setAnnotationCoordinatesWithArray:annotationCoordinates];
//        self.annotationType = WWSidetripAnnotationType;
//    }
//}


@end
