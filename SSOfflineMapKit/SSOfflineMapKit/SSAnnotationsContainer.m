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

@interface SSAnnotationsContainer ()
@property (nonatomic, strong) NSMutableArray *mutablePoiAnnotations;
@property (nonatomic, strong) NSMutableArray *mutableMainWPAnnotations;
@property (nonatomic, strong) NSMutableArray *mutableMainTrackAnnotations;
@property (nonatomic, strong) NSMutableArray *mutableSidetripsAnnotations;
@property (nonatomic, strong) NSMutableArray *mutableAlternatesAnnotations;
@property (nonatomic, strong) NSMutableArray *mutableImagesAnnotations;

- (void)parseAnnotationJSON:(NSData *)annotationsJSON;

@end

@implementation SSAnnotationsContainer

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
        self.mutablePoiAnnotations = [NSMutableArray array];
        self.mutableMainWPAnnotations = [NSMutableArray array];
        self.mutableMainTrackAnnotations = [NSMutableArray array];
        self.mutableSidetripsAnnotations = [NSMutableArray array];
        self.mutableAlternatesAnnotations = [NSMutableArray array];
        self.mutableImagesAnnotations = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - Private

- (void)parseAnnotationJSON:(NSData *)annotationsJSON {
    NSError *parseError = nil;
    NSArray *annotations = [NSJSONSerialization JSONObjectWithData:annotationsJSON
                                                           options:NSJSONReadingMutableContainers
                                                             error:&parseError];
    for (NSDictionary *annotation in annotations) {
        
//        NSString *entityType = annotation[@"properties"][@"entity"];
//        if (entityType) {
        
//            WWAnnotationLayer layerType = [self entityOfAnnotationWith:annotation];
        
//            switch (layerType) {
//                case WWPOILayer:
//                {
////                    SSTrackNotesAnno *transportAnnotation = [SSTrackNotesAnno initNotesWith:annotation];
////                    [self.mutableTransport addObject:transportAnnotation];
//
//                }
//                    break;
//                    
//                case WWMainWPLayer:
//                {
////                    SSTrackNotesAnno *poiAnnotation = [SSTrackNotesAnno initNotesWith:annotation];
////                    [self.mutablePoi addObject:poiAnnotation];
//
//                }
//                    break;
//                    
//                case WWMainTrackLayer: {
////                    SSTrackNotesAnno *trackNotesAnnotation = [SSTrackNotesAnno initNotesWith:annotation];
////                    [self.mutableTrackPoints addObject:trackNotesAnnotation];
//                }
//                    break;
//                    
//                case WWSidetripsLayer: {
////                    SSAnnotationPoint *photoAnnotation = [SSAnnotationPoint initAnnotationWith:annotation];
////                    [self.mutablePhotos addObject:photoAnnotation];
//                }
//                    break;
//                    
//                case WWAlternatesLayer: {
//                    
//                }
//                    break;
//                    
//                case WWImagesLayer: {
//                    
//                }
//                    
//                default:
//                    break;
//            }
//}
//}

//- (WWAnnotationLayer)entityOfAnnotationWith:(NSDictionary *)notation {
//    if (<#condition#>) {
//        <#statements#>
//    }
//    NSDictionary *annoTypes = @{@"poi":[NSNumber numberWithInteger:WWPOILayer],
//                                @"image":[NSNumber numberWithInteger:WWImagesLayer],
//                                @"track":[NSNumber numberWithInteger:SStrackAnnotation]};
//    
//    NSNumber *annoEntity = annoTypes[annotationType];
//    
//    return annoEntity.integerValue;
//}

- (NSArray *)annotationsLayerWith:(WWAnnotationLayer)layer {
    
    return nil;
}

@end
