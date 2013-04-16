//
//  PostStentView.m
//  PostStent
//
//  Created by GARCIA David on 09.10.12.
//
//

#import "PostStentView.h"
#import "OsiriXAPI/ViewerController.h"

@implementation PostStentView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        // Initialization code here.
        //[DCMView setDefaults];
    }
    
    //return [self initWithFrame:frame imageRows:1  imageColumns:1];

    return self;
}

/*- (id)initWithFrame:(NSRect)frame imageRows:(int)rows  imageColumns:(int)columns
{
    self = [super initWithFrame:frame];
    
    if (self)
	{
		drawing = YES;
        _tag = 0;
		_imageRows = rows;
		_imageColumns = columns;
		isKeyView = NO;
		//[self setAutoresizingMask:NSViewMinXMargin];
		
		noScale = NO;
		flippedData = NO;
		
		//notifications
		/*NSNotificationCenter *nc;
		nc = [NSNotificationCenter defaultCenter];
		[nc addObserver: self
               selector: @selector(updateCurrentImage:)
                   name: OsirixDCMUpdateCurrentImageNotification
                 object: nil];
    }
    return self;
    
}*/


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    /*NSMutableArray *viewers = [ViewerController getDisplayed2DViewers];
    
    ViewerController *viewer = [viewers objectAtIndex:0];

    int numImage = [viewer imageIndex];
    
    DCMPix *imagen = [viewer pixList:numImage];
    
    [super setPixels:[viewer pixList] files:[viewer fileList] rois:nil firstImage:numImage level:'i' reset:YES];*/
    
    //NSString *modality = [[[[viewer imageView] dcmFilesList]objectAtIndex:0] valueForKeyPath:@"series.study.modality"];
    
    //NSLog(@"%d", numImage);
    
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    
    //[DCMView purgeStringTextureCache];
}


/*- (void) setPixels: (NSMutableArray*) pixels files: (NSArray*) files rois: (NSMutableArray*) rois firstImage: (short) firstImage level: (char) level reset: (BOOL) reset
{
    
}*/


@end
