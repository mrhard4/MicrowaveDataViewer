//
//  NFCharacteristic.h
//  MicrowaveAnalyzer
//
//  Created by mrhard on 27.05.13.
//  Copyright (c) 2013 mrhard. All rights reserved.
//

#import "BaseCharacteristic.h"

@class NFMinCharacteristic;

@interface NFCharacteristic : BaseCharacteristic

- (id)initWithSParams:(Measurement *)sParams rn:(Measurement *)rn gammaOpt:(Measurement *)gammaOpt NFMin:(NFMinCharacteristic *)NFmin;

@end
