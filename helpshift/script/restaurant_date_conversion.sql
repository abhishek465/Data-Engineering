/*===================================================================
* File name     : restaurant_date_conversion.sql
* Author        : Abhishek
* Date          : 21-Aug-2016
* Client        : Helpshift
* System        : Test
* Module        : Test
* Description   : Convert Time into 24 hr format and replace ":" by "." in time
* Modification History
* Date           Pgmr          Description
* 21-Aug-2016    Abhishek     Convert Time into 24 hr format and replace ":" by "." in time
*==================================================================*/

declare
	v_num number;
begin
  for i in (select distinct Restaurant_name,open_day,start_time,end_time from Restaurant_analysis)
  loop
		if i.start_time like '%pm%'  then
		   if nvl(nullif(to_number(replace(substr(i.start_time,1,length(i.start_time)-2),':','.')) , 12),0) != 0 then
				v_num := 12 + to_number(replace(substr(i.start_time,1,length(i.start_time)-2),':','.'));
				update Restaurant_analysis set start_time = v_num where Restaurant_name = i.Restaurant_name and open_day = i.open_day;	
		   elsif nvl(nullif(to_number(replace(substr(i.start_time,1,length(i.start_time)-2),':','.')) , 12),0) = 0 then
				v_num := to_number(replace(substr(i.start_time,1,length(i.start_time)-2),':','.'));
				update Restaurant_analysis set start_time = v_num where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
		   else
				null;			
		   end if;
		elsif i.start_time like '%am%' then
				v_num := to_number(replace(substr(i.start_time,1,length(i.start_time)-2),':','.'));
				if v_num between 12 and 12.59 then
					if v_num =12 then
						update Restaurant_analysis set start_time = 24 where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
					else
						update Restaurant_analysis set start_time = 00 ||'.'||substr(v_num,instr(v_num,'.')+1) where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
					end if;
				else
				   update Restaurant_analysis set start_time = v_num where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
				end if;
		else
			null;
		end if;
		
		if i.end_time like '%pm%' then
			 if nvl(nullif(to_number(replace(substr(i.end_time,1,length(i.end_time)-2),':','.')) , 12),0) != 0 then
				   v_num := 12 + to_number(replace(substr(i.end_time,1,length(i.end_time)-2),':','.'));
				   update Restaurant_analysis set end_time = v_num where Restaurant_name = i.Restaurant_name and open_day = i.open_day;	
			 elsif nvl(nullif(to_number(replace(substr(i.end_time,1,length(i.end_time)-2),':','.')) , 12),0) = 0 then
				   v_num := to_number(replace(substr(i.end_time,1,length(i.end_time)-2),':','.'));
				   update Restaurant_analysis set end_time = v_num where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
			 else
				   null;
			 end if;			
		elsif i.end_time like '%am%' then
			 v_num := to_number(replace(substr(i.end_time,1,length(i.end_time)-2),':','.'));
			 if v_num between 12 and 12.59 then
					if v_num =12 then
						update Restaurant_analysis set end_time = 24  where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
					else
						update Restaurant_analysis set end_time = 00 ||'.'||substr(v_num,instr(v_num,'.')+1) where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
					end if;
			 else
				update Restaurant_analysis set end_time = v_num where Restaurant_name = i.Restaurant_name and open_day = i.open_day;
			 end if;
		else
			NULL;
		end if;
  end loop;
  commit;
end;
/
