-- Shrey Patel
-- Final Exam
-- Part 3 SQL Script


--Drop Sequences if they were already created:
DROP SEQUENCE resident_identifier_seq;


-- Drop tables if they were already created:
DROP TABLE counties;

DROP TABLE cities;

DROP TABLE zip_codes;

DROP TABLE residents;

DROP TABLE testing_centers;

DROP TABLE multiple_phones;

DROP TABLE testing_information;


-- Creating sequences for each of the primary key's, also known as the identifiers
CREATE SEQUENCE resident_identifier_seq START WITH 1 INCREMENT BY 1;


-- Creating tables:
CREATE TABLE counties (
    county_identifier INT PRIMARY KEY,
    county_name       VARCHAR2(50) UNIQUE NOT NULL,
    population        NUMBER NOT NULL
);

CREATE TABLE cities (
    city_identifier   INT PRIMARY KEY,
    city_name         VARCHAR(50) NOT NULL,
    population        NUMBER NOT NULL,
    county_identifier INT NOT NULL,
    CONSTRAINT fk_citys_county_identifier FOREIGN KEY ( county_identifier )
        REFERENCES counties ( county_identifier )
);

CREATE TABLE zip_codes (
    zip_code_identifier INT PRIMARY KEY,
    zip_code            VARCHAR2(10) UNIQUE NOT NULL,
    city_identifier     INT NOT NULL,
    CONSTRAINT fk_city_zip_codes FOREIGN KEY ( city_identifier )
        REFERENCES cities ( city_identifier )
);

CREATE TABLE residents (
    resident_identifier INT DEFAULT resident_identifier_seq.NEXTVAL PRIMARY KEY,
    ssn                 NUMBER UNIQUE NOT NULL,
    first_name          VARCHAR2(50) NOT NULL,
    last_name           VARCHAR2(50) NOT NULL,
    street_address      VARCHAR2(200) NOT NULL,
    birthdate           DATE NOT NULL,
    zip_code_identifier INT NOT NULL,
    CONSTRAINT fk_residents_zip_code FOREIGN KEY ( zip_code_identifier )
        REFERENCES zip_codes ( zip_code_identifier )
);

CREATE TABLE testing_centers (
    testing_center_identifier INT PRIMARY KEY,
    center_name               VARCHAR2(100) NOT NULL,
    center_phone              NUMBER(11) NOT NULL,
    center_street_address     VARCHAR2(200) NOT NULL,
    zip_code_identifier       INT NOT NULL,
    CONSTRAINT fk_testing_center_zip FOREIGN KEY ( zip_code_identifier )
        REFERENCES zip_codes ( zip_code_identifier )
);

CREATE TABLE multiple_phones (
    multiple_phones     VARCHAR2(15),
    resident_identifier INT NOT NULL,
    PRIMARY KEY ( multiple_phones,
                  resident_identifier ),
    CONSTRAINT fk_resident__multiple_phones FOREIGN KEY ( resident_identifier )
        REFERENCES residents ( resident_identifier )
);

CREATE TABLE testing_information (
    test_date                 DATE NOT NULL PRIMARY KEY,
    testing_center_identifier INT NOT NULL,
    resident_identifier       INT NOT NULL,
    test_result               VARCHAR2(50) NOT NULL,
    CONSTRAINT fk_test_center_identifier FOREIGN KEY ( testing_center_identifier )
        REFERENCES testing_centers ( testing_center_identifier ),
    CONSTRAINT fg_resident_testing_info FOREIGN KEY ( resident_identifier )
        REFERENCES residents ( resident_identifier )
);


-- Creating a relevant index:
-- City_Name in the CITIES table is useful for searches or groupings by city.
CREATE INDEX index_city_name ON
    cities (
        city_name
    );