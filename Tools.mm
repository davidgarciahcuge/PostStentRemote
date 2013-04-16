//
//  Tools.m
//  PostStent
//
//  Created by David García Juan on 11/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Tools.h"
#import "PostStentMIP.h"

@implementation Tools

+ (DCMPix*) applyFilters: (PostStentMIP*) mip withAlpha:(int)alpha Beta:(int)beta minThreshold:(int)min maxThreshold:(int)max
{
    NSLog(@"We are in applyFilters.");
    
    typedef float itkPixelType;
    const int Dimension = 3;
    
    //We define the image that we are going to import.
    typedef itk::Image< itkPixelType, Dimension > ImageType;
    
    typedef	itk::ImportImageFilter< itkPixelType, Dimension > ImportFilterType;
    
    //We instantiate the import filter. (The filter with we are going to "get" the image.)
    ImportFilterType::Pointer importFilter = ImportFilterType::New();
    
    //We define the size of the image that we are going to insert to the filter.
    ImportFilterType::SizeType		size;
    
    //X = number of columns of the image.
    size[0] = [mip pwidth];
    
    //Y = number of rows of the image.
    size[1] = [mip pheight];
    
    //Simulamos que tiene tres dimensiones?????
    size[2] = 1;
    
    
    //¿Hace falta definir size[2]?. Nuestra imagen va a ser 2D
    //size[2] = 0;
    
    //We define the index of the image where we are going to start
    ImportFilterType::IndexType start;
    
    //We start it with 0.
    start.Fill(0);
    
    //We define the region we are going to import (The part of the image that we are going to import)
    ImportFilterType::RegionType region;
    region.SetIndex( start );
    region.SetSize( size );
    
    //We specify the region to the filter.
    importFilter->SetRegion( region );   
    
    //Trasteamos el tema del origen y el spacing
    
    double	origin[3];
    double	originConverted[ 3];
    double	vectorOriginal[ 9];
    double	voxelSpacing[3];
    
    origin[0] = [mip originX];
    origin[1] = [mip originY];
    origin[2] = [mip originZ];
    
    [mip orientationDouble: vectorOriginal];
    
    originConverted[ 0] = origin[ 0] * vectorOriginal[ 0] + origin[ 1] * vectorOriginal[ 1] + origin[ 2] * vectorOriginal[ 2];
    originConverted[ 1] = origin[ 0] * vectorOriginal[ 3] + origin[ 1] * vectorOriginal[ 4] + origin[ 2] * vectorOriginal[ 5];
    originConverted[ 2] = origin[ 0] * vectorOriginal[ 6] + origin[ 1] * vectorOriginal[ 7] + origin[ 2] * vectorOriginal[ 8];
    
    
    //voxelSpacing[0] = [myMIP1 pixelSpacingX];
    //voxelSpacing[1] = [myMIP1 pixelSpacingY];
    //voxelSpacing[2] = [myMIP1 sliceInterval];
    
    //We define the origin of the output image
    /*double origin [Dimension];
     
     origin[0] = [myMIP1 originX];
     origin[1] = [myMIP1 originY];
     origin[2] = [myMIP1 originZ];*/
    
    //We insert it to the import filter.
    //importFilter->SetOrigin( origin );
    importFilter->SetOrigin( originConverted );
    
    //We define the spacing of the image.
    double spacing [Dimension];
    
    //spacing[0] = [myMIP1 pixelSpacingX];
    //spacing[1] = [myMIP1 pixelSpacingY];
    //spacing[1] = 1;
    //spacing[2] = [myMIP1 sliceInterval];
    
    spacing [0] = 0.1;
    spacing [1] = 0.1;
    spacing [2] = 0.1;
    
    
    //We pass it to the filter.
    importFilter->SetSpacing( spacing );
    
    //We calculate the number of pixels of the image.
    long numerofPixels = size[0] * size[1];
    
    //We define a block of memory for this amount of pixels
    float* fVolumePtr2D = (float*)malloc( sizeof( float)* numerofPixels);
    fVolumePtr2D = [mip fImage];
    //We pass it to the import filter.
    importFilter->SetImportPointer((float*)fVolumePtr2D, numerofPixels, false);
    
    //Puntero que apunta finalmente a la imagen.
    ImageType::Pointer image;
    
    //Cogemos la imagen
    image = importFilter->GetOutput();
    //image->Update();
    
    
    //Definimos filtro y le pasamos la imagen.
    //typedef itk::MedianImageFilter< ImageType, ImageType >  MedianImageFilterType;
    //typedef itk::BinaryThresholdImageFilter<ImageType, ImageType> BinaryThresholdImageFilterType;
    typedef itk:: GradientAnisotropicDiffusionImageFilter<ImageType, ImageType> GradientAnisotropicDiffusionFilterType;
    
    //MedianImageFilterType::Pointer medianFilter = MedianImageFilterType::New();
    //BinaryThresholdImageFilterType::Pointer binaryThresholdFilter = BinaryThresholdImageFilterType::New();
    GradientAnisotropicDiffusionFilterType::Pointer gradientAnisotropidDiffusionFilter = GradientAnisotropicDiffusionFilterType::New();
    
    //medianFilter->SetInput(image);
    //binaryThresholdFilter->SetInput(image);
    //binaryThresholdFilter->SetInsideValue(0);
    //binaryThresholdFilter->SetOutsideValue(1);
    //binaryThresholdFilter->SetLowerThreshold(100);
    //binaryThresholdFilter->SetUpperThreshold(200);
    gradientAnisotropidDiffusionFilter->SetInput(image);
    gradientAnisotropidDiffusionFilter->SetNumberOfIterations(10);
    gradientAnisotropidDiffusionFilter->SetTimeStep(0.00625);
    gradientAnisotropidDiffusionFilter->SetConductanceParameter(0.5);
    
    //medianFilter->Update();
    //binaryThresholdFilter->Update();
    //gradientAnisotropidDiffusionFilter->Update();
    
    //Reescalamos la salida del primer filtro entre 0 y 255. Para que en el siguiente sepamos que 
    //todos los valores van a estar con esos valores y podamos configurar bien el SigmoidImageFilter
    typedef itk::RescaleIntensityImageFilter<ImageType,ImageType> RescaleIntensityImageFilterType;
    
    RescaleIntensityImageFilterType::Pointer rescaleIntensityImageFilter = RescaleIntensityImageFilterType::New();
    
    rescaleIntensityImageFilter->SetOutputMaximum(255);
    rescaleIntensityImageFilter->SetOutputMinimum(0);
    
    rescaleIntensityImageFilter->SetInput(gradientAnisotropidDiffusionFilter->GetOutput());
    //Con este filtro intentamos resaltar todavía más los valores de capilares (negro)
    //sobre los valores del tejido que no nos interesa. Potencia el contraste vamos.
    typedef itk::SigmoidImageFilter<ImageType, ImageType> SigmoidImageFilterType;
    
    SigmoidImageFilterType::Pointer sigmoidImageFilter = SigmoidImageFilterType::New();
    
    sigmoidImageFilter->SetOutputMinimum(0);
    sigmoidImageFilter->SetOutputMaximum(255);
    sigmoidImageFilter->SetAlpha(alpha);//20
    NSLog(@"Alpha: %d", alpha);
    sigmoidImageFilter->SetBeta(beta);//155
    
    sigmoidImageFilter->SetInput(rescaleIntensityImageFilter->GetOutput());
    
    //Ahora binarizamos la imagen resultado.
    typedef itk::BinaryThresholdImageFilter<ImageType, ImageType> BinaryThresholdImageFilterType;
    
    BinaryThresholdImageFilterType::Pointer binaryThresholdFilter = BinaryThresholdImageFilterType::New();
    
    binaryThresholdFilter->SetInput(sigmoidImageFilter->GetOutput());
    binaryThresholdFilter->SetInsideValue(0);
    binaryThresholdFilter->SetOutsideValue(1);
    binaryThresholdFilter->SetLowerThreshold(min);
    binaryThresholdFilter->SetUpperThreshold(max);
    //binaryThresholdFilter->Update();
    
    //Puntero que apunta a la imagen de salida.
    //float* resultBuff = medianFilter->GetOutput()->GetBufferPointer();
    //float* resultBuff = binaryThresholdFilter->GetOutput()->GetBufferPointer();
    float* resultBuff = binaryThresholdFilter->GetOutput()->GetBufferPointer();
    
    binaryThresholdFilter->Update();
    
    DCMPix *imagenFiltrada = [[DCMPix alloc] initWithData:resultBuff :32 :size[0] :size[1] :spacing[0] :spacing[1] :origin[0] :origin[1] :0];
    
    return imagenFiltrada;

}

@end
