//
//  ViewController.m
//  camTest
//
//  Created by David Chambers on 10/2/12.
//  Copyright (c) 2012 David Chambers. All rights reserved.
//

#import "ViewController.h"

#import "AQGridViewController.h"


@interface ViewController ()

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Set up the minimum & maximum zoom scales
    CGRect scrollViewFrame = self.storyboardScrollView.frame;
    CGFloat scaleWidth = scrollViewFrame.size.width / self.storyboardScrollView.contentSize.width;
    CGFloat scaleHeight = scrollViewFrame.size.height / self.storyboardScrollView.contentSize.height;
    CGFloat minScale = MIN(scaleWidth, scaleHeight);
    //
    //
    self.storyboardScrollView.minimumZoomScale = minScale;
    self.storyboardScrollView.maximumZoomScale = 1.0f;
    //I made the black square the focus.
    [self.storyboardScrollView scrollRectToVisible:CGRectMake(30, 10, 20, 30) animated:YES];
    [self centerScrollViewContents];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AQGridViewController *grid = [AQGridViewController alloc];
    
    //Will be determined in Route Plan but for now, numberOfPhotoBoxesOnShelf:
    
    numberOfPhotoBoxesOnShelf = 19;
    
    //Set delegate:
    _storyboardScrollView.delegate = self;
    _storyboardScrollView.backgroundColor = [UIColor clearColor];
    
    // Set up the container view to hold our variable length container -  initially the size of the shelf:
    [self setupContainerLength:numberOfPhotoBoxesOnShelf];
    
    [self setupDummyHistoryButtons:numberOfPhotoBoxesOnShelf];

    width = CGRectGetWidth(self.view.bounds);
    height = CGRectGetHeight(self.view.bounds);
    
    [_camButton addTarget:self action:@selector(useCamera:) forControlEvents:UIControlEventTouchUpInside];
    [_rollButton addTarget:self action:@selector(useCameraRoll:) forControlEvents:UIControlEventTouchUpInside];

    UIView* childView = nil;
    for (id obj in [self.view subviews]) {
        if( [obj isMemberOfClass:[UIView class]] ) {
            childView = obj;
        }
    }

}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.imageView = nil;
}


-(void)setupContainerLength:(int)number
{
    //30 at end, then 120 for each photo box:
    int length = 30+number*110;
    float l = (float) length;
    
    // Set up the container view to hold our variable length container -  initially the size of the shelf:
    CGSize containerSize = CGSizeMake(l, 73.0f);
    _containerView = [[UIView alloc] initWithFrame:(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=containerSize}];
    _containerView.backgroundColor = [UIColor clearColor];
    // Tell the scroll view the size of the contents
    self.storyboardScrollView.contentSize = containerSize;
    [_storyboardScrollView addSubview:_containerView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setupDummyHistoryButtons:(int)number
{
    
    for (int i=0, x = 30 ; i < number ; i++) {
        
        UIButton *salescallButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        float a = (float) x;
        salescallButton.frame = CGRectMake(a, 9.9, 80.0, 80.0);
        [salescallButton setImage:[UIImage imageNamed:@"salescallButtonImage.png"] forState:UIControlStateNormal];
        salescallButton.tag = i;
        x += 110;
        [_containerView addSubview:salescallButton];

        
    }
    
}



- (IBAction)useCamera:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker =
        [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType =
        UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                  (NSString *) kUTTypeImage,
                                  nil];
        imagePicker.allowsEditing = NO;
        
        [self presentViewController:imagePicker animated:YES completion:^{
        
        }];
        
        newMedia = YES;
    }

}

- (IBAction)useCameraRoll:(id)sender


{
    if ([self.popoverControlleriOS6 isPopoverVisible]) {
        [self.popoverControlleriOS6 dismissPopoverAnimated:YES];
        
    } else {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum])
        {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                      (NSString *) kUTTypeImage,
                                      nil];
            imagePicker.allowsEditing = NO;
            
            
            
            self.popoverControlleriOS6 = [[UIPopoverController alloc]
                                      initWithContentViewController:imagePicker];
            
            _popoverControlleriOS6.delegate = self;
            
            //This just set the height to full but didn't change the width of the popover
            
            //self.popoverControlleriOS6.popoverContentSize = CGSizeMake(width, height);
            
            
            
            [self.popoverControlleriOS6 presentPopoverFromRect:[sender bounds]
                                                    inView:sender
                                  permittedArrowDirections:UIPopoverArrowDirectionAny
                                                  animated:YES];
            
            newMedia = NO;
            
        }
    }
}

/*
 
 Idea:  image picker object, configured to display the camera roll with only images from a certain date???
 
 Drag and drop images onto the scrollview boxes ?? */

#pragma mark - image picker controller delegate protocol


-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.popoverControlleriOS6 dismissPopoverAnimated:true];
    
    
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    
    // Won't work in iOS 6:
    
    //[self dismissModalViewControllerAnimated:YES];
    
    //The new method is:
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //The word modal has been removed (As it has been for the presenting API call)
    
        
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        
        _imageView.image = image;
        if (newMedia)
            UIImageWriteToSavedPhotosAlbum(image,
                                           self,
                                           @selector(image:finishedSavingWithError:contextInfo:),
                                           nil);
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    
    //end of route plan didFinish.... here
    
    //Once we have selected the image, do something with it THE FOLLOWING LEFT THE IMAGE ON THE SCREEN    ...... :
    
    //UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];

    //Works but needs some sort of Nav bar, I think
    
    //UIImageView *inputImage = [[UIImageView alloc] initWithImage:[self imageWithImage:image scaledToSize:CGSizeMake(width, height)]];
    //[self.view addSubview:inputImage];
    
    
    //image = [ImageHelpers imageWithImage:image scaledToSize:CGSizeMake(480, 640)];
    //[imageView setImage:image];
    

    
       
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
        
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //Deprecated:
    //[self dismissModalViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.storyboardScrollView.bounds.size;
    CGRect contentsFrame = self.containerView.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.containerView.frame = contentsFrame;
}

#pragma mark - UIScrollViewDelegate

- (UIView*)viewForZoomingInScrollView:(UIScrollView *)storyboardScrollView {
    // Return the view that we want to zoom
    return self.containerView;
    //return self.scrollViewBar;
}

//- (void)scrollViewDidZoom:(UIScrollView *)storyboardScrollView {
//    // The scroll view has zoomed, so we need to re-center the contents
//    [self centerScrollViewContents];
//}

//may need this:

- (void)scrollViewDidZoom:(UIScrollView *)storyboardScrollView {
    if (storyboardScrollView.zoomScale!=1.0) {
        // Zooming, enable scrolling
        storyboardScrollView.scrollEnabled = TRUE;
    } else {
        // Not zoomed, disable scrolling so gestures get used instead
        storyboardScrollView.scrollEnabled = FALSE;
    }
}

@end
