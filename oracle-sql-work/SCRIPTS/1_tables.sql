CREATE TABLE regions
    ( region_id      NUMBER
    , region_name    VARCHAR2(25) 
    )
/
CREATE TABLE countries 
    ( country_id      CHAR(2) 
    , country_name    VARCHAR2(40) 
    , region_id       NUMBER 
    )
/
CREATE TABLE locations
    ( location_id    NUMBER(4)
    , street_address VARCHAR2(40)
    , postal_code    VARCHAR2(12)
    , city       VARCHAR2(30) not null
    , state_province VARCHAR2(25)
    , country_id     CHAR(2)
    )
/
CREATE TABLE departments
    ( department_id    NUMBER(4)
    , department_name  VARCHAR2(30) NOT NULL
    , manager_id       NUMBER(6)
    , location_id      NUMBER(4)
    )
/
CREATE TABLE jobs
    ( job_id         VARCHAR2(10)
    , job_title      VARCHAR2(35)
	CONSTRAINT     job_title_nn  NOT NULL
    , min_salary     NUMBER(6)
    , max_salary     NUMBER(6)
    )
/
CREATE TABLE employees
    ( employee_id    NUMBER(6)
    , first_name     VARCHAR2(20)
    , last_name      VARCHAR2(25) NOT NULL
    , email          VARCHAR2(25) NOT NULL
    , phone_number   VARCHAR2(20)
    , hire_date      DATE NOT NULL
    , job_id         VARCHAR2(10) NOT NULL
    , salary         NUMBER(8,2)
    , commission_pct NUMBER(2,2)
    , manager_id     NUMBER(6)
    , department_id  NUMBER(4)
    , CONSTRAINT     emp_salary_min
                     CHECK (salary > 0) 
    , CONSTRAINT     emp_email_uk
                     UNIQUE (email)
    )
/
CREATE TABLE job_history
    ( employee_id   NUMBER(6) NOT NULL
    , start_date    DATE NOT NULL
    , end_date      DATE NOT NULL
    , job_id        VARCHAR2(10) NOT NULL
    , department_id NUMBER(4)
    , CONSTRAINT    jhist_date_interval
                    CHECK (end_date > start_date)
    )
/