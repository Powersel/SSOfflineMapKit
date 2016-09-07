//  Created by Sergiy Shevchuk on 8/26/16.
//  Copyright © 2016 Sergiy Shevchuk. All rights reserved.

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

typedef NS_ENUM(NSUInteger, WWLayerButtons) {
    WWPOIButton = 0,
    WWMainWPButton,
    WWMainTrackButton,
    WWSidetripsButton,
    WWAlternatesButton,
    WWImagesButton
};

@interface SSMapViewController : UIViewController
@property (strong, nonatomic) IBOutlet MKMapView *mapView;

- (IBAction)layersButton:(id)sender;

@end
