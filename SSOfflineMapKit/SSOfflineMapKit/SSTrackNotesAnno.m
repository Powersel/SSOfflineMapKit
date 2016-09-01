//  Created by Sergiy Shevchuk on 9/1/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSTrackNotesAnno.h"

@interface SSTrackNotesAnno ()
@property (nonatomic, strong)   NSURL   *imageURL;

@property (nonatomic, strong) NSArray *bboxCoordinates;
@property (nonatomic, strong) NSArray *coordinates;

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
    trackNotes.coordinates = dictionary[@"geometry"][@"coordinates"];
    
    trackNotes.noteType = dictionary[@"properties"][@"entity"];
    trackNotes.noteTypeSub = dictionary[@"properties"][@"entity_sub"];
    trackNotes.noteTitle = dictionary[@"properties"][@"title"];
    trackNotes.notesText = dictionary[@"properties"][@"notes"];
    trackNotes.geometryType = dictionary[@"geometry"][@"type"];
    
    trackNotes.day = dictionary[@"properties"][@"day"];
    trackNotes.startLatitude = dictionary[@"properties"][@"start_lat"];
    trackNotes.startLongitude = dictionary[@"properties"][@"Start_long"];
    trackNotes.endLatitude = dictionary[@"properties"][@"end_lat"];
    trackNotes.ednLongitude = dictionary[@"properties"][@"end_long"];
    
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
