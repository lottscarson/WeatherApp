//
//  WeatherCommunicator.h
//  WeatherApp
//
//  Created by Scott Larson on 3/6/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherCommunicatorDelegate
- (void)receivedCurrentWeatherJSON:(NSData *)json;
- (void)receivedFiveDayForecastJSON:(NSData *)json;
- (void)requestWeatherFailedWithError:(NSError *)error;
@end

@interface WeatherCommunicator : NSObject

@property (weak, nonatomic) id<WeatherCommunicatorDelegate> delegate;

- (void)requestCurrentWeatherForLocationAtLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;
- (void)requestFiveDayForecastForLocationAtLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude;

@end
