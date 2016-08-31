//
//  SSAnnotationPoint.h
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 8/31/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface SSAnnotationPoint : NSObject
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
