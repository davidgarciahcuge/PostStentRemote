//
//  Tools.h
//  PostStent
//
//  Created by David García Juan on 11/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OsiriXAPI/DCMPix.h>

#define id Id
#include "itkImage.h"
#include "itkImportImageFilter.h"
#include "itkMedianImageFilter.h"
#include "itkBinaryThresholdImageFilter.h"
#include "itkGradientAnisotropicDiffusionImageFilter.h"
#include "itkSigmoidImageFilter.h"
#include "itkRescaleIntensityImageFilter.h"
#undef id

@class PostStentMIP;

@interface Tools : NSObject
{
    
}

+ (DCMPix*) applyFilters: (PostStentMIP*) mip withAlpha:(int)alpha Beta:(int)beta minThreshold:(int)min maxThreshold:(int)max;

@end

