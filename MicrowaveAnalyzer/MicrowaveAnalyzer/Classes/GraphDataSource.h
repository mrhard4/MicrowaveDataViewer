//
//  GraphDataSource.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BaseCharacteristic;

@interface GraphDataSource : NSObject <CPTPlotDataSource>

@property (nonatomic, strong) NSDictionary *characteristics;

- (id)initWithFreq:(NSArray *)freq;

- (void)setCharacteristics:(NSDictionary *)characteristics;

- (CPTPlotRange *)xRange;
- (CPTPlotRange *)yRange;

- (NSDictionary *)characteristicsByColor;
- (NSDictionary *)portCharacteristicsByColor;

- (void)beginTouch:(double *)graphPoint;
- (void)convertPointToNearestValues:(double *)point;

@end