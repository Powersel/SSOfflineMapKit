//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSMapViewController.h"
#import "GridTileOverlay.h"
#import "GridTileOverlayRenderer.h"
#import "SSZipArchive.h"
#import "SSTileOverlay.h"
#import "SSTileOverlayRender.h"
#import "SSAnnotationsContainer.h"

#import "SSAnnotationPoint.h"
#import "SSTrackNotesAnno.h"

#import "SSPhotoAnnoVIew.h"
#import "SSTrackNotesView.h"

#import <CoreLocation/CoreLocation.h>

static NSString * const SSPhotoAnnoViewIdentifier = @"SSPhotoAnnoVIew";
static NSString * const SSTrackNotesViewIdentifier = @"SSTrackNotesView";

@interface SSMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;


@property (nonatomic, assign) CFMutableDictionaryRef mapLine2View;   // MKPolyline(route line) -> MKPolylineView(route view)
@property (nonatomic, assign) CFMutableDictionaryRef mapName2Line;   // NSString(name) -> MKPolyline(route line)

@property (nonatomic, strong) NSArray    *customAnnotations;
@property (nonatomic, strong) NSString *tilesFolderPath;

- (void)reloadTileOverlay;
- (void)annotationsInitialisation;
- (void)unzipArchive;
- (void)initialiseLocationManager;
- (void)drawRoutesWith:(NSArray *)routesArray;

@end

@implementation SSMapViewController

#pragma mark - Initialisation and Dealoccation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self unzipArchive];
        [self initialiseLocationManager];
        [self annotationsInitialisation];
    }
    
    return self;
}

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MKMapView *mapView = self.mapView;
    mapView.delegate = self;
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    CLLocationDegrees latitude = -33.7039696858;
    CLLocationDegrees longitude = 150.2912592792;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.075, 0.075);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    
    [mapView setRegion:region animated:YES];
    
    mapView.showsCompass = YES;
    mapView.showsUserLocation = YES;
    
    [self reloadTileOverlay];
    [mapView addAnnotations:self.customAnnotations];
    [self drawRoutesWith:self.customAnnotations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate Methods

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *polyLineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        polyLineRender.strokeColor = [UIColor yellowColor];
        return polyLineRender;
    }
    
    return nil;
}

#pragma mark - Annotations!!!!!!!!!!!!!!!!

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annoView = nil;
    if ([annotation isKindOfClass:[SSTrackNotesView class]]) {
        annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:SSTrackNotesViewIdentifier];
    }
    
    if ([annotation isKindOfClass:[SSAnnotationPoint class]]) {
        annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:SSPhotoAnnoViewIdentifier];
    }
    
    return annoView;
}

#pragma mark - Private

- (void)reloadTileOverlay {
    self.tileOverlay = [[SSTileOverlay alloc] init];
    self.tileOverlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:self.tileOverlay level:MKOverlayLevelAboveLabels];
}

- (void)unzipArchive {
    NSString *archivePath = [[NSBundle mainBundle] pathForResource:@"ww_nsw-bmnp-sft_maps" ofType:@"zip"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    self.tilesFolderPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/nsw-bmnp-sft"];
    if (![fileManager fileExistsAtPath:self.tilesFolderPath]) {
        NSError *error = nil;
        [fileManager createDirectoryAtPath:self.tilesFolderPath withIntermediateDirectories:NO attributes:nil error:&error];
        NSLog(@"%@", error);
    }
    [SSZipArchive unzipFileAtPath:archivePath toDestination:self.tilesFolderPath];
}

- (void)initialiseLocationManager {
    self.locationManager = [CLLocationManager new];
    
    CLLocationManager *locationManager = self.locationManager;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager requestAlwaysAuthorization];
    [locationManager setDelegate:self];
    [locationManager startUpdatingLocation];
}

#pragma mark - Delegates Methods

- (void)        locationManager:(CLLocationManager *)manager
   didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        
    } else if (status == kCLAuthorizationStatusDenied)
    {
        
    }
}

#pragma mark - Annotations Initialisation

- (void)annotationsInitialisation {
    NSString *annotationsPath = [[NSBundle mainBundle] pathForResource:@"nsw-bmnp-sft" ofType:@"json"];
    NSData *rawJSON = [NSData dataWithContentsOfFile:annotationsPath];
    NSArray *annotations = [SSAnnotationsContainer initContainerWithJSON:rawJSON].trackAnnotations;
    
    self.customAnnotations = annotations;
}

- (void)drawRoutesWith:(NSArray *)routesArray {
    for (SSTrackNotesAnno *trackAnnotationPoint in routesArray) {
        if ([trackAnnotationPoint isKindOfClass:[SSTrackNotesAnno class]]) {
            NSArray *poiCoordinates = trackAnnotationPoint.pointsCoordinates;
            CLLocationCoordinate2D coordinates[poiCoordinates.count];
            NSInteger index = 0;
            for (NSArray *currentPoi in poiCoordinates) {
                NSNumber *longitude = currentPoi.firstObject;
                NSNumber *latitude = currentPoi.lastObject;
                CLLocationCoordinate2D pointsToUse = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                
                coordinates[index] = pointsToUse;
                index++;
            }
            
            MKPolyline *polyLine = [MKPolyline polylineWithCoordinates:coordinates count:poiCoordinates.count];
            [self.mapView addOverlay:polyLine];
            
        }
    }
}

@end
