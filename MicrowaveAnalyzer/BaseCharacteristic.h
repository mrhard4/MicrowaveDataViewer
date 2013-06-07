//
//  BaseCharacteristic.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Measurement.h"

#define OPTION_VALUE(index) (self.options.count > index ? [self.options[(index)] selectedValue] : 0)

@interface Option : NSObject 

@property (nonatomic, strong) NSArray *values;
@property (nonatomic) int selectedValue;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) Option *parentOption;
@property (nonatomic, strong) NSMutableArray *parentIndexes;

@end

@interface BaseCharacteristic : NSObject <NSCopying> {
    Measurement *_measurement;
}

@property (nonatomic, strong, readonly) NSMutableArray *options;

//view options
@property (nonatomic, copy) NSString *fullTitle;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;

- (id)initWithMeasurement:(Measurement *)measurement;

- (double)minValue;
- (double)maxValue;
- (NSString *)title;
- (double)valueForFreq:(NSNumber *)freq;

- (double)localizedValueForFreq:(NSNumber *)freq;

- (NSArray *)freq;

+ (double)dbMultiplier;

@end
