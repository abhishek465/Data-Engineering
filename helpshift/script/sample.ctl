 load data
 infile 'C:\Users\Tarun\Downloads\abhishek\restaurant_hours.csv'
 into table Raw_Restaurant
 fields terminated by ","
 optionally enclosed by '"'
 ( Restaurant_name,
   open_day 
 )