//  Created by Sergiy Shevchuk on 9/1/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SSTrackNotesAnno : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@property (nonatomic, readonly)   NSURL   *imageURL;

@property (nonatomic, readonly) NSArray *bboxCoordinates;
@property (nonatomic, readonly) NSArray *pointsCoordinates;

@property (nonatomic, readonly) NSString    *noteType;
@property (nonatomic, readonly) NSString    *noteTypeSub;
@property (nonatomic, readonly) NSString    *noteTitle;
@property (nonatomic, readonly) NSString    *notesText;
@property (nonatomic, readonly) NSString    *geometryType;

@property (nonatomic, readonly)   NSNumber    *day;

@property (nonatomic, readonly) NSNumber    *startLatitude;
@property (nonatomic, readonly) NSNumber    *startLongitude;
@property (nonatomic, readonly) NSNumber    *endLatitude;
@property (nonatomic, readonly) NSNumber    *ednLongitude;

+ (instancetype)initNotesWith:(NSDictionary *)dictionary;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
