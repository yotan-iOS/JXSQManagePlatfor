//
//  AttendanceSignInViewController.m
//  BGRuralDomesticWaste
//
//  Created by ghost on 2017/8/15.
//  Copyright © 2017年 yotan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>


@interface MapNavigationManager : NSObject<MKAnnotation>

+ (void)showSheetAddView:(UIView *)aview City:(NSString *)city start:(NSString *)start end:(NSString *)end;
+ (void)showSheetAddAview:(UIView *)aview Coordinate2D:(CLLocationCoordinate2D)Coordinate2D;

@end
