//
//  ComplexNumber.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 15.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "ComplexNumber.h"

@interface ComplexNumber ()

@property (nonatomic) double re;
@property (nonatomic) double im;
@property (nonatomic) double ang;
@property (nonatomic) double mag;

@end

@implementation ComplexNumber

const double kGradInRad = 57.295;

- (id)initWithReal:(double)re imaginary:(double)im {
    if ((self = [super init])) {\
        _re = re;
        _im = im;
        _mag = sqrt(_re * _re + _im * _im);
        _ang = asin(_im / _mag) * kGradInRad;
        if (_re < 0. && _im < 0.) {
            _ang = -180. - _ang;
        }
    }
    return self;
}

- (id)initWithAng:(double)ang mag:(double)mag {
    if ((self = [super init])) {
        _ang = ang;
        _mag = mag;
        ang /= kGradInRad;
        _re = cos(ang) * mag;
        _im = sin(ang) * mag;
    }
    return self;
}

- (ComplexNumber *)add:(ComplexNumber *)complexNumber {
    return [[[self class] alloc] initWithReal:self.re + complexNumber.re
                                    imaginary:self.im + complexNumber.im];
}

- (ComplexNumber *)sub:(ComplexNumber *)complexNumber {
    return [[[self class] alloc] initWithReal:self.re - complexNumber.re
                                    imaginary:self.im - complexNumber.im];
}

- (ComplexNumber *)multiply:(ComplexNumber *)complexNumber {
    return [[[self class] alloc] initWithReal:self.re * complexNumber.re - self.im * complexNumber.im
                                    imaginary:self.re * complexNumber.im + self.im * complexNumber.re];
}

- (ComplexNumber *)div:(ComplexNumber *)complexNumber {
    double div = (complexNumber.re * complexNumber.re + complexNumber.im * complexNumber.im);
    return [[[self class] alloc] initWithReal:(self.re * complexNumber.re + self.im * complexNumber.im) / div
                                    imaginary:(self.im * complexNumber.re - self.re * complexNumber.im) / div];
}

- (ComplexNumber *)addNumber:(double)number {
    return [self add:COMPLEX_FROM_NUMBER(number)];
}

- (ComplexNumber *)subNumber:(double)number {
    return [self sub:COMPLEX_FROM_NUMBER(number)];
}

- (ComplexNumber *)multiplyByNumber:(double)number {
    return [self multiply:COMPLEX_FROM_NUMBER(number)];
}

- (ComplexNumber *)divByNumber:(double)number {
    return [self div:COMPLEX_FROM_NUMBER(number)];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%.4f %@ %.4fj", self.re, self.im > 0 ? @"+" : @"-", fabsf(self.im)];
}

@end
