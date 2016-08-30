//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSMapViewController.h"
#import "GridTileOverlay.h"
#import "GridTileOverlayRenderer.h"
#import "SSZipArchive.h"
#import "SSTileOverlay.h"
#import "SSTileOverlayRender.h"

@interface SSMapViewController () <MKMapViewDelegate>
@property (nonatomic, strong) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;

@property (nonatomic, strong) NSString *tilesFolderPath;

//- (void)reloadTileOverlay;
- (void)unzipArchive;

@end

@implementation SSMapViewController

#pragma mark - Initialisation and Dealoccation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self unzipArchive];
    }
    
    return self;
}

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKMapView *mapView = self.mapView;
    
    CLLocationDegrees latitude = -33.4316798442;
    CLLocationDegrees longitude = 151.2765980607;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    [mapView setRegion:region animated:YES];
    
//    // Coordinats grid
//    self.gridOverlay = [[GridTileOverlay alloc] init];
//    self.gridOverlay.canReplaceMapContent = NO;
//    [mapView addOverlay:self.gridOverlay level:MKOverlayLevelAboveLabels];
//
    self.tileOverlay = [[SSTileOverlay alloc] init];
    self.tileOverlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:self.tileOverlay level:MKOverlayLevelAboveLabels];
//    [self.mapView insertOverlay:self.tileOverlay belowOverlay:self.gridOverlay];
    
    mapView.delegate = self;
    
//    [self reloadTileOverlay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    
    return nil;
}

#pragma mark - Private

//- (void)reloadTileOverlay {
//    NSString *baseURL = [[[NSBundle mainBundle] bundleURL] absoluteString];
//    NSString *urlTemplate = [baseURL stringByAppendingString:@"{z}_{x}_{y}.jpg"];
//    
//    self.tileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:urlTemplate];
//    self.tileOverlay.canReplaceMapContent = YES;
//    [self.mapView insertOverlay:self.tileOverlay belowOverlay:self.gridOverlay];
//}

- (void)unzipArchive {
    NSString *archivePath = [[NSBundle mainBundle] pathForResource:@"ww_nsw-bwnp-gtpxx_maps" ofType:@"zip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.tilesFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/nsw-bwnp-gtpxx"];
    if (![fileManager fileExistsAtPath:self.tilesFolderPath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:self.tilesFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
        NSLog(@"%@", error);
    }
    [SSZipArchive unzipFileAtPath:archivePath toDestination:self.tilesFolderPath];
}

@end
