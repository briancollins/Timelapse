@class TLCaptureController;

@protocol TLCaptureControllerDelegate <NSObject>
- (void)captureController:(TLCaptureController *)captureController capturedImageData:(NSData *)imageData;
@end

@interface TLCaptureController : NSObject
@property (nonatomic, weak) id <TLCaptureControllerDelegate> delegate;
@property (nonatomic, readonly, getter=isRunning) BOOL running;
@property (nonatomic, readwrite) NSInteger interval;

- (void)start;
- (void)stop;

@end
