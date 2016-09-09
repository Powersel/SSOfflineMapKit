//  Created by Sergiy Shevchuk on 9/9/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, WWAnnotationLayer) {
    WWPOILayer = 0,
    WWMainWPLayer,
    WWMainTrackLayer,
    WWSidetripsLayer,
    WWAlternatesLayer,
    WWImagesLayer
};

@interface WWAnnotationsContainer : NSObject
@property (nonatomic, readonly) NSMutableArray *poiAnnotations;
@property (nonatomic, readonly) NSMutableArray *mainWPAnnotations;
@property (nonatomic, readonly) NSMutableArray *mainTrackAnnotations;
@property (nonatomic, readonly) NSMutableArray *sidetripsAnnotations;
@property (nonatomic, readonly) NSMutableArray *alternateAnnotations;
@property (nonatomic, readonly) NSMutableArray *imageAnnotations;

+ (instancetype)initContainerWithJSON:(NSData *)annotationsJSON;

- (NSArray *)annotationsWithAnnotationLayer:(WWAnnotationLayer)layer;

@end
