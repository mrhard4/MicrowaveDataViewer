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
@property (nonatomic, readonly, strong) BaseCharacteristic *nearestCharacteristic;

- (id)initWithFreq:(NSArray *)freq;

- (void)setCharacteristics:(NSDictionary *)characteristics;

- (CPTPlotRange *)xRange;
- (CPTPlotRange *)yRange;

+ (NSArray *)smithCharacteristicsInArray:(NSArray *)array;

- (void)beginTouch:(double *)graphPoint;
- (void)convertPointToNearestValues:(double *)point;

@end
