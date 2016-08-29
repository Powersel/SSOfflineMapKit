//
//  SSTileOverlayRender.h
//  SSOfflineMapKit
//
//  Created by Sergiy Shevchuk on 8/29/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SSTileOverlayRender : MKTileOverlayRenderer

- (instancetype)initWithTileOldOverlay:(id <MKOverlay>)overlay;

@end
