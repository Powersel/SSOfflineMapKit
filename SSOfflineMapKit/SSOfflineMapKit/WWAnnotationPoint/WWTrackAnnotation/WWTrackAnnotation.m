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
@property (nonatomic, strong) NSMutableArray    *mutableWaypointAnnotations;
@property (nonatomic, strong) NSMutableArray    *mutableMainAnnotations;

@property (nonatomic, strong) NSNumber    *startLatitude;
@property (nonatomic, strong) NSNumber    *startLongitude;

@property (nonatomic, strong) NSString    *waypointTitle;
@property (nonatomic, strong) NSString    *annotationDescription;

@property (nonatomic, strong) NSURL       *imageURL;

@property (nonatomic, assign) CLLocationCoordinate2D waypointCoordinates;

- (void)setAnnotationCoordinatesWithArray:(NSDictionary *)dictionary;
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

- (void)setAnnotationCoordinatesWithArray:(NSDictionary *)dictionary {
    self.startLatitude = dictionary[@"properties"][@"start_lat"];
    self.startLongitude = dictionary[@"properties"][@"Start_long"];
    
    CLLocationDegrees longitude = self.startLongitude.doubleValue;
    CLLocationDegrees latitude = self.startLatitude.doubleValue;
    CLLocationCoordinate2D noteCoordinates = CLLocationCoordinate2DMake(latitude, longitude);
    self.waypointCoordinates = noteCoordinates;
}

- (void)setAnnotationTypeWithDictionary:(NSDictionary *)dictionary {
    NSString *annotationUndefinedType = dictionary[@"properties"][@"entity"];
    if ([annotationUndefinedType isEqualToString:@"poi"]) {
    [self setAnnotationCoordinatesWithArray:dictionary];
    self.annotationType = WWPOIAnnotationType;
    }
    if ([annotationUndefinedType isEqualToString:@"track"]) {
        [self setTrackpointAnnotationTypeWithDictionary:dictionary];
    }
}

- (void)setTrackpointAnnotationTypeWithDictionary:(NSDictionary *)dictionary {
        if ([dictionary[@"properties"][@"alt_route"]isEqualToString:@""]) {
            [self setAnnotationCoordinatesWithArray:dictionary];
            self.annotationType = WWMainTrackAnnotationType;
        } else {
            [self setAnnotationCoordinatesWithArray:dictionary];
            self.annotationType = WWAlternateAnnotationType;
        }
        if (![dictionary[@"properties"][@"sidetrip"]isEqualToString:@""]) {
            [self setAnnotationCoordinatesWithArray:dictionary];
            self.annotationType = WWSidetripAnnotationType;
        }
}

@end
