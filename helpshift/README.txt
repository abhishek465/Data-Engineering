Software Requirment :-
--------------------
Oracle 11gR2

Directories :-
-------------
1. script :- It contains all codes.
2. visual :- It contains images of Data visualization.

Instruction to build solution :-
------------------------------
Login to Oracle User
1. Run table_creation.sql file.
2. Modify sample.ctl file line 2 
    2.1:- If OS is Windows :-
	 infile '<path_of_your_dat_file>\restaurant_hours.csv'
	 Ex :-  infile 'C:\Users\Tarun\Downloads\abhishek\restaurant_hours.csv'
    2.2:- If OS is Linux :-
	 infile '<path_of_your_dat_file>/restaurant_hours.csv'
	 Ex :-  infile '/home/abhishek/restaurant_hours.csv'
3. Run the below command from another command prompt  
    3.1.:-If OS is Windows :- 
          sqlldr <user_name>/<password> control=<path_where_control_file_is_located>\sample.ctl log=<path_where_you_want_log_file>\data_load_log.txt 
	  Ex :- sqlldr system/abhi control=C:\Users\Tarun\Downloads\abhishek\sample.ctl log=C:\Users\Tarun\Downloads\abhishek\data_load_log.txt 
    3.2 :-If OS is Linux :-
          sqlldr <user_name>/<password> control=<path_where_control_file_is_located>/sample.ctl log=<path_where_you_want_log_file>/data_load_log.txt 
4. Run restaurant_data_wrangling.sql file from Oracle login user command prompt
5. Run restaurant_date_conversion.sql file from Oracle login user command prompt
6. Run restaurant_total_open_time_calculation.sql file from Oracle login user command prompt
7. Run get_open_restaurants.sql file from Oracle login user command prompt.
   
   Parameters required :- (p_date,p_format)
   Default value of p_format :- 'dd/mm/yyyy hh12:mi:ss'
   
   NOTE :- Code support below Mentioned Datetime format. Apart from these format will give you error message. 
	   7.1. :- 'dd/mm/yyyy hh12:mi:ss' 
	   7.2. :- 'dd-mm-yyyy hh12:mi:ss' 
	   7.3. :- 'dd/mm/yy hh12:mi:ss' 
	   7.4. :- 'dd-mm-yy hh12:mi:ss'
	   7.5. :- 'yyyy-mm-dd hh12:mi:ss' 
	   7.6. :- 'yyyy/mm/dd hh12:mi:ss'
	   7.7. :- 'yy/mm/dd hh12:mi:ss' 
	   7.8. :- 'yy-mm-dd hh12:mi:ss' 


Instruction to Run your solution :-
---------------------------------

Solution of Problem 1 :-
----------------------

 You can run the solution from sql stmt. or PL/SQL block. Below is the example to run the solution from sql stmt. with default datetime format.
 
 Ex :- select get_open_restaurants('21/08/2016 7:55:00 PM') from dual;

 If datetime format is other then 'dd/mm/yyyy hh12:mi:ss' then you have to specify the format.

 Ex :- select get_open_restaurants('21/08/2016 7:55:00 PM','dd/mm/yyyy hh12:mi:ss') from dual;

 Solution of Problem 2 & 3 :-
--------------------------

Problem 2 is solved with the help of sql as well as Data Visualisation.

2-a&c:- Refer "summary of data" & "Most frequent items from total_open_time Categorical view" images. 
       In "Most frequent items from total_open_time Categorical view" image, check Value column to check the longest :-
       Only one data point is available which operates 17 hr followed by 14.3 (a.k.a. 14:30), 14, 13.3 (a.k.a. 14:30) and others.

       As this is a open ended problem, So I am considering all the Data Point whose operation is greater than 12 hr as a longest open hour.

       select name from Restaurant_analysis where total_open_time>12;

       Similarly, all the data points whose whose operation is in between 4 and 5 hr as a shortest open hour.

       select name from Restaurant_analysis where total_open_time >=4 and total_open_time <=5;

2-b :- Breakfast :- 7 to 9:30 PM (Refer "Most frequent items from start_time Categorical view" & "Most frequent items from start_time Numerical view" Image) 
       Lunch :- 11:30 AM to 2 PM (Refer Boxwhisker images)
       Dinner :- 8 to 10 PM	(Refer "Most frequent items from end_time Categorical view" & "Most frequent items from end_time Numerical view" Image) 

Other Visualization is also available.