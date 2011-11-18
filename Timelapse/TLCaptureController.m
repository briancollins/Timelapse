#import <AVFoundation/AVFoundation.h>
#import "TLCaptureController.h"

@interface TLCaptureController ()
@property (nonatomic, readwrite, getter=isRunning) BOOL running;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureStillImageOutput *output;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation TLCaptureController
@synthesize delegate = _delegate, running, session, output, device, interval = _interval, timer;

- (id)init {
    if ((self = [super init])) {
        self.session = [[AVCaptureSession alloc] init];
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:NULL];
        [self.session addInput:input];
        
        self.output = [[AVCaptureStillImageOutput alloc] init];
        
        [self.session addOutput:output];
        
    }
    
    return self;
}

- (void)capture {
    [self.output captureStillImageAsynchronouslyFromConnection:[self.output.connections objectAtIndex:0] completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        NSData *data = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        [self.delegate captureController:self capturedImageData:data];
    }];
}

- (void)updateFrameRate {
    if (self.isRunning) {
        [self.timer invalidate];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(capture) userInfo:NULL repeats:YES];
    }
}

- (void)setInterval:(NSInteger)interval {
    _interval = interval;
    [self updateFrameRate];
}


- (void)start {
    self.running = YES;
    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.session startRunning];
    
    [self updateFrameRate];
    [self performSelector:@selector(lockExposure) withObject:nil afterDelay:5.0f];
}

- (void)lockExposure {
    [self.device lockForConfiguration:NULL];
    self.device.focusMode = AVCaptureFocusModeLocked;
    self.device.exposureMode = AVCaptureExposureModeLocked;
    self.device.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
    [self.device unlockForConfiguration];
}

- (void)stop {
    self.running = NO;
    [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [self.session stopRunning];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    [self.session stopRunning];
}

@end
