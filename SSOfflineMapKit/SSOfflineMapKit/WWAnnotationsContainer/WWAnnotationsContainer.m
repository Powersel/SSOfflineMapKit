//
//  WWAnnotationsContainer.m
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 9/9/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import "WWAnnotationsContainer.h"
#import "WWAnnotationPoint.h"

@interface WWAnnotationsContainer ()
@property (nonatomic, strong) NSMutableArray *poiAnnotations;
@property (nonatomic, strong) NSMutableArray *mainWPAnnotations;
@property (nonatomic, strong) NSMutableArray *mainTrackAnnotations;
@property (nonatomic, strong) NSMutableArray *sidetripsAnnotations;
@property (nonatomic, strong) NSMutableArray *alternateAnnotations;
@property (nonatomic, strong) NSMutableArray *imageAnnotations;

- (void)parseAnnotationJSON:(NSData *)annotationsJSON;
- (NSMutableArray *)mutableArrayWithAnnotationsLayer:(WWAnnotationLayer)layerIndex;

@end

@implementation WWAnnotationsContainer

#pragma mark - Class Methods

+ (instancetype)initContainerWithJSON:(NSData *)annotationsJSON {
    WWAnnotationsContainer *container = [WWAnnotationsContainer new];
    [container parseAnnotationJSON:annotationsJSON];
    
    return container;
}

#pragma mark - Initialization and Dealoccation

- (instancetype)init {
    self = [super init];
    if (self) {
        self.poiAnnotations = [NSMutableArray array];
        self.mainWPAnnotations = [NSMutableArray array];
        self.mainTrackAnnotations = [NSMutableArray array];
        self.sidetripsAnnotations = [NSMutableArray array];
        self.alternateAnnotations = [NSMutableArray array];
        self.imageAnnotations = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Public

- (NSArray *)annotationsWithAnnotationLayer:(WWAnnotationLayer)layer {
    return [[self mutableArrayWithAnnotationsLayer:layer] copy];
}

#pragma mark - Private

- (void)parseAnnotationJSON:(NSData *)annotationsJSON {
    NSError *parseError = nil;
    NSArray *annotations = [NSJSONSerialization JSONObjectWithData:annotationsJSON
                                                           options:NSJSONReadingMutableContainers
                                                             error:&parseError];
    for (NSDictionary *annotation in annotations) {
        WWAnnotationPoint *annotationPoint = [WWAnnotationPoint annotationWithDictionary:annotation];
        if (annotationPoint) {
            NSInteger layerIndex = annotationPoint.annotationType;
            [[self mutableArrayWithAnnotationsLayer:layerIndex] addObject:annotationPoint];
        }
    }
}

- (NSMutableArray *)mutableArrayWithAnnotationsLayer:(WWAnnotationLayer)layerIndex {
    switch (layerIndex) {
        case WWPOIAnnotationType:
            return self.poiAnnotations;
        case WWMainWPAnnotationType:
            return self.mainWPAnnotations;
        case WWMainTrackAnnotationType:
            return self.mainTrackAnnotations;
        case WWSidetripAnnotationType:
            return self.sidetripsAnnotations;
        case WWAlternateAnnotationType:
            return self.alternateAnnotations;
        case WWImageAnnotationType:
            return self.imageAnnotations;
        default:
            return nil;
    }
}

@end
