//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "SSMapViewController.h"
#import "GridTileOverlay.h"
#import "GridTileOverlayRenderer.h"
#import "SSZipArchive.h"
#import "SSTileOverlay.h"
#import "SSTileOverlayRender.h"
#import "SSAnnotationsContainer.h"
#import "SSPhotoAnnoVIew.h"
#import <CoreLocation/CoreLocation.h>

static NSString * const SSPhotoAnnoViewIdentifier = @"SSPhotoAnnoVIew";

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

@end

@implementation SSMapViewController

#pragma mark - Initialisation and Dealoccation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self unzipArchive];
        [self initialiseLocationManager];
    }
    
    return self;
}

#pragma mark - UIViewController Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self annotationsInitialisation];
   
    MKMapView *mapView = self.mapView;
    mapView.delegate = self;
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollow];
    CLLocationDegrees latitude = -33.7039696858;
    CLLocationDegrees longitude = 150.2912592792;
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    
    [mapView setRegion:region animated:YES];
    
    mapView.showsCompass = YES;
    mapView.showsUserLocation = YES;
    
    [self reloadTileOverlay];
    
    NSArray *customAnnotations = self.customAnnotations;
    
    [mapView addAnnotations:customAnnotations];
    
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

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
}

#warning !!!!!!
#pragma mark - Annotations!!!!!!!!!!!!!!!!

// mapView:viewForAnnotation: provides the view for each annotation.
// This method may be called for all or some of the added annotations.
// For MapKit provided annotations (eg. MKUserLocation) return nil to use the MapKit provided annotation view.
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annoView = [mapView dequeueReusableAnnotationViewWithIdentifier:SSPhotoAnnoViewIdentifier];
    
    return annoView;
}

// mapView:didAddAnnotationViews: is called after the annotation views have been added and positioned in the map.
// The delegate can implement this method to animate the adding of the annotations views.
// Use the current positions of the annotation views as the destinations of the animation.

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray<MKAnnotationView *> *)views {
    
}

// mapView:annotationView:calloutAccessoryControlTapped: is called when the user taps on left & right callout accessory UIControls.

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    
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
    NSArray *annotations = [SSAnnotationsContainer initContainerWithJSON:rawJSON].annotations;
    
    self.customAnnotations = annotations;
}

@end
