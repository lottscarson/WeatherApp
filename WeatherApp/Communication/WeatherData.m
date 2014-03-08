//
//  WeatherData.m
//  WeatherApp
//
//  Created by Scott Larson on 3/6/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import "WeatherData.h"

@interface WeatherData ()

@property (strong, nonatomic) WeatherCommunicator *communicator;
@property (assign, nonatomic) BOOL recievedCurrentWeather;
@property (assign, nonatomic) BOOL recievedFiveDayForecast;

@end

@implementation WeatherData : NSObject

- (void)fetchCurrentWeatherDataForLocationAtLatitude:(CGFloat)latitude andLongitude:(CGFloat)longitude
{
    self.recievedCurrentWeather = NO;
    self.recievedFiveDayForecast = NO;
    
    self.communicator = [[WeatherCommunicator alloc] init];
    self.communicator.delegate = self;
    [self.communicator requestCurrentWeatherForLocationAtLatitude:latitude andLongitude:longitude];
    [self.communicator requestFiveDayForecastForLocationAtLatitude:latitude andLongitude:longitude];
}

- (void)informDelegateOfCompletion
{
    // Perform the delegate callback on the main thread to ensure that the UI gets properly updated
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.recievedCurrentWeather && self.recievedFiveDayForecast) {
            [self.delegate didRecieveWeatherData:self];
        }
    });
}

- (void)receivedCurrentWeatherJSON:(NSData *)json
{
    NSError *error = nil;
    self.currentWeather = [self currentWeatherFromJSON:json error:&error];
    
    if (!error) {
        self.recievedCurrentWeather = YES;
        [self informDelegateOfCompletion];
    } else {
        [self.delegate failedToRecieveWeatherDataWithError:error];
    }
}

- (void)receivedFiveDayForecastJSON:(NSData *)json
{
    NSError *error = nil;
    self.fiveDayForecast = [self fiveDayForecastFromJSON:json error:&error];
    
    if (!error) {
        self.recievedFiveDayForecast = YES;
        [self informDelegateOfCompletion];
    } else {
        [self.delegate failedToRecieveWeatherDataWithError:error];
    }
}

- (void)requestWeatherFailedWithError:(NSError *)error
{
    [self.delegate failedToRecieveWeatherDataWithError:error];
}

- (CurrentWeather *)currentWeatherFromJSON:(NSData *)json error:(NSError **)error
{
    CurrentWeather *currentWeather = [[CurrentWeather alloc] init];
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSDictionary *mainDict = [parsedObject objectForKey:@"main"];
    
    currentWeather.temperature = [self formattedFahrenheitStringFromKelvinString:[mainDict objectForKey:@"temp"]];
    currentWeather.location = [parsedObject objectForKey:@"name"];
    
    return currentWeather;
}

- (NSArray *)fiveDayForecastFromJSON:(NSData *)json error:(NSError **)error
{
    NSMutableArray *forecastDays = [NSMutableArray array];
    
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:json options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSArray *dayList = [parsedObject objectForKey:@"list"];
    for (NSDictionary *dayDict in dayList) {
        // The forecast includes the first day, so just skip it
        if ([dayList indexOfObject:dayDict] == 0) {
            continue;
        }
        
        ForecastDay *forecastDay = [[ForecastDay alloc] init];
        
        NSString *timeStampString = [dayDict objectForKey:@"dt"];
        NSTimeInterval interval = [timeStampString doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
        forecastDay.weekdayName = [[[[NSDateFormatter alloc] init] weekdaySymbols] objectAtIndex:[components weekday] - 1];
        
        NSDictionary *tempDictionary = [dayDict objectForKey:@"temp"];
        forecastDay.temperature = [self formattedFahrenheitStringFromKelvinString:[tempDictionary objectForKey:@"day"]];
        
        [forecastDays addObject:forecastDay];
    }

    return [NSArray arrayWithArray:forecastDays];
}

#pragma mark - Helper methods

- (NSString *)formattedFahrenheitStringFromKelvinString:(NSString *)kelvinString
{
    CGFloat kelvin = [kelvinString floatValue];
    CGFloat fahrenheit = ((kelvin - 273) * 1.8) + 32;
    
    return [NSString stringWithFormat:@"%d°", (int)floor(fahrenheit)];
}

@end
