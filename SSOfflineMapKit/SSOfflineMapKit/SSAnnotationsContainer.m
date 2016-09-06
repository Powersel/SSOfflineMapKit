//
//  SSAnnotationsContainer.m
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 9/1/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import "SSAnnotationsContainer.h"
#import "SSAnnotationPoint.h"
#import "SSTrackNotesAnno.h"

typedef NS_ENUM(NSUInteger, SSAnnotationType) {
    SSTransportAnnotaion,
    SSPoiAnnotation,
    SStrackAnnotation,
    SSPhotoAnnotation
};

@interface SSAnnotationsContainer ()
@property (nonatomic, strong) NSMutableArray *mutableTrackAnnotations;

@property (nonatomic, strong) NSMutableArray *mutablePhotos;
@property (nonatomic, strong) NSMutableArray *mutablePoi;
@property (nonatomic, strong) NSMutableArray *mutableTrackPoints;
@property (nonatomic, strong) NSMutableArray *mutableTransport;

- (void)parseAnnotationJSON:(NSData *)annotationsJSON;

@end

@implementation SSAnnotationsContainer

@dynamic trackAnnotations;

@dynamic photos;
@dynamic poiAnnotations;
@dynamic trackPoints;
@dynamic transport;

#pragma mark - Class Methods

+ (instancetype)initContainerWithJSON:(NSData *)annotationsJSON {
    SSAnnotationsContainer *container = [SSAnnotationsContainer new];
    [container parseAnnotationJSON:annotationsJSON];
    
    return container;
}

#pragma mark - Initialization and Dealoccation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableTrackAnnotations = [NSMutableArray array];
        
        self.mutablePoi = [NSMutableArray array];
        self.mutablePhotos = [NSMutableArray array];
        self.mutableTransport = [NSMutableArray array];
        self.mutableTrackPoints = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Accessors

- (NSArray *)trackAnnotations {
    return [self.mutableTrackAnnotations copy];
}

- (NSArray *)photos {
    return [self.mutablePhotos copy];
}

- (NSArray *)poiAnnotations {
    return [self.mutablePoi copy];
}

- (NSArray *)trackPoints {
    return [self.mutableTrackPoints copy];
}

- (NSArray *)transport {
    return [self.mutableTransport copy];
}

#pragma mark - Private

- (void)parseAnnotationJSON:(NSData *)annotationsJSON {
    NSError *parseError = nil;
    NSArray *annotations = [NSJSONSerialization JSONObjectWithData:annotationsJSON
                                                           options:NSJSONReadingMutableContainers
                                                             error:&parseError];
    for (NSDictionary *annotation in annotations) {
        NSString *entityType = annotation[@"properties"][@"entity"];
        if (entityType) {
            SSAnnotationType annoType = [self entityOfAnnotationWith:entityType];
            
            switch (annoType) {
                case SSTransportAnnotaion:
                {
                    SSTrackNotesAnno *transportAnnotation = [SSTrackNotesAnno initNotesWith:annotation];
                    [self.mutableTransport addObject:transportAnnotation];

                }
                    break;
                    
                case SSPoiAnnotation:
                {
                    SSTrackNotesAnno *poiAnnotation = [SSTrackNotesAnno initNotesWith:annotation];
                    [self.mutablePoi addObject:poiAnnotation];

                }
                    break;
                    
                case SStrackAnnotation: {
                    SSTrackNotesAnno *trackNotesAnnotation = [SSTrackNotesAnno initNotesWith:annotation];
                    [self.mutableTrackPoints addObject:trackNotesAnnotation];
                }
                    break;
                    
                case SSPhotoAnnotation: {
                    SSAnnotationPoint *photoAnnotation = [SSAnnotationPoint initAnnotationWith:annotation];
                    [self.mutablePhotos addObject:photoAnnotation];
                }
                    break;
                    
                    
                default:
                    break;
            }
        }
    }
}

- (SSAnnotationType)entityOfAnnotationWith:(NSString *)annotationType {
    NSDictionary *annoTypes = @{@"image":[NSNumber numberWithInteger:SSPhotoAnnotation],
                                @"transport":[NSNumber numberWithInteger:SSTransportAnnotaion],
                                @"poi":[NSNumber numberWithInteger:SSPoiAnnotation],
                                @"track":[NSNumber numberWithInteger:SStrackAnnotation]};
    
    NSNumber *annoEntity = annoTypes[annotationType];
    
    return annoEntity.integerValue;
}

@end
