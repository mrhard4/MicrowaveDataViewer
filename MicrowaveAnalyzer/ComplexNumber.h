//
//  ComplexNumber.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 15.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import <Foundation/Foundation.h>

#define COMPLEX_FROM_NUMBER(number) [[ComplexNumber alloc] initWithReal:(number) imaginary:0.]

@interface ComplexNumber : NSObject

@property (nonatomic, readonly) double re;
@property (nonatomic, readonly) double im;
@property (nonatomic, readonly) double ang;
@property (nonatomic, readonly) double mag;

- (id)initWithAng:(double)ang mag:(double)mag;
- (id)initWithReal:(double)re imaginary:(double)im;

- (ComplexNumber *)add:(ComplexNumber *)complexNumber;
- (ComplexNumber *)sub:(ComplexNumber *)complexNumber;
- (ComplexNumber *)multiply:(ComplexNumber *)complexNumber;
- (ComplexNumber *)div:(ComplexNumber *)complexNumber;
- (ComplexNumber *)addNumber:(double)number;
- (ComplexNumber *)subNumber:(double)number;
- (ComplexNumber *)multiplyByNumber:(double)number;
- (ComplexNumber *)divByNumber:(double)number;

@end
