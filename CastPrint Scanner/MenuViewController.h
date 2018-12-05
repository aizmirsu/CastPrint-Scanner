/*
 */

#import <UIKit/UIKit.h>



@interface MenuViewController : UIViewController <UIGestureRecognizerDelegate>
{}

//@property (nonatomic, assign) id<MeshViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *startScanButton;

+ (instancetype)viewController;

- (IBAction)startScanButtonPressed:(id)sender;


@end
