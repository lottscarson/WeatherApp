//
//  CurrentWeather.h
//  WeatherApp
//
//  Created by Scott Larson on 3/6/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWeather : NSObject

@property (copy, nonatomic) NSString *temperature;
@property (copy, nonatomic) NSString *location;

@end
