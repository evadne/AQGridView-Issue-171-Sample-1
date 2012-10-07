//
//  ViewController.h
//  camTest
//
//  Created by David Chambers on 10/2/12.
//  Copyright (c) 2012 David Chambers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface ViewController : UIViewController <UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UIPopoverControllerDelegate, UIScrollViewDelegate>
{
    UIPopoverController *_popoverControlleriOS6;
    UIImageView *_imageView;
    UIImageView *scollViewImage;
    BOOL newMedia;
    
    CGFloat width;
    CGFloat height;
    
    //The number of salescalls with photo info that need to be displayed:
    int numberOfPhotoBoxesOnShelf;
    
}


//Outlets:

@property (strong, nonatomic) IBOutlet UIScrollView *storyboardScrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UIButton *rollButton;
@property (strong, nonatomic) IBOutlet UIButton *camButton;

//Properties:

//Area to hold all out salescall buttons for those sales calls for that company with photos:
@property (nonatomic, strong) UIView *containerView;
//Again, in iOS6, could not use the name popoverController as it complained it was already in use
@property (nonatomic, retain) UIPopoverController *popoverControlleriOS6;

//Methods:

- (IBAction)useCamera;
- (IBAction)useCameraRoll;
- (void)setupDummyHistoryButtons: (int) number;
- (void)setupContainerLength: (int) number;

@end
