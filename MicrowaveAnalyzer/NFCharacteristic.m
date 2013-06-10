//
//  NFCharacteristic.m
//  MicrowaveAnalyzer
//
//  Created by mrhard on 27.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "NFCharacteristic.h"
#import "ComplexNumber.h"
#import "ComplexMatrix.h"
#import "NFMinCharacteristic.h"

@implementation NFCharacteristic {
    Measurement *_sParams;
    Measurement *_rn;
    Measurement *_gammaOpt;
    NFMinCharacteristic *_NFmin;
}

- (id)instance {
    return [[[self class] alloc] initWithSParams:_sParams rn:_rn gammaOpt:_gammaOpt NFMin:_NFmin];
}

- (id)initWithSParams:(Measurement *)sParams rn:(Measurement *)rn gammaOpt:(Measurement *)gammaOpt NFMin:(NFMinCharacteristic *)NFmin {
    if ((self = [super initWithMeasurement:sParams])) {
        _sParams = sParams;
        _rn = rn;
        _gammaOpt = gammaOpt;
        _NFmin = NFmin;
    }
    return self;
}

- (BOOL)isEmpty {
    return _sParams == nil || _rn == nil || _gammaOpt == nil || [_NFmin isEmpty];
}

+ (double)dbMultiplier {
    return 10.;
}

- (NSString *)title {
    return @"NF";
}

- (double)valueForFreq:(NSNumber *)freq {
    double gammaOpt = [[_gammaOpt measurementForFrequency:freq] mag];
    double gOpt = [[[_gammaOpt measurementForFrequency:freq] addNumber:1.] mag];
    double qn = 4. * ([[_rn measurementForFrequency:freq] doubleValue] / 50.) / (gOpt * gOpt);
    
    ComplexMatrix *sMatrix = [_sParams measurementForFrequency:freq];
    double s21Abs = [[sMatrix elementForColumn:1 row:0] mag];
    
    double sigma22 = s21Abs * s21Abs * (([_NFmin valueForFreq:freq] - 1.) + qn * gammaOpt * gammaOpt);
    
    
    return 1. + sigma22 / (s21Abs * s21Abs);
}

@end
