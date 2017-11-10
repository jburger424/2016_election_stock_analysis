CREATE TABLE s_and_p(
        symbol      VARCHAR(10)             NOT NULL,
        company_name  VARCHAR(50)            NOT NULL,
        sector  VARCHAR(50)            NOT NULL,
        sub_industry VARCHAR(50)     NOT NULL,
        city   VARCHAR(50)     NOT NULL,
        state   VARCHAR(50)     NOT NULL,
        PRIMARY KEY (symbol),
        FOREIGN KEY (city, state)
            REFERENCES cities(city, state)
);
CREATE TABLE cities(
        zip      CHAR(5)             NOT NULL,
        city   VARCHAR(50)     NOT NULL,
        state   VARCHAR(50)     NOT NULL,
        state_code   CHAR(2) NOT NULL,
        county   VARCHAR(50)     NOT NULL,
        county_code   INT(2) NOT NULL,
        latitude   VARCHAR(50)     NOT NULL,
        longitude   VARCHAR(50)     NOT NULL
);

CREATE TABLE pres_results(
        county      VARCHAR(50)             NOT NULL,
        fips   INTEGER(10)     NOT NULL,
        cand   VARCHAR(50)     NOT NULL,
        st   CHAR(2) NOT NULL,
        pct_report   NUMERIC    NOT NULL,
        votes   INT(7) NOT NULL,
        total_votes   INT(7)     NOT NULL,
        pct   NUMERIC     NOT NULL,
        lead   VARCHAR(50)     NOT NULL
);

CREATE TABLE stocks(
symbol varchar(10) NOT NULL,
slope_diff NUMERIC NOT NULL
);
