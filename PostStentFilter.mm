//
//  PostStentFilter.m
//  PostStent
//
//  Copyright (c) 2012 David. All rights reserved.
//

#import "PostStentFilter.h"
#import "PostStentWindowController.h"

@implementation PostStentFilter

- (void) initPlugin
{
}

- (long) filterImage:(NSString*) menuName
{
    
    NSMutableArray *viewers = [ViewerController get2DViewers];    
    
    //NSArray *series = [ViewerController getDisplayedSeries];
    
    //NSArray *files = [viewers objectAtIndex:0];
    
    int numViewers = [viewers count];
    
    if (numViewers == 2)
    {
        NSLog(@"Hay %d Viewers cargados", numViewers);
        //NSMutableArray *dates = [[NSMutableArray alloc] initWithCapacity:2];
                
        for (ViewerController *controller in viewers)
        {
            //NSArray *array = [[controller imageView]dcmFilesList];
            NSString *modality = [[[[controller imageView] dcmFilesList]objectAtIndex:0] valueForKeyPath:@"series.study.modality"];
            //NSString *name = [[[[controller imageView] dcmFilesList]objectAtIndex:0] valueForKeyPath:@"logentry.patientname"];
            //NSDate *studyTime = [[[[controller imageView] dcmFilesList]objectAtIndex:0] valueForKeyPath:@"series.study.date"];
            //NSString *seriesDate = [[[[controller imageView] dcmFilesList]objectAtIndex:0] valueForKeyPath:@"series.date"];
            //[dates addObject:seriesDate];
            //NSDate *studyTime3 = [[[[controller imageView] dcmFilesList]objectAtIndex:0] valueForKeyPath:@"series.dateAdded"];
            //NSDate *studyTime4 = [[[[controller imageView] dcmFilesList]objectAtIndex:0] valueForKeyPath:@"series.dateOpened"];

            //NSLog(@"//**DAVID**// -- SERIES.STUDY.DATE: %@", studyTime);
            //NSLog(@"//**DAVID**// -- SERIES.DATE: %@", seriesDate);   
            //NSLog(@"//**DAVID**// -- SERIES.DATEADDED: %@", studyTime3); 
            //NSLog(@"//**DAVID**// -- SERIES.DATEOPENED: %@", studyTime4);          


            if (![modality isEqualToString:@"XA"])
            {
                                
                //PostStentWindowController *postStentController = [[PostStentWindowController alloc] initWithPix:[[controller imageView] dcmPixList]
                                                                                                      //withFiles:[[controller imageView] dcmFilesList]
                                                                  
                NSRunAlertPanel(@"Format Error", @"PostStent only works with angiographic studies.", @"OK", nil, nil);                                                                  
                                                                  
                return -1;
                
            }            
            
        }
        
        PostStentWindowController *postStentController = [[PostStentWindowController alloc] initWithPix1:[[[viewers objectAtIndex:0]imageView]dcmPixList] 
                                                                                              withFiles1:[[[viewers objectAtIndex:0]imageView]dcmFilesList] withPix2:[[[viewers objectAtIndex:1]imageView]dcmPixList] withFiles2:[[[viewers objectAtIndex:1]imageView]dcmFilesList]];
        [postStentController showWindow:self];
        
        return 0;
        
    }else
    {
        //Mostrar pantalla de error que advierta que necesitamos dos
        NSRunAlertPanel(@"Plugins", @"Para que el plugin funcione tiene que haber dos estudios cargados.", @"OK", nil, nil);
        return -1;
    }


}

@end
