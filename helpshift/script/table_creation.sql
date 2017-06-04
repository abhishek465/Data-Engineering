/*===================================================================
* File name     : table_creation.sql
* Author        : Abhishek
* Date          : 21-Aug-2016
* Client        : Helpshift
* System        : Test
* Module        : Test
* Description   : create tables in database
* Modification History
* Date           Pgmr          Description
* 21-Aug-2016    Abhishek     create tables in database with Raw_Restaurant & Restaurant_analysis name
*==================================================================*/

create table Raw_Restaurant
(
	Restaurant_name varchar2(100),
	open_day varchar2(100)
);

create table Restaurant_analysis
(
	Restaurant_name varchar2(100),
	open_day varchar2(100),
	start_time varchar2(10),
	end_time varchar2(10),
	total_open_time number
);
