//  Created by Sergiy Shevchuk on 8/29/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSTileOverlay.h"

@interface SSTileOverlay ()

@end

@implementation SSTileOverlay

- (void)loadTileAtPath:(MKTileOverlayPath)path
                result:(void (^)(NSData  *_Nullable, NSError  *_Nullable))result
{
    NSString *tileName = [NSString stringWithFormat:@"%ld_%ld_%ld.jpg",(long)path.z, (long)path.x,(long)path.y];
    NSString *tilesFolder = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/nsw-bmnp-sft"];
    NSString *tilePath = [tilesFolder stringByAppendingPathComponent:tileName];
    BOOL isTileExist = [[NSFileManager defaultManager] fileExistsAtPath:tilePath];
    
    if (!result) {
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), ^{
        NSData *tileData = nil;
        
        if (isTileExist) {
            tileData = [NSData dataWithContentsOfFile:tilePath
                                              options:NSDataReadingUncached
                                                error:NULL];
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
            
            UIGraphicsEndImageContext();
        }
        
        result(tileData,nil);
    });
}

@end
