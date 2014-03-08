//
//  WAForecastCell.h
//  WeatherApp
//
//  Created by Scott Larson on 3/7/14.
//  Copyright (c) 2014 SL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WAForecastCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *forecastTemperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastDayLabel;
@property (weak, nonatomic) IBOutlet UIView *topSeparator;

@end
