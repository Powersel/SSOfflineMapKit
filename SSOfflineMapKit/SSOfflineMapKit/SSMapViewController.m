//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSMapViewController.h"
#import "GridTileOverlay.h"
#import "GridTileOverlayRenderer.h"

@interface SSMapViewController () <MKMapViewDelegate>
@property (nonatomic, strong) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;

- (void)reloadTileOverlay;

@end

@implementation SSMapViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
        self.gridOverlay = [[GridTileOverlay alloc] init];
        self.gridOverlay.canReplaceMapContent=NO;
        [self.mapView addOverlay:self.gridOverlay level:MKOverlayLevelAboveLabels];
    
    [self reloadTileOverlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MapKit Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKTileOverlayRenderer *renderer = [[GridTileOverlayRenderer alloc] initWithTileOverlay:overlay];;
    
    return renderer;
}

- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray<MKOverlayRenderer *> *)renderers {
    
}

#pragma mark - Private

- (void)reloadTileOverlay {
    NSString *baseURL = [[[NSBundle mainBundle] bundleURL] absoluteString];
    NSString *urlTemplate = [baseURL stringByAppendingString:@"/ww_nsw-bmnp-sft_maps/{z}/{x}/{y}.jpg"];
    
    self.tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:urlTemplate];
    self.tileOverlay.canReplaceMapContent=YES;
    [self.mapView insertOverlay:self.tileOverlay belowOverlay:self.gridOverlay];}

@end
