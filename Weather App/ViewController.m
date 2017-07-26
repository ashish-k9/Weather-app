//
//  ViewController.m
//  Weather App
//
//  Created by Ashish kumar on 7/21/17.
//  Copyright © 2017 Ashish kumar. All rights reserved.
//

#import "ViewController.h"
#import "ForcastData.h"
#import "ForcastTableViewCell.h"
#import "StateCity.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate>
{
    NSMutableArray *forcastArray;
    StateCity *selCity;
    UIPickerView *pickerView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    forcastArray=[[NSMutableArray alloc]init];
    citiesArray=[[NSMutableArray alloc]init];
    NSString *path=[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"csv"];
    NSString* content = [NSString stringWithContentsOfFile:path
                                                  encoding:NSUTF8StringEncoding
                                                     error:NULL];
    
    
    NSArray *allLines = [content componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    for (NSString* line in allLines) {
        NSArray *elements = [line componentsSeparatedByString:@","];
        if(elements.count>=3){
        StateCity *sc=[[StateCity alloc] init];
        sc.city=elements[2];
        sc.state=elements[0];
            [citiesArray addObject:sc];
        }
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)pickerview:(id)sender{
    pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    pickerView.showsSelectionIndicator = YES;
    pickerView.dataSource = self;
    pickerView.delegate = self;
    
    // set change the inputView (default is keyboard) to UIPickerView
    cityTxtfield.inputView = pickerView;
    
    // add a toolbar with Cancel & Done button
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolBar.barStyle = UIBarStyleBlackOpaque;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneTouched:)];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTouched:)];
    // the middle button is to make the Done button align to right
    [toolBar setItems:[NSArray arrayWithObjects:cancelButton, [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneButton, nil]];
    cityTxtfield.inputAccessoryView = toolBar;
}
#pragma mark - doneTouched
- (void)cancelTouched:(UIBarButtonItem *)sender{
    // hide the picker view
    [cityTxtfield resignFirstResponder];
}
#pragma mark - doneTouched
- (void)doneTouched:(UIBarButtonItem *)sender{
    // hide the picker view
    selCity=citiesArray[[pickerView selectedRowInComponent:0]];
    [cityTxtfield resignFirstResponder];
    [self getWetherData:selCity.state city:selCity.city];
    // perform some action
}
#pragma mark - The Picker Challenge
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [citiesArray count];
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow: (NSInteger)row forComponent:(NSInteger)component{
    StateCity *Sc=citiesArray[row];

    return Sc.city;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selCity=citiesArray[row];
    cityTxtfield.text = selCity.city;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self pickerview:nil];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getWetherData:(NSString*)state city:(NSString*)city{
    [forcastArray removeAllObjects];
    NSDictionary *headers = @{ @"cache-control": @"no-cache",
                               @"postman-token": @"80a9088c-2767-b2c1-7b84-6246f51d74db" };
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.wunderground.com/api/205d16bd5c911aec/forecast/q/%@/%@.json",state,[city stringByReplacingOccurrencesOfString:@" " withString:@"_"]]]
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:10.0];
    [request setHTTPMethod:@"GET"];
    [request setAllHTTPHeaderFields:headers];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                    if (error) {
                                                        NSLog(@"%@", error);
                                                    } else {
                                                        
                                                        NSError* error;
                                                        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                                             options:kNilOptions
                                                                                                               error:&error];
                                                        NSMutableDictionary *sampleDict=[[NSMutableDictionary alloc]init];
                                                        NSDictionary *tempforcastDictionary=[json[@"forecast"] objectForKey:@"txt_forecast"];
                                                        NSArray *temp_txtforecastArry=[tempforcastDictionary objectForKey:@"forecastday"];
                                                        for(NSDictionary *sdict in temp_txtforecastArry){
                                                            [sampleDict setObject:sdict forKey:sdict[@"title"]];
                                                        }
                                                        NSDictionary *forcastDictionary=[json[@"forecast"] objectForKey:@"simpleforecast"];
                                                        NSArray *tempforecastArry=[forcastDictionary objectForKey:@"forecastday"];
                                                        
                                                        for(NSDictionary *dict in tempforecastArry){
                                                            [forcastArray addObject:[[ForcastData alloc]initWithDictionary:dict description:sampleDict]];
                                                        }
                                                        dispatch_async(dispatch_get_main_queue(), ^{
                                                            [forcastTableView reloadData];
                                                        });

                                                        }
                                                }];
    [dataTask resume];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120.0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return forcastArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ForcastTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    ForcastData *Castdata=[forcastArray objectAtIndex:indexPath.row];
    
    //you can use any string instead "com.mycompany.myqueue"
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.mycompany.myqueue", 0);
    
    dispatch_async(backgroundQueue, ^{
         UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:Castdata.imageUrl]]];

        dispatch_async(dispatch_get_main_queue(), ^{
            cell.forcastIcon.image=img;
        });
    });
    cell.highTemp.text=[NSString stringWithFormat:@"High Temp : %@ °F",Castdata.highTemp];
    cell.LowTemp.text=[NSString stringWithFormat:@"Low Temp : %@ °F",Castdata.LowTemp];
    cell.forcastTitle.text=Castdata.title;
    cell.forcastdescription.text=Castdata.forcastDescription;
    return cell;
}

@end
