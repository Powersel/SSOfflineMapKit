//  Created by Sergiy Shevchuk on 8/31/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSAnnotationPoint.h"

@interface SSAnnotationPoint () 
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSNumber *annotationID;
@property (nonatomic, strong) NSNumber *annotationOrder;
@property (nonatomic, strong) NSURL    *image;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *subName;

@end

@implementation SSAnnotationPoint

#pragma mark - Class Methods

+ (instancetype)initAnnotationWith:(NSDictionary *)dictionary {
    SSAnnotationPoint *annotationPoint = [SSAnnotationPoint new];
    
    NSArray *coordinates = dictionary[@"geometry"][@"coordinates"];
    annotationPoint.coordinate = CLLocationCoordinate2DMake([coordinates.firstObject doubleValue], [coordinates.lastObject doubleValue]);
    annotationPoint.name = dictionary[@"properties"][@"title"];
    annotationPoint.subName = dictionary[@"properties"][@"title"];
    annotationPoint.annotationOrder = dictionary[@"properties"][@"order"];
    annotationPoint.annotationID = dictionary[@"properties"][@"id"];
    annotationPoint.image = [NSURL URLWithString:dictionary[@"properties"][@"640"]];
    
    return annotationPoint;
}

#pragma mark - Accessors

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    _coordinate = newCoordinate;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.subName;
}

@end
