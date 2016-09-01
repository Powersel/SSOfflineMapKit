//
//  SSAnnotationPoint.m
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 8/31/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import "SSAnnotationPoint.h"

@interface SSAnnotationPoint () 
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString *annotationTitle;
@property (nonatomic, strong) NSString *annotationSubtitle;
@property (nonatomic, strong) NSNumber *annotationID;
@property (nonatomic, strong) NSNumber *annotationOrder;
@property (nonatomic, strong) NSURL    *image;

@end

@implementation SSAnnotationPoint

#pragma mark - Initialisation and Dealoccation

+ (instancetype)initAnnotationWith:(NSDictionary *)dictionary {
    SSAnnotationPoint *annotationPoint = [SSAnnotationPoint new];
    
    NSArray *coordinates = dictionary[@"geometry"][@"coordinates"];
    annotationPoint.coordinate = CLLocationCoordinate2DMake([coordinates.firstObject doubleValue], [coordinates.lastObject doubleValue]);
    annotationPoint.annotationTitle = dictionary[@"properties"][@"title"];
    annotationPoint.annotationOrder = dictionary[@"properties"][@"order"];
    annotationPoint.annotationID = dictionary[@"properties"][@"id"];
    annotationPoint.image = [NSURL URLWithString:dictionary[@"properties"][@"640"]];
    
    return annotationPoint;
}

#pragma mark - Accessors

@end
