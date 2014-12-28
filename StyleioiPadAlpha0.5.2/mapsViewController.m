//
//  mapsViewController.m
//  StyleioiPadAlpha0.4.1
//
//  Created by admin on 2012-11-19.
//  Copyright (c) 2012 Styleio. All rights reserved.
//

#import "mapsViewController.h"

@interface mapsViewController ()

@end

@implementation mapsViewController
@synthesize locationManager, currentLocation, delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    NSLog(@"Location: %@", [newLocation description]);
    
    NSLog(@"Location: %@", self.currentLocation = newLocation);
    
    CLLocationCoordinate2D zoomLocation;
    // Handle location updates
    //latitude = newLocation.coordinate.latitude;
    
    zoomLocation.latitude = newLocation.coordinate.latitude;
    
    //longitude = newLocation.coordinate.longitude;
    
    zoomLocation.longitude= newLocation.coordinate.longitude;
    NSLog(@"%f", newLocation.coordinate.longitude);
    NSLog(@"%f", newLocation.coordinate.latitude);
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 10000.0f, 10000.0f);
    // 3
    MKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    // 4
    [_mapView setRegion:adjustedRegion animated:YES];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
	// Handle error
    NSLog(@"Error: %@", [error description]);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 500.0f;
    [locationManager setDelegate:self];
    
    [locationManager startUpdatingLocation];
    currentLocation = nil;
    
    
    //adding stores as pins
    
    CLLocationCoordinate2D annotationCoord;
    
    annotationCoord.latitude = 59.333157;
    annotationCoord.longitude = 17.976723;
    
    MKPointAnnotation *annotationPoint = [[MKPointAnnotation alloc] init];
    annotationPoint.coordinate = annotationCoord;
    annotationPoint.title = @"Måleributiken Alvik";
    annotationPoint.subtitle = @"Sveriges största tapetbutik";
    [_mapView addAnnotation:annotationPoint];
    
    CLLocationCoordinate2D annotationCoord1;
    
    annotationCoord1.latitude = 59.355295;
    annotationCoord1.longitude = 17.96137;
    
    MKPointAnnotation *annotationPoint1 = [[MKPointAnnotation alloc] init];
    annotationPoint1.coordinate = annotationCoord1;
    annotationPoint1.title = @"Björklund&Wingqvist";
    annotationPoint1.subtitle = @"Tapetvaruhuset B&W";
    [_mapView addAnnotation:annotationPoint1];
    
    
    
    
}

- (IBAction)goBack:(id)sender{
    NSLog(@"goBack!");
    [[self delegate] goBack];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
