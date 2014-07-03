//
//  ViewController.m
//  Kinetiscope
//
//  Created by Cass Pangell on 7/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "ViewController.h"
#import "Block.h"
#import "BlockObj.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self loginToKinvey];
    
    blockArray = [[NSMutableArray alloc] init];
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    
    [self.scrollView setScrollEnabled:YES];

}

#pragma mark - Methods
-(void)createNewBlock{
    
    Block *newBlock = [[Block alloc] init];
    [newBlock setBlockNumber:[blockArray count]];
    [newBlock setBlockMoviePath:bMoviePath];
    [newBlock addTarget:self action:@selector(blockPressed:) forControlEvents:UIControlEventTouchUpInside];
    [blockArray addObject:newBlock];
    
    [self saveBlockToKinvey:newBlock];
    [self reverseBlocks];
}

-(void)reverseBlocks{
    Block *block = [[Block alloc] init];

    CGFloat sideBuffer = 5;
    CGFloat blockAndBuffer = block.getWidth + sideBuffer;
    CGFloat topBuffer = 20;
    int blockRow = 0;
    int colCount = 0;
    
    for (int i = [blockArray count]; i>0; i--) {
        block = [blockArray objectAtIndex:i-1];
        
       if (i == [blockArray count]) {

           block.alpha = 0.2;
           [UIView animateWithDuration:.4 animations:^{
               block.alpha = 1.0;
           }];
           
        }else if (i % 3 == 0) {
            colCount = 0;
            blockRow ++;
            
            block.alpha = 0.1;
            [UIView animateWithDuration:.7 animations:^{
                block.alpha = 1.0;
            }];
            
        }else{
            colCount ++;
            block.alpha = 0.0;
            [UIView animateWithDuration:1.0 animations:^{
                block.alpha = 1.0;
            }];
        }
        
        block.frame = CGRectMake(sideBuffer + (colCount * blockAndBuffer), topBuffer + (blockRow * (block.getHeight + sideBuffer)), block.getWidth, block.getHeight);
        [block setTitle:[NSString stringWithFormat:@"%d", [block getBlockNumber]] forState:(UIControlState)UIControlStateNormal];
        
        self.blockView.frame = CGRectMake(0, 0, 320, (topBuffer + ((blockRow+1) * (block.getHeight + sideBuffer))));
        [self.scrollView setContentSize:CGSizeMake(self.blockView.frame.size.width, self.blockView.frame.size.height)];
        
        [self.blockView addSubview:block];
        
    }
    
}

-(IBAction)blockPressed:(id) sender {
    Block *block = [[Block alloc] init];
    block = sender;
}

#pragma mark - Gesture Recognizers
- (void)handleSwipeLeft:(UIGestureRecognizer*)recognizer {
    [self createNewBlock];
    //[self startCameraControllerFromViewController:self usingDelegate:self];
}

#pragma mark - Button Methods
-(IBAction)newBlock:(id)sender{
    [self createNewBlock];
}

-(IBAction)recordButtonPressed:(id)sender{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

#pragma mark - Camera Elements
-(BOOL) startCameraControllerFromViewController:(UIViewController *)controller usingDelegate:(id)delegate{
    // Validation
    // Need to access the camera
    if (([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] == NO) || (delegate == nil) || (controller == nil)){
        return NO;
    }
    
    // Get the image picker
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.videoMaximumDuration = 10.0;
    cameraUI.videoQuality = UIImagePickerControllerQualityTypeHigh;
    
    //Display control to allow user to select movie capture
    cameraUI.mediaTypes = [[NSArray alloc] initWithObjects:(NSString*)kUTTypeMovie, nil];
    
    // Hides controls for moving or scaling or trimming
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    
    // Display image picker
    [controller presentViewController:cameraUI animated:YES completion:nil];
    
    return  YES;
    
}

// Gives you a moviePath. You verify that the movie can be saved to the device’s photo album, and save it if so.
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    [self dismissViewControllerAnimated:NO completion:nil];
    
    // Handle movie capture
    // Verify that the movie can be saved to the device’s photo album
    if (CFStringCompare ((__bridge_retained CFStringRef) mediaType, kUTTypeMovie, 0) == kCFCompareEqualTo) {
        NSString *moviePath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        
        // default method provided by the SDK to save videos to the Photos Album. As parameters, you pass both the path to the video to be saved, as well as a callback method that will inform you of the status of the save operation.
        if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(moviePath)){
            NSLog(@"%@", moviePath);
            bMoviePath = moviePath;
            
            [self saveMovieToKinvey:moviePath];
            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

#pragma mark - Handlers
-(void)video:(NSString*)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{

    if(error){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Video Saving Failed"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Video Saved" message:@"Saved To Photo Album"
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
       [self createNewBlock];
    }
}

- (void)MPMoviePlayerDidExitFullscreen:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:nil];
    
    [movieplayer stop];
    [movieplayer.view removeFromSuperview];
}

#pragma mark - Kinvey
-(void)loginToKinvey{
    
    [KCSUser loginWithUsername:@"test" password:@"qqqqq" withCompletionBlock:^(KCSUser *user, NSError *errorOrNil, KCSUserActionResult result) {
        if (errorOrNil ==  nil) {
            NSLog(@"Login successful");
            
        } else {        //there was an error with the update save
            NSString* message = [errorOrNil localizedDescription];
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Create account failed", @"Sign account failed")
                                                            message:message
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                  otherButtonTitles: nil];
            [alert show];
        }
    }];
}

-(void)saveBlockToKinvey:(Block*)block{

    KCSCollection* collection = [KCSCollection collectionFromString:@"Blocks" ofClass:[BlockObj class]];
    KCSAppdataStore *store = [KCSAppdataStore storeWithCollection:collection options:nil];
    
    BlockObj* blockobj = [[BlockObj alloc] init];
    blockobj.userId = [KCSUser activeUser].userId;
    blockobj.name = [NSString stringWithFormat:@"%d", [block getBlockNumber]];
    blockobj.date = [NSDate dateWithTimeIntervalSince1970:1352149171]; //sample date
    
    [store saveObject:blockobj withCompletionBlock:^(NSArray *objectsOrNil, NSError *errorOrNil) {
        if (errorOrNil != nil) {
            //save failed, show an error alert
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Save failed", @"Save Failed")
                                                                message:[errorOrNil localizedFailureReason] //not actually localized
                                                               delegate:nil
                                                      cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                                                      otherButtonTitles:nil];
            [alertView show];
        } else {
            //save was successful
            NSLog(@"Successfully saved event (id='%@').", [objectsOrNil[0] kinveyObjectId]);
        }
    } withProgressBlock:nil];
}

-(void)saveMovieToKinvey:(NSString*)mPath{
    NSString* filename = @"movie.mov";
    NSURL* documentsDir = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL* sourceURL = [NSURL URLWithString:filename relativeToURL:documentsDir];
    
    [KCSFileStore uploadFile:sourceURL options:nil completionBlock:^(KCSFile *uploadInfo, NSError *error) {
        
        if (error == nil) {
            NSLog(@"Upload finished. File id='%@', error='%@'.", [uploadInfo fileId], error);
        }else{
            NSLog(@"Upload file error. File id='%@', error='%@'.", [uploadInfo fileId], error);
        }
        
    } progressBlock:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
