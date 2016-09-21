//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWWeakyStrongyMacros.h"
#import "SSMapViewController.h"
#import "SSZipArchive.h"
#import "SSTileOverlay.h"

#import <ARSPopover/ARSPopover.h>
#import <CoreLocation/CoreLocation.h>
#import "WWBlockTypeDef.h"

#import "SSMapLayersView.h"
#import "WWAnnotationsContainer.h"
#import "WWAnnotationPoint.h"
#import "WWTrackAnnotation.h"

static NSString * const WWPOIAnnotationViewID = @"WWPOIAnnotationView";
static NSString * const WWMainWPAnnotationViewID = @"WWMainWPAnnotationView";
static NSString * const WWMainTrackAnnotationViewID = @"WWMainTrackAnnotationView";
static NSString * const WWSidetripsAnnotationViewID = @"WWSidetripsAnnotationView";
static NSString * const WWAlternateAnnotationViewID = @"WWAlternateAnnotationView";
static NSString * const WWImageAnnotationViewID = @"WWImageAnnotationView";


@interface SSMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;

@property (nonatomic, strong) NSArray    *customAnnotations;
@property (nonatomic, strong) NSString *tilesFolderPath;

@property (nonatomic, strong) NSArray   *mainTrackRoute;
@property (nonatomic, strong) NSArray   *sidetripsRoute;
@property (nonatomic, strong) NSArray   *alternatesRoute;
@property (nonatomic, strong) NSMutableArray    *layersState;

@property (nonatomic, copy) WWResultBlock   buttonSelectCompletion;

@property (nonatomic, strong) WWAnnotationsContainer *annotationsContainer;

- (void)reloadTileOverlay;
- (void)annotationLayersInitialisation;
- (void)unzipArchive;
- (void)initialiseLocationManager;
- (void)drawRoutesWith:(NSArray *)routesArray;
- (void)fillMapWithAnnotationLayers;
- (MKCoordinateSpan)checkZoomLevelWith:(MKCoordinateSpan)coordinatesSpan;

@end

@implementation SSMapViewController

#pragma mark - Initialisation and Dealoccation

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self unzipArchive];
        [self initialiseLocationManager];
        [self annotationLayersInitialisation];
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
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.008, 0.008);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    
    [mapView setRegion:region animated:YES];
    [self reloadTileOverlay];
    [self fillMapWithAnnotationLayers];

    mapView.showsUserLocation = YES;
    mapView.showsScale = YES;
    mapView.rotateEnabled = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - MKMapViewDelegate Methods

// Redner of the map tiles and routes

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    if ([overlay isKindOfClass:[MKTileOverlay class]]) {
        return [[MKTileOverlayRenderer alloc] initWithTileOverlay:overlay];
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *polyLineRender = [[MKPolylineRenderer alloc] initWithOverlay:overlay];
        UIColor *wayCilor = [UIColor blueColor];
        polyLineRender.strokeColor = wayCilor;
        polyLineRender.lineWidth = 3;
        return polyLineRender;
    }
    
    return nil;
}

// Automatic zoom between 10 and 18 levels
// Added
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D coordinates = mapView.region.center;
    MKCoordinateSpan zoomedValue = [self checkZoomLevelWith:mapView.region.span];
    MKCoordinateRegion zoomedRegion = MKCoordinateRegionMake(coordinates, zoomedValue);
    [mapView setRegion:zoomedRegion animated:YES];
}

#pragma mark - Annotations!!!!!!!!!!!!!!!!

#pragma mark - Private
// Added
- (void)reloadTileOverlay {
    self.tileOverlay = [[SSTileOverlay alloc] init];
    self.tileOverlay.canReplaceMapContent = YES;
    [self.mapView addOverlay:self.tileOverlay level:MKOverlayLevelAboveLabels];
}
// Added
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
// Added
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
// Added
- (void)        locationManager:(CLLocationManager *)manager
   didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse)
    {
        
    } else if (status == kCLAuthorizationStatusDenied)
    {
        
    }
}

// Added
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKPinAnnotationView *annoView = nil;
    if ([annotation isKindOfClass:[WWAnnotationPoint class]]) {
        WWAnnotationPoint *wayPoint = (WWAnnotationPoint *)annotation;
        switch (wayPoint.annotationType) {
            case WWPOIAnnotationType: {
                annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:WWPOIAnnotationViewID];
                annoView.pinTintColor = [UIColor whiteColor];
            }
                break;
                
            case WWMainWPAnnotationType: {
                annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:WWMainWPAnnotationViewID];
                annoView.pinTintColor = [UIColor blueColor];
            }
                break;
            case WWImageAnnotationType: {
                annoView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:WWImageAnnotationViewID];
                annoView.pinTintColor = [UIColor orangeColor];
            }
                break;
        }
    }
    
    return annoView;
}

#pragma mark - Annotations Initialisation

// Added
- (void)annotationLayersInitialisation {
    NSString *annotationsPath = [[NSBundle mainBundle] pathForResource:@"nsw-bmnp-sft" ofType:@"json"];
    NSData *rawJSON = [NSData dataWithContentsOfFile:annotationsPath];
    self.annotationsContainer = [WWAnnotationsContainer initContainerWithJSON:rawJSON];
}


// Added
- (NSArray *)mapRouteWithArray:(NSArray *)routesArray {
    NSMutableArray *returnedValue = [NSMutableArray array];
    for (WWTrackAnnotation *trackAnnotationPoint in routesArray) {
        if ([trackAnnotationPoint isKindOfClass:[WWTrackAnnotation class]]) {
            NSArray *poiCoordinates = trackAnnotationPoint.waypointsCoordinates;
            CLLocationCoordinate2D coordinates[poiCoordinates.count];
            NSInteger index = 0;
            for (NSArray *currentPoi in poiCoordinates) {
                NSNumber *longitude = currentPoi.firstObject;
                NSNumber *latitude = currentPoi.lastObject;
                CLLocationCoordinate2D pointsToUse = CLLocationCoordinate2DMake(latitude.doubleValue, longitude.doubleValue);
                
                coordinates[index] = pointsToUse;
                index++;
            }
            
            [returnedValue addObject:[MKPolyline polylineWithCoordinates:coordinates count:poiCoordinates.count]];
        }
    }
    
    return [returnedValue copy];
}

// Added
- (MKCoordinateSpan)checkZoomLevelWith:(MKCoordinateSpan)coordinatesSpan {
    double latitude = coordinatesSpan.latitudeDelta;
    MKCoordinateSpan returnedValue = coordinatesSpan;
    
    if (latitude < 0.004) {
        returnedValue = MKCoordinateSpanMake(0.004, 0.004);
    } else if (latitude > 0.8) {
        returnedValue = MKCoordinateSpanMake(0.8, 0.8);
    }
    
    return returnedValue;
}

#pragma mark - IBActions

- (IBAction)layersButton:(id)sender {
    ARSPopover *popoverController = [ARSPopover new];
    UIButton *button = sender;
    popoverController.sourceView = button;
    popoverController.sourceRect = CGRectMake(CGRectGetMidX(button.bounds), CGRectGetMaxY(button.bounds), 0, 0);
    popoverController.contentSize = CGSizeMake(145, 190);
    popoverController.arrowDirection = UIPopoverArrowDirectionUp;
    [self presentViewController:popoverController animated:YES completion:^{
        [popoverController insertContentIntoPopover:^(ARSPopover *popover, CGSize popoverPresentedSize, CGFloat popoverArrowHeight) {
            CGFloat originX = 0;
            CGFloat originY = 0;
            CGFloat width = popoverPresentedSize.width;
            CGFloat height = popoverPresentedSize.height - popoverArrowHeight;
            CGRect frame = CGRectMake(originX, originY, width, height);
            SSMapLayersView *mapLayers = [[SSMapLayersView alloc] initWithFrame:frame];
            
            [mapLayers setButtonsStateWith:self.layersState completion:self.buttonSelectCompletion];
            [popover.view addSubview:mapLayers];
        }];
    }];
}

- (IBAction)locationClicked:(id)sender {
    CLLocation *location = [CLLocationManager new].location;
    
    CLLocationCoordinate2D center = location.coordinate;
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.008, 0.008);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    
    [self.mapView setRegion:region animated:YES];
}

#pragma mark - Private

- (WWResultBlock)buttonSelectCompletion {
    WWWeakify(self);
    WWResultBlock completionBlock = ^(NSNumber *buttonTag) {
        WWStrongify(self);
        WWLayerButton layerNumber = buttonTag.integerValue;
        [self changeLayerState:layerNumber];
    };
    
    return completionBlock;
}

- (void)changeLayerState:(WWLayerButton)layerButton {
    NSNumber *layerState = self.layersState[layerButton];
    BOOL layerPathState = layerState.boolValue;
    if (layerPathState) {
        [self showPointsLayerWithIndex:layerButton];
    } else {
        [self hidePointsLayerWithIndex:layerButton];
    }
    [self.layersState replaceObjectAtIndex:layerButton withObject:@(!layerPathState)];
}

- (void)hidePointsLayerWithIndex:(NSInteger)layerIndex {
    MKMapView *mapView = self.mapView;
    switch (layerIndex) {
        case WWPOIButton:
        case WWMainWPButton:
        case WWImagesButton:
            [mapView removeAnnotations:[self.annotationsContainer annotationsWithAnnotationLayer:layerIndex]];
            [mapView reloadInputViews];
            break;
            
        case WWMainTrackButton:
            [mapView removeOverlays:self.mainTrackRoute];
            break;
            
        case WWSidetripsButton:
            [mapView removeOverlays:self.sidetripsRoute];
            break;
            
        case WWAlternatesButton:
            [mapView removeOverlays:self.alternatesRoute];
            break;
    }
}

- (void)showPointsLayerWithIndex:(NSInteger)layerIndex {
    MKMapView *mapView = self.mapView;
    switch (layerIndex) {
        case WWPOIButton:
        case WWMainWPButton:
        case WWImagesButton:
            [mapView addAnnotations:[self.annotationsContainer annotationsWithAnnotationLayer:layerIndex]];
            [mapView reloadInputViews];
            break;
            
        case WWMainTrackButton:
            [mapView addOverlays:self.mainTrackRoute];
            break;
            
        case WWSidetripsButton:
            [mapView addOverlays:self.sidetripsRoute];
            break;
            
        case WWAlternatesButton:
            [mapView addOverlays:self.alternatesRoute];
            break;
    }
}

- (void)fillMapWithAnnotationLayers {
    MKMapView *mapView = self.mapView;
    WWAnnotationsContainer *container = self.annotationsContainer;
    
    NSArray *mapLayersState = @[@(0), @(0), @(0), @(0), @(0), @(0)];
    self.layersState = [mapLayersState mutableCopy];
    
    [mapView addAnnotations:container.poiAnnotations];
    [mapView addAnnotations:container.mainWPAnnotations];
    [mapView addAnnotations:container.imageAnnotations];
    
    self.mainTrackRoute = [self mapRouteWithArray:container.mainTrackAnnotations];
    [mapView addOverlays:self.mainTrackRoute];
    self.sidetripsRoute = [self mapRouteWithArray:container.sidetripsAnnotations];
    [mapView addOverlays:self.sidetripsRoute];
    self.alternatesRoute = [self mapRouteWithArray:container.alternateAnnotations];
    [mapView addOverlays:self.alternatesRoute];
    
    NSArray *layersState = @[@(0), @(0), @(0), @(0), @(0), @(0)];
    self.layersState = [layersState mutableCopy];
}

@end
