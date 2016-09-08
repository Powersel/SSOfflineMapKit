//  Created by Sergiy Shevchuk on 9/1/16.
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

@interface SSAnnotationsContainer : NSObject
@property (nonatomic, readonly) NSArray *photos;
@property (nonatomic, readonly) NSArray *poiAnnotations;
@property (nonatomic, readonly) NSArray *trackPoints;
@property (nonatomic, readonly) NSArray *transport;

//@property (nonatomic, readonly) NSArray *poiAnnotations;
//@property (nonatomic, readonly) NSArray *mainWPAnnotations;
//@property (nonatomic, readonly) NSArray *mainTrackAnnotations;
//@property (nonatomic, readonly) NSArray *sidepointAnnotations;
//@property (nonatomic, readonly) NSArray *alternatesAnnotations;
//@property (nonatomic, readonly) NSArray *imagesAnnotations;

+ (instancetype)initContainerWithJSON:(NSData *)annotationsJSON;

- (NSArray *)annotationsLayerWith:(WWAnnotationLayer)layer;

@end
