//
//  Characteristic.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 03.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Measurement : NSObject <CPTPlotDataSource>

@property (nonatomic, strong, readonly) NSArray *freq;
@property (nonatomic, strong, readonly) NSArray *values;

- (id)initWithFreq:(NSArray *)freq values:(NSArray *)values;

- (id)measurementForFrequency:(NSNumber *)freq;

@end
