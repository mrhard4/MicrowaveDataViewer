//
//  GraphDataSource.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "GraphDataSource.h"
#import "BaseCharacteristic.h"
#import "PortCharacteristic.h"

@implementation GraphDataSource {
    NSArray *_freq;
    BaseCharacteristic *_nearestCharacteristic;
}

- (id)initWithFreq:(NSArray *)freq {
    if ((self = [super init])) {
        _freq = freq;
    }
    return self;
}

- (CPTPlotRange *)xRange {
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.0) length:CPTDecimalFromFloat([[_freq lastObject] floatValue])];
}

- (CPTPlotRange *)yRange {
    if (![self.characteristics count]) {
        return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(0.f) length:CPTDecimalFromFloat(1.f)];
    }
    CGFloat minV = [[[self.characteristics allValues] valueForKeyPath:@"@min.minValue"] floatValue];
    CGFloat maxV = [[[self.characteristics allValues] valueForKeyPath:@"@max.maxValue"] floatValue];
    
    CGFloat lenght = (minV * maxV) < 0 ? fabsf(minV) + fabsf(maxV) : fabsf(fabsf(maxV) - fabs(minV));
    return [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(minV) length:CPTDecimalFromFloat(lenght)];
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [_freq count];
}

-(double)doubleForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)indx
{
    NSNumber *f = _freq[indx];
    if (fieldEnum == 0) {
        return [f doubleValue];
    }
    return [self.characteristics[plot] localizedValueForFreq:f];
}

- (id)keyForValue:(id)value inDictionary:(NSDictionary *)dict {
    for (id key in [dict allKeys]) {
        if ([dict[key] isEqual:value]) {
            return key;
        }
    }
    return nil;
}

- (NSNumber *)findFrequencyForDoubleValue:(double)value {
    return [self findFrequencyForDoubleValue:value inArray:_freq];
}

- (NSNumber *)findFrequencyForDoubleValue:(double)value inArray:(NSArray *)array {
    if (array.count < 2) {
        return [array lastObject];
    }
    int location = [array count] / 2;
    if (value < [array[location] doubleValue]) {
        return [self findFrequencyForDoubleValue:value inArray:[array subarrayWithRange:NSMakeRange(0, location)]];
    } else {
        return [self findFrequencyForDoubleValue:value inArray:[array subarrayWithRange:NSMakeRange(location, [array count] - location)]];
    }
}

- (BaseCharacteristic *)findNearestCharacteristicForGraphPoint:(double *)point {
    NSNumber *f = [self findFrequencyForDoubleValue:point[0]];
    
    double minDdeltaY = MAXFLOAT;
    BaseCharacteristic *result;
    for (BaseCharacteristic *ch in [_characteristics allValues]) {
        double deltaY = fabs([ch localizedValueForFreq:f] - point[1]);
        if (deltaY < minDdeltaY) {
            minDdeltaY = deltaY;
            result = ch;
        }
    }
    return result;
}

- (void)beginTouch:(double *)graphPoint {
    _nearestCharacteristic = [self findNearestCharacteristicForGraphPoint:graphPoint];
}

- (void)convertPointToNearestValues:(double *)point {
    NSNumber *f = [self findFrequencyForDoubleValue:point[0]];
    point[0] = [f doubleValue];
    point[1] = [_nearestCharacteristic localizedValueForFreq:f];
}

+ (BOOL)array:(NSArray *)array containsSmithCharacteristic:(PortCharacteristic *)ch {
    for (id obj in array) {
        if ([ch isEqualForSmith:obj]) {
            return YES;
        }
    }
    return NO;
}

+ (NSArray *)smithCharacteristicsInArray:(NSArray *)array {
    NSMutableArray *result = [NSMutableArray new];
    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[PortCharacteristic class]] && ![self array:result containsSmithCharacteristic:obj]) {
            [result addObject:obj];
        }
    }];
    return result;
}

@end
