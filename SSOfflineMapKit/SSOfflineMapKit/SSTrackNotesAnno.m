//  Created by Sergiy Shevchuk on 9/1/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSTrackNotesAnno.h"

@interface SSTrackNotesAnno ()
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong)   NSURL   *imageURL;

@property (nonatomic, strong) NSArray *bboxCoordinates;
@property (nonatomic, strong) NSArray *pointsCoordinates;

@property (nonatomic, strong) NSString    *noteType;
@property (nonatomic, strong) NSString    *noteTypeSub;
@property (nonatomic, strong) NSString    *noteTitle;
@property (nonatomic, strong) NSString    *notesText;
@property (nonatomic, strong) NSString    *geometryType;

@property (nonatomic, strong) NSNumber    *day;
@property (nonatomic, strong) NSNumber    *startLatitude;
@property (nonatomic, strong) NSNumber    *startLongitude;
@property (nonatomic, strong) NSNumber    *endLatitude;
@property (nonatomic, strong) NSNumber    *ednLongitude;

@end

@implementation SSTrackNotesAnno

#pragma mark - Class Methods

+ (instancetype)initNotesWith:(NSDictionary *)dictionary {
    SSTrackNotesAnno *trackNotes = [SSTrackNotesAnno new];
    
    trackNotes.imageURL = [NSURL URLWithString:dictionary[@"properties"][@"640"]];
    trackNotes.bboxCoordinates = dictionary[@"bbox"];
    NSArray *coords = dictionary[@"geometry"][@"coordinates"];
    trackNotes.pointsCoordinates = [coords[0] isKindOfClass:[NSNumber class]] ? @[coords] : coords;;
    trackNotes.noteType = dictionary[@"properties"][@"entity"];
    trackNotes.noteTypeSub = dictionary[@"properties"][@"entity_sub"];
    trackNotes.noteTitle = dictionary[@"properties"][@"title"];
    trackNotes.notesText = dictionary[@"properties"][@"notes"];
    trackNotes.geometryType = dictionary[@"geometry"][@"type"];
    trackNotes.day = dictionary[@"properties"][@"day"];
    
    NSArray *wayPointStartCoordinates = trackNotes.pointsCoordinates.firstObject;
    
    trackNotes.startLatitude = wayPointStartCoordinates.firstObject;
    trackNotes.startLongitude = wayPointStartCoordinates.lastObject;
    CLLocationDegrees longitude = trackNotes.startLatitude.doubleValue;
    CLLocationDegrees latitude = trackNotes.startLongitude.doubleValue;
    CLLocationCoordinate2D noteCoordinates = CLLocationCoordinate2DMake(latitude, longitude);
    
    NSArray *wayPointLastCoordinates = nil;
    if (trackNotes.pointsCoordinates.count > 1) {
        wayPointLastCoordinates = trackNotes.pointsCoordinates.lastObject;
    }
    
    if (wayPointLastCoordinates) {
        trackNotes.endLatitude = wayPointLastCoordinates.firstObject;
        trackNotes.ednLongitude = wayPointLastCoordinates.lastObject;
    }
    trackNotes.coordinate = noteCoordinates;
    
    return trackNotes;
}

#pragma mark - Accessors

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (NSString *)title {
    return self.noteTitle;
}

- (NSString *)subtitle {
    return self.noteTypeSub;
}

@end
