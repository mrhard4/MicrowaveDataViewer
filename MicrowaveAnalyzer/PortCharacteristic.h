//
//  PortCharacteristic.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 20.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Measurement.h"
#import "BaseCharacteristic.h"
#import "ComplexMatrix.h"
#import "ComplexNumber.h"

#define ONE_ADD_S11(sMatrix) [COMPLEX_FROM_NUMBER(1) add:[sMatrix elementForColumn:0 row:0]]
#define ONE_SUB_S22(sMatrix) [COMPLEX_FROM_NUMBER(1) sub:[sMatrix elementForColumn:1 row:1]]
#define ONE_SUB_S11(sMatrix) [COMPLEX_FROM_NUMBER(1) sub:[sMatrix elementForColumn:0 row:0]]
#define ONE_ADD_S22(sMatrix) [COMPLEX_FROM_NUMBER(1) add:[sMatrix elementForColumn:1 row:1]]

#define S12_MULTIPLY_S21(sMatrix) [[sMatrix elementForColumn:0 row:1] multiply:[sMatrix elementForColumn:1 row:0]]

enum {
    OptionTypeOutputType = 0,
    OptionTypeComplexModifier,
    OptionTypeToPortIndex,
    OptionTypeFromPortIndex
};

typedef enum {
    ComplexModifierReal = 0,
    ComplexModifierImag,
    ComplexModifierMag,
    ComplexModifierAngle
} ComplexModifier;

@interface PortCharacteristic : BaseCharacteristic

@property (nonatomic, readonly) double R;

- (id)initWithMeasurement:(Measurement *)measurement R:(double)R;
- (ComplexNumber *)complexForFreq:(NSNumber *)freq;

- (ComplexNumber *)valueForFreq:(NSNumber *)freq i:(int)i j:(int)j sMatrix:(ComplexMatrix *)sMatrix;

- (NSArray *)complexNumbers;
- (ComplexNumber *)normalizeComplexNumber:(ComplexNumber *)complexNumber;

- (BOOL)isEqualForSmith:(id)object;

@end
