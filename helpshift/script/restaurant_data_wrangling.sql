/*===================================================================
* File name     : restaurant_data_wrangling.sql
* Author        : Abhishek
* Date          : 21-Aug-2016
* Client        : Helpshift
* System        : Test
* Module        : Test
* Description   : Data Normalization and population script for Restaurant_analysis Table
* Modification History
* Date           Pgmr          Description
* 21-Aug-2016    Abhishek     Script developed for restaurant data wrangling
*==================================================================*/

declare
 t VARCHAR2(100);
 t1 VARCHAR2(100);
 ctr number;
 v_open_day VARCHAR2(100);
    
begin
 for i in (select * from Raw_Restaurant)
 loop
   
	   if (i.open_day not like '%/%')then
		  if (i.open_day not like '%,%') then
				if substr(i.open_day,1,instr(i.open_day,'-')+3)like '%Mon-Sun%' then
				  v_open_day := replace(trim(substr(i.open_day,instr(i.open_day,'-')+4)),' ','');
				  insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thr,Fri,Sat,Sun' || v_open_day);
				end if;
		  else
			  if substr(i.open_day,instr(i.open_day,'-')-3,instr(i.open_day,'-')+3)like '%Wed-Sun%' then
			   v_open_day :=substr(i.open_day,instr(i.open_day,'-')+4);
			   insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,trim(substr(i.open_day,1,instr(i.open_day,'-')-4))||'Wed,Thr,Fri,Sat,Sun' || v_open_day);
			  end if;
		  end if;
	   else
		  select regexp_count(i.open_day,'/') into ctr FROM dual;
		  --dbms_output.put_line(i.Restaurant_name ||','||i.open_day || '------------' || ctr);
			if substr(i.open_day,1,instr(i.open_day,'/')-1)like '%Mon%' then
			  t := substr(i.open_day,1,instr(i.open_day,'/')-1);
			  if regexp_count(t,',')>0 then
				  if t like '%Thu%' then
						v_open_day := trim(substr(t,instr(t,',')+1));
						insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu,'|| v_open_day);
				  ELSIF t like '%Sat%' then
						v_open_day := trim(substr(t,instr(t,',')+1));
						insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu,Fri,Sat,'|| v_open_day);
				  ELSIF t like '%Fri%' then
						v_open_day := trim(substr(t,instr(t,',')+1));
						insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu,Fri,' || v_open_day);
				  ELSE
						NULL;
				  END IF;
			  else
				if t like '%Thu%' then
					if regexp_count(t,',')>0 then
					  v_open_day := trim(substr(t,instr(t,',')+1));
					  insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu' || v_open_day);
					else
					  v_open_day := substr(t,8);
					  insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu' || v_open_day);
					  t := replace(i.open_day,substr(i.open_day,1,instr(i.open_day,'/')+1),'');
					  --dbms_output.put_line('D3----'||t);
					  if regexp_count(t,'/')>0 then
							t1 := trim(substr(t,1,instr(t,'/')-1));
							if t1 like '%Fri-Sat%' or t1 like '%Fri%' then
							  insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,t1);
							  t1 := replace(t,substr(t,1,instr(t,'/')-1),'');
							  if regexp_count(t1,'/')>0 then
									--dbms_output.put_line('D1--------'||t1);
									t := substr(t1,instr(t1,'/')+1);
									
									if regexp_count(t,'/')>0 then
									  insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,trim(substr(t,1,instr(t,'/')-1)));
									  insert into Restaurant_analysis (Restaurant_name,open_day) values(i.Restaurant_name,trim(substr(t,instr(t,'/')+1)));
									else
									  insert into Restaurant_analysis (Restaurant_name,open_day)values (i.Restaurant_name,t);
									end if;
							  end if;
							end if;
						  end if;
						end if;
				ELSIF t like '%Sat%' then
					  if regexp_count(t,',')>0 then
						   insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu,Fri,Sat'||trim(substr(t,instr(t,',')+1)));
					  else
							insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu,Fri,Sat'||substr(t,8));
					  end if;
				ELSIF t like '%Fri%' then
					  if regexp_count(t,',')>0 then
						   insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu,Fri'||trim(substr(t,instr(t,',')+1)));
					  else
							insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed,Thu,Fri'||substr(t,8));
					  end if;
				ELSIF t like '%Wed%' then
					  if regexp_count(t,',')>0 then
						   insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed'||trim(substr(t,instr(t,',')+1)));
					  else
						insert into Restaurant_analysis (Restaurant_name,open_day)values(i.Restaurant_name,'Mon,Tue,Wed'||substr(t,8));
						t := substr(i.open_day,length(t));
						
						if regexp_count(t,'/')>0 then
						  t1 := substr(t,instr(t,'/')+1);
						  --dbms_output.put_line('t1.....' || t1);
						  if regexp_count(t1,'/')>0 then
								insert into Restaurant_analysis (Restaurant_name,open_day) values(i.Restaurant_name,substr(t1,1,instr(t1,'/')-1));
								t1 := replace(t1,substr(t1,1,instr(t1,'/')),'');
								
								if regexp_count(t1,'/')>0 then
								  insert into Restaurant_analysis (Restaurant_name,open_day) values(i.Restaurant_name,substr(t1,1,instr(t1,'/')-1));
								  insert into Restaurant_analysis (Restaurant_name,open_day) values(i.Restaurant_name,substr(t1,instr(t1,'/')+1));
								end if;
						  end if;
						end if;
					  end if;
				ELSE
				  NULL;
				END IF;
			  end if;
			  if regexp_count(substr(i.open_day,instr(i.open_day,'/')+1),'/') =0 then
					insert into Restaurant_analysis (Restaurant_name,open_day) values(i.Restaurant_name,trim(substr(i.open_day,instr(i.open_day,'/')+1)));
			  end if;
			end if;
		  
	   end if;
	end loop;
 commit;
  
    update Restaurant_analysis set open_day = replace(open_day,' ','');
	for i in (select * from Restaurant_analysis t where regexp_count(open_day,'-')>1)
	loop
	  update Restaurant_analysis set open_day=substr(i.open_day,1,instr(i.open_day,'-')-1)||','||substr(i.open_day,instr(i.open_day,'-')+1) where Restaurant_name=i.Restaurant_name and open_day=i.open_day;
	end loop;
	commit;
	for i in (select rowid, Restaurant_name, open_day from Restaurant_analysis t )
	loop
	  t := substr(i.open_day,1,instr(i.open_day,',',-1)+3);
	  update Restaurant_analysis set end_time=substr(i.open_day,instr(i.open_day,'-')+1), start_time=substr(substr(open_day,instr(open_day,',',-1)+4),1,instr(substr(open_day,instr(open_day,',',-1)+4),'-')-1),open_day=t where Restaurant_name=i.Restaurant_name and open_day=i.open_day;
	end loop;
	commit;

end;
/
