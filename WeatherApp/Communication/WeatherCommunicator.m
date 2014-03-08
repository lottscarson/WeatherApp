//
//  WeatherCommunicator.m
//  WeatherApp
//
//  Created by Scott Larson on 3/6/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import "WeatherCommunicator.h"


@implementation WeatherCommunicator

- (void)requestCurrentWeatherForLocationAtLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    NSString *urlFormatString = @"http://api.openweathermap.org/data/2.5/weather?lat=%.02ff&lon=%.02f";
    NSString *urlRequestString = [NSString stringWithFormat:urlFormatString, latitude, longitude];
    NSURL *url = [[NSURL alloc] initWithString:urlRequestString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                                if (error) {
                                                    [self.delegate requestWeatherFailedWithError:error];
                                                } else {
                                                    [self.delegate receivedCurrentWeatherJSON:data];
                                                }
                                            }];
}

- (void)requestFiveDayForecastForLocationAtLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    NSString *urlFormatString = @"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%.02f&lon=%,02f&cnt=6&mode=json";
    NSString *urlRequestString = [NSString stringWithFormat:urlFormatString, latitude, longitude];
    NSURL *url = [[NSURL alloc] initWithString:urlRequestString];
    
    [NSURLConnection sendAsynchronousRequest:[[NSURLRequest alloc] initWithURL:url]
                                       queue:[[NSOperationQueue alloc] init]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                                               if (error) {
                                                   [self.delegate requestWeatherFailedWithError:error];
                                               } else {
                                                   [self.delegate receivedFiveDayForecastJSON:data];
                                               }
                                           }];
}

@end
