//
//  SSAnnotationsContainer.m
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 9/1/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import "SSAnnotationsContainer.h"
#import "SSAnnotationPoint.h"

typedef NS_ENUM(NSUInteger, SSAnnotationType) {
    SSPhotoAnnotation = 3,
    SSTrackNoteAnnotation
};

@interface SSAnnotationsContainer ()
@property (nonatomic, strong) NSMutableArray *mutablePhotoAnnotations;
@property (nonatomic, strong) NSMutableArray *mutableTrackNotesAnnotations;

- (void)parseAnnotationJSON:(NSData *)annotationsJSON;

@end

@implementation SSAnnotationsContainer

@dynamic photoAnnotations;
@dynamic trackNotesAnnotations;

#pragma mark - Class Methods

+ (instancetype)initWithJSON:(NSData *)annotationsJSON {
    SSAnnotationsContainer *container = [SSAnnotationsContainer new];
    
    return container;
}

#pragma mark - Initialization and Dealoccation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutablePhotoAnnotations = [NSMutableArray array];
        self.mutableTrackNotesAnnotations = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Accessors

- (NSArray *)trackNotesAnnotations {
    return [self.mutableTrackNotesAnnotations copy];
}

- (NSArray *)photoAnnotations {
    return [self.mutablePhotoAnnotations copy];
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
                [self.mutablePhotoAnnotations addObject:photoAnnotation];
            }
                break;
                
            case SSTrackNoteAnnotation:
                
                break;
                
            default:
                break;
        }
    }
}

@end
