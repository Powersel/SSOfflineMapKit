//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWAnnotationPoint.h"

@interface WWTrackAnnotation : WWAnnotationPoint
@property (nonatomic, readonly) NSArray *waypointsCoordinates;

@property (nonatomic, readonly) NSString    *annotationDescription;
@property (nonatomic, readonly) NSURL       *imageURL;

@end
