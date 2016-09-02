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
    SSPhotoAnnotation = 3,
    SSTrackNoteAnnotation
};

@interface SSAnnotationsContainer ()
@property (nonatomic, strong) NSMutableArray *mutableTrackAnnotations;

- (void)parseAnnotationJSON:(NSData *)annotationsJSON;

@end

@implementation SSAnnotationsContainer

@dynamic trackAnnotations;

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
    }
    
    return self;
}

#pragma mark - Accessors

- (NSArray *)trackAnnotations {
    return [self.mutableTrackAnnotations copy];
}

#pragma mark - Private

- (void)parseAnnotationJSON:(NSData *)annotationsJSON {
    NSError *parseError = nil;
    NSArray *annotations = [NSJSONSerialization JSONObjectWithData:annotationsJSON
                                                           options:NSJSONReadingMutableContainers
                                                             error:&parseError];
    for (NSDictionary *annotation in annotations) {
        switch (annotation.allKeys.count) {
            case SSPhotoAnnotation:
            {
                SSAnnotationPoint *photoAnnotation = [SSAnnotationPoint initAnnotationWith:annotation];
                [self.mutableTrackAnnotations addObject:photoAnnotation];
            }
                break;
                
            case SSTrackNoteAnnotation:
            {
                SSTrackNotesAnno *trackNotesAnnotation = [SSTrackNotesAnno initNotesWith:annotation];
                [self.mutableTrackAnnotations addObject:trackNotesAnnotation];
            }
                
                break;
                
            default:
                break;
        }
    }
}

@end
