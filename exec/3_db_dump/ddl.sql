-- we don't know how to generate root <with-no-name> (class Root) :(

grant select on performance_schema.* to 'mysql.session'@localhost;

grant trigger on sys.* to 'mysql.sys'@localhost;

grant audit_abort_exempt, firewall_exempt, select, system_user on *.* to 'mysql.infoschema'@localhost;

grant audit_abort_exempt, authentication_policy_admin, backup_admin, clone_admin, connection_admin, firewall_exempt, persist_ro_variables_admin, session_variables_admin, system_user, system_variables_admin on *.* to 'mysql.session'@localhost;

grant audit_abort_exempt, firewall_exempt, system_user on *.* to 'mysql.sys'@localhost;

grant alter, alter routine, application_password_admin, create, create role, create routine, create temporary tables, create user, create view, delete, drop, drop role, event, execute, flush_optimizer_costs, flush_status, flush_tables, flush_user_resources, index, insert, lock tables, process, references, reload, replication client, replication slave, role_admin, select, sensitive_variables_observer, session_variables_admin, set_user_id, show databases, show view, show_routine, trigger, update, xa_recover_admin, grant option on *.* to rds_superuser_role;

grant alter, alter routine, application_password_admin, audit_abort_exempt, audit_admin, authentication_policy_admin, backup_admin, binlog_admin, binlog_encryption_admin, clone_admin, connection_admin, create, create role, create routine, create tablespace, create temporary tables, create user, create view, delete, drop, drop role, encryption_key_admin, event, execute, file, firewall_exempt, flush_optimizer_costs, flush_status, flush_tables, flush_user_resources, group_replication_admin, group_replication_stream, index, innodb_redo_log_archive, innodb_redo_log_enable, insert, lock tables, passwordless_user_admin, persist_ro_variables_admin, process, references, reload, replication client, replication slave, replication_applier, replication_slave_admin, resource_group_admin, resource_group_user, role_admin, select, sensitive_variables_observer, service_connection_admin, session_variables_admin, set_user_id, show databases, show view, show_routine, shutdown, super, system_user, system_variables_admin, table_encryption_admin, telemetry_log_admin, trigger, update, xa_recover_admin, grant option on *.* to rdsadmin@localhost;

create table brand
(
    id            int auto_increment
        primary key,
    created_at    datetime(6)  not null,
    updated_at    datetime(6)  not null,
    name          varchar(50)  not null,
    part_shop_url varchar(255) null
);

create table car_wash_shop
(
    id                   int auto_increment
        primary key,
    business_name        varchar(255) null,
    sido                 varchar(50)  null,
    sigungu              varchar(50)  null,
    business_type        varchar(100) null,
    car_wash_type        varchar(100) null,
    road_address         varchar(255) null,
    jibun_address        varchar(255) null,
    day_off              varchar(100) null,
    weekday_start_time   datetime     null,
    weekday_end_time     datetime     null,
    holiday_start_time   datetime     null,
    holiday_end_time     datetime     null,
    price_info           varchar(100) null,
    owner_name           varchar(100) null,
    phone                varchar(50)  null,
    water_license_number varchar(100) null,
    latitude             double       null,
    longitude            double       null,
    data_standard_date   datetime     null
);

create table card
(
    id                  int auto_increment
        primary key,
    created_at          datetime(6)  not null,
    updated_at          datetime(6)  not null,
    annual_fee_domestic int          null,
    annual_fee_global   int          null,
    card_unique_no      varchar(255) not null,
    image_url           text         null,
    issuer              varchar(100) not null,
    monthly_requirement int          null,
    name                varchar(100) not null,
    card_no             varchar(255) not null,
    cvc                 varchar(255) not null,
    constraint UK67qf89rtfgkd227jv4sygoqwg
        unique (card_unique_no)
);

create table card_benefit
(
    id         int auto_increment
        primary key,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    category   varchar(50) not null,
    unit       varchar(20) null,
    card_id    int         not null,
    constraint FK1myd5024jg8jtv3g8xjuxd00g
        foreign key (card_id) references card (id)
);

create table card_benefit_detail
(
    id                    int auto_increment
        primary key,
    created_at            datetime(6)                                                                 not null,
    updated_at            datetime(6)                                                                 not null,
    applies_to_all_brands bit                                                                         not null,
    discount_unit         varchar(20)                                                                 null,
    discount_value        int                                                                         not null,
    gas_station_brand     enum ('SKE', 'GSC', 'HDO', 'SOL', 'RTE', 'RTX', 'NHO', 'ETC', 'E1G', 'SKG') null,
    card_benefit_id       int                                                                         not null,
    constraint FK7ydshy7pt6gs5oms8ln09xecp
        foreign key (card_benefit_id) references card_benefit (id)
);

create table gas_station
(
    id                     int auto_increment
        primary key,
    address                varchar(255) null,
    brand                  varchar(50)  null,
    diesel_price           float        null,
    has_car_wash           bit          null,
    has_cvs                bit          null,
    has_lpg                bit          null,
    has_maintenance        bit          null,
    has_self_service       bit          null,
    latitude               float        null,
    longitude              float        null,
    lpg_price              float        null,
    name                   varchar(255) null,
    normal_gasoline_price  float        null,
    phone                  varchar(20)  null,
    premium_gasoline_price float        null,
    quality_certified      bit          null,
    road_address           varchar(255) null,
    standard_time          datetime(6)  null,
    kerosene_price         float        null,
    uni_id                 varchar(50)  not null
)
    collate = utf8mb4_unicode_ci;

create table insurance
(
    id         int auto_increment
        primary key,
    name       varchar(255) not null,
    created_at datetime(6)  not null,
    updated_at datetime(6)  not null
);

create table insurance_discount_rule
(
    id               int auto_increment
        primary key,
    discount_from_km int         not null,
    discount_rate    float       not null,
    discount_to_km   int         not null,
    insurance_id     int         not null,
    created_at       datetime(6) not null,
    updated_at       datetime(6) null,
    constraint FKb6fmn1lsp38kvosx89sofd9k0
        foreign key (insurance_id) references insurance (id)
);

create table member
(
    id                int auto_increment
        primary key,
    created_at        datetime(6)  not null,
    updated_at        datetime(6)  not null,
    email             varchar(100) not null,
    fuel_supply_limit int          not null,
    name              varchar(100) not null,
    oauth_id          varchar(255) not null,
    oauth_provider    varchar(10)  not null,
    password          varchar(100) not null,
    terms_agreed      bit          not null
);

create table account
(
    id                      int auto_increment
        primary key,
    created_at              datetime(6)  not null,
    updated_at              datetime(6)  not null,
    account_balance         bigint       not null,
    account_created_date    varchar(8)   not null,
    account_expiry_date     varchar(8)   not null,
    account_name            varchar(100) not null,
    account_no              varchar(20)  not null,
    account_type_code       varchar(10)  not null,
    account_type_name       varchar(50)  not null,
    bank_code               varchar(3)   not null,
    bank_name               varchar(100) not null,
    currency                varchar(3)   not null,
    daily_transfer_limit    bigint       not null,
    last_transaction_date   varchar(8)   null,
    one_time_transfer_limit bigint       not null,
    user_name               varchar(50)  not null,
    member_id               int          not null,
    constraint UKruxg86y66hmn0a129n4j75akk
        unique (account_no),
    constraint FKr5j0huynd7nsv1s7e9vb8qvwo
        foreign key (member_id) references member (id)
);

create table car
(
    id                            int auto_increment
        primary key,
    created_at                    datetime(6)                                                   not null,
    updated_at                    datetime(6)                                                   not null,
    fuel_efficiency               float                                                         null,
    fuel_level                    float                                                         null,
    fuel_type                     enum ('DIESEL', 'LPG', 'NORMAL_GASOLINE', 'PREMIUM_GASOLINE') not null,
    last_checked_date             datetime(6)                                                   null,
    last_update_date              datetime(6)                                                   null,
    model_name                    varchar(100)                                                  not null,
    nickname                      varchar(50)                                                   not null,
    obd2status                    enum ('CONNECTED', 'NOT_CONNECTED', 'UPDATED')                null,
    plate_number                  varchar(20)                                                   not null,
    score                         int                                                           null,
    tire_checked_date             datetime(6)                                                   null,
    total_distance                int                                                           null,
    vehicle_identification_number varchar(17)                                                   not null,
    brand_id                      int                                                           not null,
    member_id                     int                                                           not null,
    constraint UK2gfvvsmou1h7wy4atxx6u2jkw
        unique (plate_number),
    constraint UKj79htod55g8d1uio07rvhhkuy
        unique (vehicle_identification_number),
    constraint FK95ypklx20k37dl0r6q7bv4f8j
        foreign key (member_id) references member (id),
    constraint FKj1mws2ruu9q6k2sa4pwlxthxn
        foreign key (brand_id) references brand (id)
);

create table car_insurance
(
    id                         int auto_increment
        primary key,
    created_at                 datetime(6) not null,
    updated_at                 datetime(6) not null,
    distance_registration_date datetime(6) not null,
    end_date                   datetime(6) not null,
    insurance_premium          int         not null,
    registered_distance        int         not null,
    start_date                 datetime(6) not null,
    car_id                     int         not null,
    insurance_id               int         not null,
    constraint FK4tbafu1gdek83hn7p2r2ja3wt
        foreign key (insurance_id) references insurance (id),
    constraint FKcrtuj61ssdfo8jva26sygrp42
        foreign key (car_id) references car (id)
);

create table device_token
(
    id           bigint auto_increment
        primary key,
    created_at   datetime(6)  not null,
    updated_at   datetime(6)  not null,
    device_token varchar(255) not null,
    member_id    int          not null,
    constraint FKqbpc6xf21ge7sek3op9t4ru3v
        foreign key (member_id) references member (id)
);

create table dtc
(
    id         int auto_increment
        primary key,
    code       varchar(10) not null,
    car_id     int         null,
    created_at datetime(6) not null,
    updated_at datetime(6) not null,
    constraint fk_dtc_car_id
        foreign key (car_id) references car (id)
            on delete cascade
);

create table member_card
(
    id                        int auto_increment
        primary key,
    created_at                datetime(6) not null,
    updated_at                datetime(6) not null,
    card_id                   int         not null,
    member_id                 int         not null,
    card_previous_performance int         null,
    constraint FKnrtncuqhfypdeav3oot9ud573
        foreign key (member_id) references member (id),
    constraint FKrl78sktaeyrmwwet1pqt864k5
        foreign key (card_id) references card (id)
);

create table notification
(
    id                int auto_increment
        primary key,
    created_at        datetime(6)                                             not null,
    updated_at        datetime(6)                                             not null,
    message           varchar(255)                                            not null,
    notification_type enum ('FAULT', 'FUEL', 'GENERAL', 'MILEAGE', 'WEATHER') not null,
    read_status       bit                                                     not null,
    related_id        int                                                     not null,
    related_url       varchar(255)                                            not null,
    title             varchar(255)                                            not null,
    member_id         int                                                     not null,
    constraint FK1xep8o2ge7if6diclyyx53v4q
        foreign key (member_id) references member (id)
);

create table obd2
(
    id     int auto_increment
        primary key,
    car_id int          not null,
    code   varchar(255) not null,
    pid    varchar(255) not null,
    constraint FKksa8i6t752xjmv297msshe3i7
        foreign key (car_id) references car (id)
);

create table payment
(
    payment_type varchar(31)  not null,
    id           int auto_increment
        primary key,
    created_at   datetime(6)  not null,
    updated_at   datetime(6)  not null,
    location     varchar(100) null,
    memo         varchar(255) null,
    payment_date datetime(6)  not null,
    price        int          not null,
    car_id       int          not null,
    constraint FK36up63r9tkb7ao4ok4awbu3a4
        foreign key (car_id) references car (id)
);

create table oil_payment
(
    fuel_type enum ('DIESEL', 'LPG', 'NORMAL_GASOLINE', 'PREMIUM_GASOLINE') null,
    id        int                                                           not null
        primary key,
    constraint FK88l273fw9aciev5mtsnr4omjd
        foreign key (id) references payment (id)
            on delete cascade
);

create table payment_card
(
    id                 bigint auto_increment
        primary key,
    created_at         datetime(6) not null,
    updated_at         datetime(6) not null,
    card_type          tinyint     not null,
    discount_per_liter float       not null,
    name               varchar(50) not null,
    member_id          int         not null,
    constraint FKke375dlt1k1epsi2hwkoossaa
        foreign key (member_id) references member (id),
    check (`card_type` between 0 and 1)
);

create table repair_payment
(
    id           int         not null
        primary key,
    repair_parts varchar(50) null,
    constraint FK1dkdher7jjlpc1of16yh0xcln
        foreign key (id) references payment (id)
            on delete cascade
);

create table repair_shop
(
    id                   int auto_increment
        primary key,
    business_name        varchar(255) null,
    business_type        varchar(50)  null,
    road_address         varchar(255) null,
    jibun_address        varchar(255) null,
    latitude             double       null,
    longitude            double       null,
    registration_date    datetime     null,
    area_size            int          null,
    operation_status     varchar(10)  null,
    closure_date         datetime     null,
    suspend_start_date   datetime     null,
    suspend_end_date     datetime     null,
    operation_start_time datetime     null,
    operation_end_time   datetime     null,
    phone                varchar(50)  null,
    admin_agency         varchar(100) null,
    admin_phone          varchar(50)  null,
    data_standard_date   datetime     null
);

create table wash_payment
(
    wash_type enum ('AUTO_WASH', 'HAND_WASH') null,
    id        int                             not null
        primary key,
    constraint FK20onki3qe570qjlawd6wqytb2
        foreign key (id) references payment (id)
            on delete cascade
);

