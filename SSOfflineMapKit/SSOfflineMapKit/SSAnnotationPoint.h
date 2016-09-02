//
//  SSAnnotationPoint.h
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 8/31/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SSAnnotationPoint : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSNumber *annotationID;
@property (nonatomic, readonly) NSNumber *annotationOrder;

@property (nonatomic, readonly) NSURL    *image;

+ (instancetype)initAnnotationWith:(NSDictionary *)dictionary;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
