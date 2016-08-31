//  Created by Sergiy Shevchuk on 8/29/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSTileOverlay.h"

@interface SSTileOverlay ()

@end

@implementation SSTileOverlay

//- (NSURL *)URLForTilePath:(MKTileOverlayPath)path {
//    NSString *tileKey = [[NSString alloc] initWithFormat:@"%ld_%ld_%ld.jpg", (long)path.x, (long)path.y, (long)path.z];
//    
//    return [NSURL URLWithString:tileKey];
//}
//
//
//// NEW overloaded methods
//
//- (instancetype)initWithURLTemplate:(nullable NSString *)URLTemplate {
//    self = [super initWithURLTemplate:URLTemplate];
//    
//    
//    return self;
//}

- (void)loadTileAtPath:(MKTileOverlayPath)path
                result:(void (^)(NSData * _Nullable, NSError * _Nullable))result {
    
  
    
    NSLog(@"Loading tile in SSTileOverlay z/x/y: %ld/%ld/%ld", (long)path.z, (long)path.x, (long)path.y);
    NSString *tileName = [NSString stringWithFormat:@"%ld_%ld_%ld.jpg",(long)path.z, (long)path.x,(long)path.y];
    NSString *tilesFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/nsw-bmnp-sft"];
    NSString *tilePath = [tilesFolder stringByAppendingPathComponent:tileName];
    
    NSData *tileData;
    BOOL isTileExist = [[NSFileManager defaultManager] fileExistsAtPath:tilePath];
    NSLog(@"Is tile exist: %@", @(isTileExist));
    
    if (!result) {
        return;
    }
    
    if (isTileExist) {
        UIImage *tileImage = [[UIImage alloc] initWithContentsOfFile:tilePath];
//        UIImage *tileImage = [UIImage imageWithContentsOfFile:tilePath];
        tileData = UIImageJPEGRepresentation(tileImage, 1);
    } else {
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
        tileData = UIImagePNGRepresentation(tileImage);
    }
    
    result(tileData,nil);
}


@end
