//
//  Example1Controller.m
//  DemoQRCode
//
//  Created by Ralph Li on 9/29/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "Example1Controller.h"
#import <AVFoundation/AVFoundation.h>

@interface Example1Controller()
<
AVCaptureMetadataOutputObjectsDelegate,
UIAlertViewDelegate
>

@property (nonatomic, strong) UIView *scanRectView;

@property (strong, nonatomic) AVCaptureDevice            *device;
@property (strong, nonatomic) AVCaptureDeviceInput       *input;
@property (strong, nonatomic) AVCaptureMetadataOutput    *output;
@property (strong, nonatomic) AVCaptureSession           *session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *preview;

@end

@implementation Example1Controller


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGSize windowSize = [UIScreen mainScreen].bounds.size;
    
    CGSize scanSize = CGSizeMake(windowSize.width*3/4, windowSize.width*3/4);
    CGRect scanRect = CGRectMake((windowSize.width-scanSize.width)/2, (windowSize.height-scanSize.height)/2, scanSize.width, scanSize.height);
    
    scanRect = CGRectMake(scanRect.origin.y/windowSize.height, scanRect.origin.x/windowSize.width, scanRect.size.height/windowSize.height,scanRect.size.width/windowSize.width);
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    self.output = [[AVCaptureMetadataOutput alloc]init];
    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    [self.session setSessionPreset:([UIScreen mainScreen].bounds.size.height<500)?AVCaptureSessionPreset640x480:AVCaptureSessionPresetHigh];
    [self.session addInput:self.input];
    [self.session addOutput:self.output];
    self.output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    self.output.rectOfInterest = scanRect;
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.preview.frame = [UIScreen mainScreen].bounds;
    [self.view.layer insertSublayer:self.preview atIndex:0];
    
    self.scanRectView = [UIView new];
    [self.view addSubview:self.scanRectView];
    self.scanRectView.frame = CGRectMake(0, 0, scanSize.width, scanSize.height);
    self.scanRectView.center = CGPointMake(CGRectGetMidX([UIScreen mainScreen].bounds), CGRectGetMidY([UIScreen mainScreen].bounds));
    self.scanRectView.layer.borderColor = [UIColor redColor].CGColor;
    self.scanRectView.layer.borderWidth = 1;
    
    
    //开始捕获
    [self.session startRunning];
    
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    if ( (metadataObjects.count==0) )
    {
        return;
    }
    
    if (metadataObjects.count>0) {
        
        [self.session stopRunning];
        
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects.firstObject;
        //输出扫描字符串
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:metadataObject.stringValue message:@"" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.session startRunning];
}


@end
