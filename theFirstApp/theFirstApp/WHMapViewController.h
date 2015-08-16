//
//  WHMapViewController.h
//  theFirstApp
//
//  Created by david on 15/7/22.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "WHAnnotation.h"

@interface WHMapViewController : UIViewController <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) WHAnnotation *annotation;
@property (nonatomic, copy) NSString *urlStr;

@end
