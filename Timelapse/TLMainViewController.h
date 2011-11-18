#import "TLCaptureController.h"

@interface TLMainViewController : UIViewController <TLCaptureControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *label;
@property (nonatomic, weak) IBOutlet UISlider *slider;
@property (nonatomic, weak) IBOutlet UIButton *button;
@property (nonatomic, strong) TLCaptureController *captureController;

- (IBAction)sliderChanged:(id)sender;
- (IBAction)buttonPressed:(id)sender;

@end
