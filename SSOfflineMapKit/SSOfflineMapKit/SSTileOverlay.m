//  Created by Sergiy Shevchuk on 8/29/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSTileOverlay.h"

@interface SSTileOverlay ()

@end

@implementation SSTileOverlay

- (NSURL *)URLForTilePath:(MKTileOverlayPath)path {
    NSString *tileKey = [[NSString alloc] initWithFormat:@"%ld_%ld_%ld.jpg", (long)path.x, (long)path.y, (long)path.z];
    
    return [NSURL URLWithString:tileKey];
}


// NEW overloaded methods

- (instancetype)initWithURLTemplate:(nullable NSString *)URLTemplate {
    self = [super initWithURLTemplate:URLTemplate];
    
    
    return self;
}

- (void)loadTileAtPath:(MKTileOverlayPath)path
                result:(void (^)(NSData * _Nullable, NSError * _Nullable))result {
    NSLog(@"Loading tile x/y/z: %ld/%ld/%ld",(long)path.x,(long)path.y,(long)path.z);
    
    if (!result) {
        return;
    }
    
    
    CGSize sz = self.tileSize;
    CGRect rect = CGRectMake(0, 0, sz.width, sz.height);
    UIGraphicsBeginImageContext(sz);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(ctx, 1.0);
    CGContextStrokeRect(ctx, CGRectMake(0, 0, sz.width, sz.height));
    NSString *text = [NSString stringWithFormat:@"X=%ld\nY=%ld\nZ=%ld",(long)path.x,(long)path.y,(long)path.z];
    [text drawInRect:rect withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:20.0],
                                           NSForegroundColorAttributeName:[UIColor blackColor]}];
    UIImage *tileImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSData *tileData = UIImagePNGRepresentation(tileImage);
    result(tileData,nil);
}


@end
