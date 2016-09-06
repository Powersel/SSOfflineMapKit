//
//  SSTransportAnnotations.h
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 9/6/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface SSTransportAnnotations : NSObject <MKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;


@end
