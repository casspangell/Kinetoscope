//
//  ViewController.m
//  Kinetiscope
//
//  Created by Cass Pangell on 7/1/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import "ViewController.h"
#import "Block.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    blockArray = [[NSMutableArray alloc] init];
    
    UISwipeGestureRecognizer* swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeftGestureRecognizer];
    
    [self.scrollView setScrollEnabled:YES];

}

#pragma mark - Methods
-(void)createNewBlock{
    
    Block *newBlock = [[Block alloc] init];
    [blockArray addObject:newBlock];
    [newBlock setBlockNumber:[blockArray count]-1];

    /*CGFloat sideBuffer = 5;
    CGFloat blockAndBuffer = newBlock.getWidth + sideBuffer;
    CGFloat topBuffer = 20;
    int blockRow = 0;
    int rowCount = 0;

    for(int i=0; i<[blockArray count]; i++){

       if (i == 0) {
            //do nothing
        }else if (i % 3 == 0) {
            rowCount = 0;
            blockRow ++;
        }else{
            rowCount ++;
        }
        //NSLog(@"sidebuffer: %f rowCount: %d blockRow: %d blockAndBuffer: %f topBuffer: %f", sideBuffer, rowCount, blockRow, blockAndBuffer, topBuffer);
        newBlock.frame = CGRectMake(sideBuffer + (rowCount * blockAndBuffer), topBuffer + (blockRow * (newBlock.getHeight + sideBuffer)), newBlock.getWidth, newBlock.getHeight);
        [newBlock setTitle:[NSString stringWithFormat:@"%d", [newBlock getBlockNumber]] forState:(UIControlState)UIControlStateNormal];
        
        self.blockView.frame = CGRectMake(0, 0, 320, (topBuffer + ((blockRow+1) * (newBlock.getHeight + sideBuffer))));
        [self.scrollView setContentSize:CGSizeMake(self.blockView.frame.size.width, self.blockView.frame.size.height)];

        [self.blockView addSubview:newBlock];
    }*/
    
    [self reverseBlocks];

}

-(void)reverseBlocks{
    Block *block = [[Block alloc] init];
   // NSLog(@"%d",[blockArray count]);
    /*for (int i=[blockArray count]; i>0; i--) {
        block = [blockArray objectAtIndex:i-1];
        NSLog(@"%@, %d",block, [block getBlockNumber]);
    }*/
    
    CGFloat sideBuffer = 5;
    CGFloat blockAndBuffer = block.getWidth + sideBuffer;
    CGFloat topBuffer = 20;
    int blockRow = 0;
    int rowCount = 0;
    
    //for(int i=0; i<[blockArray count]; i++){
    for (int i = [blockArray count]; i>0; i--) {
        block = [blockArray objectAtIndex:i-1];
        
       if (i == [blockArray count]) {
            //do nothing
        }else if (i % 3 == 0) {
            rowCount = 0;
            blockRow ++;
        }else{
            rowCount ++;
        }

        //NSLog(@"sidebuffer: %f rowCount: %d blockRow: %d blockAndBuffer: %f topBuffer: %f", sideBuffer, rowCount, blockRow, blockAndBuffer, topBuffer);
        block.frame = CGRectMake(sideBuffer + (rowCount * blockAndBuffer), topBuffer + (blockRow * (block.getHeight + sideBuffer)), block.getWidth, block.getHeight);
        [block setTitle:[NSString stringWithFormat:@"%d", [block getBlockNumber]] forState:(UIControlState)UIControlStateNormal];
        
        self.blockView.frame = CGRectMake(0, 0, 320, (topBuffer + ((blockRow+1) * (block.getHeight + sideBuffer))));
        [self.scrollView setContentSize:CGSizeMake(self.blockView.frame.size.width, self.blockView.frame.size.height)];
        
        [self.blockView addSubview:block];
    }
    
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

            UISaveVideoAtPathToSavedPhotosAlbum(moviePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}

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



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
