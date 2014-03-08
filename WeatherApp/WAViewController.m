//
//  WAViewController.m
//  WeatherApp
//
//  Created by Scott Larson on 3/6/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import "WAViewController.h"
#import "WAForecastCell.h"
#import "WALoadingOverlay.h"

static NSInteger const kForecastDays    = 5;
static NSString *kCellReuseIdentifier   = @"forecastCell";

@interface WAViewController ()

@property (strong, nonatomic) WeatherData *weatherData;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *currentTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (strong, nonatomic) WALoadingOverlay *loadingOverlay;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.title = @"Weather App";
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    self.weatherData = [[WeatherData alloc] init];
    self.weatherData.delegate = self;
    
    self.currentTemperatureLabel.text = @"";
    self.currentLocationLabel.text = @"";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.loadingOverlay = [[WALoadingOverlay alloc] init];
    [self.loadingOverlay displayOverlay];
        
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    [manager stopUpdatingLocation];
    
    CLLocation *currentLocation = [locations lastObject];
    [self.weatherData fetchCurrentWeatherDataForLocationAtLatitude:currentLocation.coordinate.latitude
                                                      andLongitude:currentLocation.coordinate.longitude];
}

#pragma mark - WeatherDataDelegate

- (void)didRecieveWeatherData:(WeatherData *)weatherData
{
    [self.loadingOverlay dismissOverlay];
   
    self.currentTemperatureLabel.text = weatherData.currentWeather.temperature;
    self.currentLocationLabel.text = weatherData.currentWeather.location;

    [self.tableView reloadData];
}

- (void)failedToRecieveWeatherDataWithError:(NSError *)error
{
    NSLog(@"Failed to recieve weather data");
    NSLog(@"%@", error.description);
}

#pragma mark - UITableViewDelegate / UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kForecastDays;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return self.headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WAForecastCell *forecastCell = [tableView dequeueReusableCellWithIdentifier:kCellReuseIdentifier];
    
    if (!forecastCell) {
        forecastCell = [[WAForecastCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellReuseIdentifier];
    }
    
    forecastCell.topSeparator.hidden = (indexPath.row == 0 ? NO : YES);
    
    if (self.weatherData.fiveDayForecast) {
        ForecastDay *forecastDay = [self.weatherData.fiveDayForecast objectAtIndex:indexPath.row];
        forecastCell.forecastTemperatureLabel.text = forecastDay.temperature;
        forecastCell.forecastDayLabel.text = forecastDay.weekdayName;
    } else {
        forecastCell.forecastTemperatureLabel.text = @"";
        forecastCell.forecastDayLabel.text = @"";
    }
    
    return forecastCell;
}

@end
