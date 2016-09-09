//  Created by Sergiy Shevchuk on 9/8/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWImageAnnotation.h"

@interface WWImageAnnotation ()
@property (nonatomic, strong) NSURL    *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *subName;

@property (nonatomic, assign) CLLocationCoordinate2D imageCoordinates;

@end

@implementation WWImageAnnotation

#pragma mark - Initialisation and Dealoccation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super initWithDictionary:dictionary];
    
    NSNumber *latitude = dictionary[@"properties"][@"lat"];
    NSNumber *longitude = dictionary[@"properties"][@"long"];
    self.imageCoordinates = CLLocationCoordinate2DMake(latitude.doubleValue ,longitude.doubleValue);
    self.name = dictionary[@"properties"][@"title"];
    self.subName = dictionary[@"properties"][@"title"];
    self.image = [NSURL URLWithString:dictionary[@"properties"][@"640"]];
    self.annotationType = WWImageAnnotationType;
    
    return self;
}

#pragma mark - Acessors

- (CLLocationCoordinate2D)coordinate {
    return self.imageCoordinates;
}

- (NSString *)title {
    return self.name;
}

- (NSString *)subtitle {
    return self.subName;
}

@end
