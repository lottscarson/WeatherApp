//
//  WAViewController.h
//  WeatherApp
//
//  Created by Scott Larson on 3/6/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "WeatherData.h"

@interface WAViewController : UIViewController <CLLocationManagerDelegate, WeatherDataDelegate, UITableViewDataSource, UITableViewDelegate>

@end
