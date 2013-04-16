//
//  PostStentWindowController.h
//  PostStent
//
//
//

#import <Cocoa/Cocoa.h>
#import <OsiriXAPI/PluginFilter.h>
#import <OsiriXAPI/PreviewView.h>

/*#define id Id
#include "itkImage.h"
#include "itkImportImageFilter.h"
#include "itkMedianImageFilter.h"
#include "itkBinaryThresholdImageFilter.h"
#include "itkGradientAnisotropicDiffusionImageFilter.h"
#include "itkSigmoidImageFilter.h"
#include "itkRescaleIntensityImageFilter.h"
#undef id*/

@class PostStentMIP;
@class PostStentView;

@interface PostStentWindowController : ViewerController //NSWindowController
{
    IBOutlet DCMView    *viewStaticPre;
    IBOutlet DCMView    *viewStaticPost;
    IBOutlet NSSlider   *sliderAlpha;
    IBOutlet NSSlider   *sliderBeta;
    IBOutlet NSSlider   *sliderThresholdMin;
    IBOutlet NSSlider   *sliderThresholdMax;
    IBOutlet NSTextField    *textAlpha;
    IBOutlet NSTextField    *textBeta;
    IBOutlet NSTextField    *textMin;
    IBOutlet NSTextField    *textMax;
    
    
    PostStentMIP        *myMIP1;
    PostStentMIP        *myMIP2;
    
    NSMutableArray      *postStentPixList1;
    NSMutableArray      *postStentPixList2;
    NSMutableArray      *postStentFileList1;
    NSMutableArray      *postStentFileList2;
    //SeriesView              *seriesView;
    
    //DCMView					*imageView;
    
}

- (id) initWithPix1:(NSMutableArray*)f1 withFiles1:(NSMutableArray*)d1 withPix2:(NSMutableArray*)f2 withFiles2:(NSMutableArray*)d2;

- (IBAction)performFiltering:(id)sender;

@end
