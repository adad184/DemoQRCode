//
//  Example2Controller.m
//  DemoQRCode
//
//  Created by Ralph Li on 9/29/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "Example2Controller.h"

@interface Example2Controller()
<
UINavigationControllerDelegate,
UIImagePickerControllerDelegate
>

@property (nonatomic, strong) UIButton *btnRead;

@end

@implementation Example2Controller


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.btnRead = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [self.view addSubview:self.btnRead];
    self.btnRead.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    [self.btnRead addTarget:self action:@selector(actionRead) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)actionRead
{
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    photoPicker.view.backgroundColor = [UIColor whiteColor];
    [self presentViewController:photoPicker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    UIImage * srcImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    CIImage *image = [CIImage imageWithCGImage:srcImage.CGImage];
    NSArray *features = [detector featuresInImage:image];
    CIQRCodeFeature *feature = [features firstObject];
    
    NSString *result = feature.messageString;
    
    if ( result )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result message:@"" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        
        [alert show];
    }
}

@end
