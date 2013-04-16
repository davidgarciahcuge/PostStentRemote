//
//  PostStentWindowController.m
//  PostStent
//
//  Created by GARCIA David on 08.10.12.
//
//

#import "PostStentWindowController.h"
#import "PostStentView.h"
#import "PostStentMIP.h"
#import "PostStentFilteredImage.h"

#import <OsiriXAPI/PluginFilter.h>
#import <OsiriXAPI/DicomImage.h>
#import <OsiriXAPI/DCMPix.h>

/*#define id Id
#include "itkImage.h"
#include "itkImportImageFilter.h"
#include "itkMedianImageFilter.h"
#undef id*/

#import "Tools.h"

@interface PostStentWindowController ()

@end

@implementation PostStentWindowController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    
    if (self) {
        
        // Initialization code here.
        
        //[[self window] setWindowController:self];
        
        /*NSMutableArray *viewers = [ViewerController getDisplayed2DViewers];
        
        ViewerController *viewer = [viewers objectAtIndex:0];
        
        int numImage = [viewer imageIndex];
        
        DCMPix *imagen = [viewer pixList:numImage];
        
        [viewStaticPre setPixels:[viewer pixList] files:[viewer fileList] rois:nil firstImage:0 level:nil reset:YES];
        
        [viewStaticPre display];*/
        
        
    }
    
    return self;
}

- (id) initWithPix1:(NSMutableArray*)f1 withFiles1:(NSMutableArray*)d1 withPix2:(NSMutableArray*)f2 withFiles2:(NSMutableArray*)d2
{
    self = [super initWithWindowNibName:@"PostStentWindowController"];
    
    //NSLog(@"INITWITHPIX: WITHFILES:");
    
    if (self)
    {
        postStentPixList1 = f1;
        postStentPixList2 = f2;
        postStentFileList1 = d1;
        postStentFileList2= d2;
    }
    
           
    return self;
}

- (IBAction)performFiltering:(id)sender {
    
    NSLog(@"Button pushed.");
    
    //NSLog(@"Valor del slider: %f", [sliderPruebasPanel floatValue]);
    
    NSMutableArray *filterPixListLeft = [NSMutableArray arrayWithCapacity:1];
    
    PostStentFilteredImage *filteredPixLeft = [myMIP1 applyFilterswithAlpha:[sliderAlpha intValue] Beta:[sliderBeta intValue] minThreshold:[sliderThresholdMin intValue] maxThreshold:[sliderThresholdMax intValue]];
    
    [filterPixListLeft insertObject:filteredPixLeft atIndex:0];
    
    NSMutableArray *filterPixListRight = [NSMutableArray arrayWithCapacity:1];
    
    PostStentFilteredImage *filteredPixRight = [myMIP2 applyFilterswithAlpha:[sliderAlpha intValue] Beta:[sliderBeta intValue] minThreshold:[sliderThresholdMin intValue] maxThreshold:[sliderThresholdMax intValue]];
    
    [filterPixListRight insertObject:filteredPixRight atIndex:0];

    
    [viewStaticPre setDCM:filterPixListLeft :nil :nil :0 :'i' :YES];
    [viewStaticPost setDCM:filterPixListRight :nil :nil :0 :'i' :YES];

}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [textAlpha setIntegerValue:[sliderAlpha intValue]];
    [textBeta setIntegerValue:[sliderBeta intValue]];
    [textMin setIntegerValue:[sliderThresholdMin intValue]];
    [textMax setIntegerValue:[sliderThresholdMax intValue]];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    NSString *seriesDate1 = [[postStentFileList1 objectAtIndex:0] valueForKeyPath:@"series.date"];
    //NSLog(@"SERIESDATE1 = %@", seriesDate1);
    NSString *seriesDate2 = [[postStentFileList2 objectAtIndex:0] valueForKeyPath:@"series.date"];
    
    //DCMPix *postStentDCMPix = [postStentFileList1 objectAtIndex:0];
    
    NSMutableArray *mipPixList = [NSMutableArray arrayWithCapacity:1];
    
    myMIP1 = [[PostStentMIP alloc] initWithPixList:postStentPixList1];
    
    [mipPixList insertObject:myMIP1 atIndex:0];
    
    
    NSMutableArray *mipPixList2 = [NSMutableArray arrayWithCapacity:1];
    
    myMIP2 = [[PostStentMIP alloc] initWithPixList:postStentPixList2];
    
    [mipPixList2 insertObject:myMIP2 atIndex:0];
    
    //[mipPixList insertObject:[postStentPixList1 objectAtIndex:0] atIndex:0];
    
    //[viewStaticPre setDCM:mipPixList :nil :nil :0 :'i' :YES];
    //[viewStaticPost setDCM:mipPixList2 :nil :nil :0 :'i' :YES];
    
    //Compara que serie de imágenes se tomó antes y la pone a la izquierda
    if ([seriesDate1 compare:seriesDate2] == NSOrderedDescending) 
    {
        NSLog(@"date1 is later than date2");
        
        [viewStaticPre setDCM:mipPixList2 :nil :nil :0 :'i' :YES];
        [viewStaticPost setDCM:mipPixList :nil :nil :0 :'i' :YES];
        
    } else if ([seriesDate1 compare:seriesDate2] == NSOrderedAscending) 
    {
        
        NSLog(@"date1 is earlier than date2");
        [viewStaticPre setDCM:mipPixList :nil :nil :0 :'i' :YES];
        [viewStaticPost setDCM:mipPixList2 :nil :nil :0 :'i' :YES];
        
    } else 
    {
        NSLog(@"dates are the same");
        
        [viewStaticPre setDCM:mipPixList :nil :nil :0 :'i' :YES];
        [viewStaticPost setDCM:mipPixList2 :nil :nil :0 :'i' :YES];
        
    }

    //NSString *modality = [[postStentFileList1 objectAtIndex:0] valueForKeyPath:@"series.study.modality"];
    //NSLog(@"MODALITY1 = %@", modality);

   
    [viewStaticPre setHidden:NO];
    [viewStaticPre setIndexWithReset:0 :YES];
    [viewStaticPre setOrigin:NSMakePoint(0, 0)];
    [viewStaticPre scaleToFit];
    
    [viewStaticPost setHidden:NO];
    [viewStaticPost setIndexWithReset:0 :YES];
    [viewStaticPost setOrigin:NSMakePoint(0, 0)];
    [viewStaticPost scaleToFit];
    
}

- (BOOL)is2DViewer
{
	return NO;
}

/*-(void) updateImage:(id) sender
{
	for( DCMView *v in [seriesView imageViews])
	{
		[v updateImage];
	}
}

-(void) needsDisplayUpdate:(id) sender
{
	[self updateImage:self];
    
	float   iwl, iww;
	[imageView getWLWW:&iwl :&iww];
	[imageView setWLWW:iwl :iww];
	
	/*for( int y = 0; y < maxMovieIndex; y++)
	{
		for( int x = 0; x < [pixList[y] count]; x++)
			[[pixList[y] objectAtIndex: x] changeWLWW:iwl :iww];
	}
}*/


@end
