//
//  PostStentMIP.h
//  PostStent
//
//  Created by David García Juan on 23/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//#import <OsiriXAPI/OsiriXAPI.h>

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

@class PostStentFilteredImage;

@interface PostStentMIP : DCMPix
{


}

- (id) initWithPixList:(NSMutableArray*)p;

- (PostStentFilteredImage*) applyFilterswithAlpha:(int)alpha Beta:(int)beta minThreshold:(int)min maxThreshold:(int)max;

@end
