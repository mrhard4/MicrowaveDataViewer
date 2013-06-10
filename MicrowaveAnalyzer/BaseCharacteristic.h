//
//  BaseCharacteristic.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 10.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Measurement.h"

#define OPTION_VALUE_IN_OBJECT(object, index) (((BaseCharacteristic *)object).options.count > index ? [((BaseCharacteristic *)object).options[index] selectedValueIndex] : 0)
#define OPTION_VALUE(index) OPTION_VALUE_IN_OBJECT(self, index)

@interface Option : NSObject 

@property (nonatomic, strong) NSArray *values;
@property (nonatomic) int selectedValueIndex;
@property (nonatomic, copy) NSString *title;

@property (nonatomic) BOOL isUniversal;

@property (nonatomic, strong) Option *parentOption;
@property (nonatomic, strong) NSMutableArray *parentIndexes;

- (id)selectedValue;

@end

@interface BaseCharacteristic : NSObject <NSCopying> {
    Measurement *_measurement;
}

@property (nonatomic, strong) NSMutableArray *options;

//view options
@property (nonatomic, copy) NSString *fullTitle;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic) CGFloat lineWidth;

- (NSString *)SmithDescription;

- (id)initWithMeasurement:(Measurement *)measurement;

- (double)minValue;
- (double)maxValue;
- (NSString *)title;
- (double)valueForFreq:(NSNumber *)freq;

- (double)localizedValueForFreq:(NSNumber *)freq;

- (NSArray *)freq;

+ (double)dbMultiplier;

- (NSString *)optionsDescription;

- (BOOL)isEmpty;

@end
