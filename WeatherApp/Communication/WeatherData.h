//
//  WeatherData.h
//  WeatherApp
//
//  Created by Scott Larson on 3/6/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherCommunicator.h"
#import "CurrentWeather.h"
#import "ForecastDay.h"

@class WeatherData;

@protocol WeatherDataDelegate <NSObject>
- (void)didRecieveWeatherData:(WeatherData *)weatherData;
- (void)failedToRecieveWeatherDataWithError:(NSError *)error;
@end

@interface WeatherData : NSObject <WeatherCommunicatorDelegate>

@property (weak, nonatomic) id<WeatherDataDelegate> delegate;

@property (strong, nonatomic) CurrentWeather *currentWeather;
@property (strong, nonatomic) NSArray *fiveDayForecast;

- (void)fetchCurrentWeatherDataForLocationAtLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;

@end
