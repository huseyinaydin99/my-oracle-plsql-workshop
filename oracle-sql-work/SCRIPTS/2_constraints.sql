
ALTER TABLE regions ADD ( 
CONSTRAINT reg_id_pk PRIMARY KEY (region_id)
 )

/
ALTER TABLE countries ADD ( 
CONSTRAINT country_c_id_pk PRIMARY KEY (country_id) 
)

/
ALTER TABLE countries ADD ( 
CONSTRAINT countr_reg_fk FOREIGN KEY (region_id)
          	  REFERENCES regions(region_id) 
    )
/

ALTER TABLE locations ADD 
( CONSTRAINT loc_id_pk PRIMARY KEY (location_id)
  ,CONSTRAINT loc_c_id_fk
       		 FOREIGN KEY (country_id)
        	 REFERENCES countries(country_id) 
    )
/

ALTER TABLE departments ADD ( 
	CONSTRAINT dept_id_pk
       		 PRIMARY KEY (department_id)
    , CONSTRAINT dept_loc_fk
       		 FOREIGN KEY (location_id)
        	  REFERENCES locations (location_id)
     )
/
ALTER TABLE jobs ADD ( 
	CONSTRAINT job_id_pk PRIMARY KEY(job_id)
    )
/
ALTER TABLE employees ADD ( 
      CONSTRAINT     emp_emp_id_pk PRIMARY KEY (employee_id)
    , CONSTRAINT     emp_dept_fk FOREIGN KEY (department_id) REFERENCES departments (department_id)
    , CONSTRAINT     emp_job_fk FOREIGN KEY (job_id) REFERENCES jobs (job_id)
    , CONSTRAINT     emp_manager_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
    )
/
ALTER TABLE departments ADD ( 
	CONSTRAINT dept_mgr_fk FOREIGN KEY (manager_id) REFERENCES employees (employee_id)
    )
/
ALTER TABLE job_history ADD ( 
      CONSTRAINT jhist_emp_id_st_date_pk PRIMARY KEY (employee_id, start_date)
    , CONSTRAINT     jhist_job_fk FOREIGN KEY (job_id) REFERENCES jobs (job_id)
    , CONSTRAINT     jhist_emp_fk FOREIGN KEY (employee_id) REFERENCES employees (employee_id)
    , CONSTRAINT     jhist_dept_fk FOREIGN KEY (department_id) REFERENCES departments (department_id)
    )
/

