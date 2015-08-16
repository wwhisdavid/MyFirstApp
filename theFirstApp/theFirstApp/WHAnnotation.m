//
//  WHAnnotation.m
//  theFirstApp
//
//  Created by david on 15/5/7.
//  Copyright (c) 2015年 david. All rights reserved.
//

#import "WHAnnotation.h"
#import <CoreLocation/CoreLocation.h>  
#import "CLLocation+wwh.h"

@implementation WHAnnotation

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    _coordinate = [CLLocation getMarsCoordinateFromBaidu:newCoordinate];
}

@end
