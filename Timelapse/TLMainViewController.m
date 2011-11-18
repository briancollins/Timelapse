#import "TLMainViewController.h"
#import "TLCaptureController.h"

@interface TLMainViewController ()
- (void)updateButton;
@end

@implementation TLMainViewController
@synthesize label, slider, captureController, button;

- (id)init {
    if ((self = [super init])) {
        self.captureController = [[TLCaptureController alloc] init];        
        self.captureController.delegate = self;
    }
    
    return self;
}

- (void)dealloc {
    self.captureController.delegate = nil;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    self.captureController.interval = (NSInteger)roundf(sender.value);
    [self.label setText:[NSString stringWithFormat:@"Capture every %d seconds", self.captureController.interval]];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    if (self.captureController.isRunning) {
        [self.captureController stop];
    } else {
        [self.captureController start];
    }
    
    [self updateButton];
}

- (void)updateButton {
    if ([self.captureController isRunning]) {
        [self.button setTitle:@"Stop" forState:UIControlStateNormal];
    } else {
        [self.button setTitle:@"Start" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self sliderChanged:self.slider];
    
    [self updateButton];
    
}

- (void)captureController:(TLCaptureController *)captureController capturedImageData:(NSData *)imageData {
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:imageData], self, 
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo {
    NSLog(@"%@", error);
}

- (NSString *)title {
    return @"Timelapse";
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return toInterfaceOrientation != UIDeviceOrientationPortraitUpsideDown;
}

@end
