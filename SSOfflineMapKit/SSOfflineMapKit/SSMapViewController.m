//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSMapViewController.h"
#import "GridTileOverlay.h"
#import "GridTileOverlayRenderer.h"

#import "SSTileOverlay.h"
#import "SSTileOverlayRender.h"

@interface SSMapViewController () <MKMapViewDelegate>
@property (nonatomic, strong) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;

- (void)reloadTileOverlay;

@end

@implementation SSMapViewController

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKMapView *mapView = self.mapView;
    
    CLLocationDegrees latitude = -33.6168364247;
    CLLocationDegrees longitude = 151.1298788992;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.2, 0.2);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    [mapView setRegion:region];
    
//    // Coordinats grid
    self.gridOverlay = [[GridTileOverlay alloc] init];
    self.gridOverlay.canReplaceMapContent = NO;
    [mapView addOverlay:self.gridOverlay level:MKOverlayLevelAboveLabels];
//
//    self.tileOverlay = [[SSTileOverlay alloc] init];
//    self.tileOverlay.canReplaceMapContent = YES;
//    [self.mapView insertOverlay:self.tileOverlay belowOverlay:self.gridOverlay];
    
    mapView.delegate = self;
    
    [self reloadTileOverlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate Methods

//- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView {
//    NSArray *tiles = mapView.overlays;
//    
//}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    MKTileOverlay *customOverlay = (MKTileOverlay *)overlay;
    
//    MKTileOverlayRenderer *renderedTile = [[SSTileOverlayRender alloc] initWithTileOldOverlay:overlay];;
    MKTileOverlayRenderer *renderer = [[GridTileOverlayRenderer alloc] initWithTileOverlay:overlay];;
    
    return renderer;
}

#pragma mark - Private

- (void)reloadTileOverlay {
    NSString *baseURL = [[[NSBundle mainBundle] bundleURL] absoluteString];
    NSString *urlTemplate = [baseURL stringByAppendingString:@"{z}_{x}_{y}.jpg"];
    
    self.tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:urlTemplate];
    self.tileOverlay.canReplaceMapContent = YES;
    [self.mapView insertOverlay:self.tileOverlay belowOverlay:self.gridOverlay];}

@end
