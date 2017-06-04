/*===================================================================
* File name     : restaurant_total_open_time_calculation.sql
* Author        : Abhishek
* Date          : 21-Aug-2016
* Client        : Helpshift
* System        : Test
* Module        : Test
* Description   : Data population script for total_open_time column in Restaurant_analysis Table
* Modification History
* Date           Pgmr          Description
* 21-Aug-2016    Abhishek     Script developed for updating total_open_time column 
*==================================================================*/


declare
	v_total_open_time number;
begin
	for i in (select * from Restaurant_analysis)
	loop
		if i.end_time between 0 and 4 then
			v_total_open_time := replace(23-to_number(i.start_time)+to_number(i.end_time)+1,'.7','.3');
		else
			v_total_open_time := to_number(replace(i.end_time - i.start_time,'.7','.3'));
			
		end if;
		update Restaurant_analysis set total_open_time = v_total_open_time where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
	end loop;
	commit;
end;
/
