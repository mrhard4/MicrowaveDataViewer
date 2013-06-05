//
//  Characteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 03.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "Measurement.h"

@implementation Measurement {
    NSMutableDictionary *_valuesDict;
}

- (id)initWithFreq:(NSArray *)freq values:(NSArray *)values {
    if ((self = [super init])) {
        _freq = [freq mutableCopy];
        _values = [values mutableCopy];
        _valuesDict = [NSMutableDictionary dictionaryWithObjects:values forKeys:freq];
    }
    return self;
}

- (id)measurementForFrequency:(NSNumber *)freq {
    return _valuesDict[freq];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_values count];
}

-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)indx
{
    if (fieldEnum == 0) {
        return [self.freq[indx] doubleValue];
    }
    return [_values[indx] doubleValue];
}

@end
