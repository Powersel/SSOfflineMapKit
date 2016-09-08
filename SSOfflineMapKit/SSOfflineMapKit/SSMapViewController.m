//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import "WWWeakyStrongyMacros.h"
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

#import <ARSPopover/ARSPopover.h>
#import <CoreLocation/CoreLocation.h>

#import "SSMapLayersView.h"

static NSString * const SSPhotoAnnoViewIdentifier = @"SSPhotoAnnoVIew";
static NSString * const SSTrackNotesViewIdentifier = @"SSTrackNotesView";

@interface SSMapViewController () <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) MKTileOverlay *tileOverlay;
@property (strong, nonatomic) MKTileOverlay *gridOverlay;

@property (nonatomic, strong) NSArray    *customAnnotations;
@property (nonatomic, strong) NSString *tilesFolderPath;

@property (nonatomic, strong) NSMutableArray    *layersState;

@property (nonatomic, copy) WWResultBlock   buttonSelectCompletion;

@property (nonatomic, strong) SSAnnotationsContainer *annotationsContainer;

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
    MKCoordinateSpan coordinateSpan = MKCoordinateSpanMake(0.008, 0.008);
    MKCoordinateRegion region = MKCoordinateRegionMake(center, coordinateSpan);
    
    [mapView setRegion:region animated:YES];
    [self reloadTileOverlay];
    
    SSAnnotationsContainer *container = self.annotationsContainer;
    [mapView addAnnotations:container.poiAnnotations];
    [mapView addAnnotations:container.photos];
    [mapView addAnnotations:container.trackPoints];
    [self drawRoutesWith:container.trackPoints];
    
    NSArray *layersState = @[@(0), @(0), @(0), @(0), @(0), @(0)];
    self.layersState = [layersState mutableCopy];
    
    mapView.showsCompass = YES;
    mapView.showsUserLocation = YES;
    mapView.showsScale = YES;
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

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    CLLocationCoordinate2D coordinates = mapView.region.center;
    MKCoordinateSpan zoomedValue = [self checkZoomLevelWith:mapView.region.span];
    MKCoordinateRegion zoomedRegion = MKCoordinateRegionMake(coordinates, zoomedValue);
    [mapView setRegion:zoomedRegion animated:YES];
}

#pragma mark - Annotations!!!!!!!!!!!!!!!!

- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annoView = nil;
    if ([annotation isKindOfClass:[SSTrackNotesAnno class]]) {
        annoView = [[SSTrackNotesView alloc] initWithAnnotation:annotation reuseIdentifier:SSTrackNotesViewIdentifier];
        annoView.image = [UIImage imageNamed:@"wayPoint"];
        annoView.canShowCallout = YES;
        
    } else if ([annotation isKindOfClass:[SSAnnotationPoint class]]) {
        annoView = [[SSPhotoAnnoVIew alloc] initWithAnnotation:annotation reuseIdentifier:SSPhotoAnnoViewIdentifier];
        annoView.canShowCallout = YES;
        annoView.image = [UIImage imageNamed:@"photoImage"];
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
    self.annotationsContainer = [SSAnnotationsContainer initContainerWithJSON:rawJSON];
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

- (WWResultBlock)buttonSelectCompletion {
    WWWeakify(self);
    WWResultBlock completionBlock = ^(NSNumber *buttonTag) {
        WWStrongify(self);
        WWLayerButtons layerNumber = buttonTag.integerValue;
        [self changeLayerState:layerNumber];
    };
    
    return completionBlock;
}

- (void)changeLayerState:(WWLayerButtons)layerButton {
    NSNumber *layerState = self.layersState[layerButton];
    BOOL layerPathState = layerState.boolValue;
    if (layerPathState) {
        [self showImages];
    } else {
        [self hideImages];
    }
    [self.layersState replaceObjectAtIndex:layerButton withObject:@(!layerPathState)];
}

- (void)hideImages {
    [self.mapView removeAnnotations:self.annotationsContainer.photos];
    [self.mapView reloadInputViews];
}

- (void)showImages {
    [self.mapView addAnnotations:self.annotationsContainer.photos];
    [self.mapView reloadInputViews];
}

@end
