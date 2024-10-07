-- 멤버(유저)
CREATE TABLE member
(
    id             INT auto_increment NOT NULL,
    member_id      varchar(100)       not null,
    member_name    VARCHAR(50)        NOT NULL,
    member_phone   varchar(20)        not null,
    member_nick    varchar(255)       not null,
    member_pwd     varchar(50)        not null,
    member_address varchar(255)       not null,
    member_email   varchar(255),
    member_status  boolean default true,
    member_gender  enum ('M','F'),
    member_point   int(10),
    CONSTRAINT user_pk PRIMARY KEY (id),
    CONSTRAINT user_unique_member_id UNIQUE KEY (member_id),
    CONSTRAINT user_unique_member_email UNIQUE KEY (member_email),
    constraint user_unique_member_nick unique key (member_nick)
);

-- 멤버가 작성한 글
CREATE TABLE content
(
    id         INT auto_increment                  NOT NULL,
    title      varchar(255)                        NOT NULL,
    content    varchar(1000)                       NOT NULL,
    member_id  VARCHAR(100)                        NOT NULL,
    create_day TIMESTAMP DEFAULT CURRENT_TIMESTAMP NULL,
    update_day TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    constraint fk_content_member foreign key (member_id) references member (member_id) on delete cascade
);

-- 상품
create table product
(
    proudct_id     int auto_increment not null,
    product_name   varchar(255)       not null,
    product_price  int(10)            not null,
    product_option varchar(255)       not null,
    PRIMARY KEY (proudct_id)
);
-- 회사
create table compony
(
    compony_id      int auto_increment not null,
    compony_name    varchar(255)       not null,
    compony_address varchar(255)       not null,
    compony_email   varchar(255)       not null,
    compony_phone   varchar(15)        not null,
    compony_number  varchar(10)        not null,
    primary key (compony_id)
);

-- 관리자
CREATE TABLE admin
(
    id          INT AUTO_INCREMENT NOT NULL,
    admin_id    VARCHAR(100)       NOT NULL UNIQUE,  -- 관리자의 ID
    admin_name  VARCHAR(50)        NOT NULL,         -- 관리자의 이름
    admin_pwd   VARCHAR(255)       NOT NULL,         -- 비밀번호 (해싱된 상태로 저장)
    admin_email VARCHAR(255) UNIQUE,                 -- 관리자 이메일
    create_day  TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 계정 생성 일자
    PRIMARY KEY (id)
);

-- 장바구니
CREATE TABLE cart
(
    cart_id    INT AUTO_INCREMENT NOT NULL,
    member_id  VARCHAR(100)       NOT NULL,
    product_id INT(11)            NOT NULL,
    quantity   INT                NOT NULL DEFAULT 0, -- 장바구니 수량
    added_at   TIMESTAMP                   DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (cart_id),
    CONSTRAINT fk_member FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE,
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES product (proudct_id) ON DELETE CASCADE
);

-- 신고게시판
CREATE TABLE report
(
    id            INT AUTO_INCREMENT NOT NULL,
    member_id     VARCHAR(100)       NOT NULL,
    content_id    INT                NOT NULL,
    report_reason VARCHAR(255)       NOT NULL,
    create_day    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_report_member FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE,
    CONSTRAINT fk_report_content FOREIGN KEY (content_id) REFERENCES content (id) ON DELETE CASCADE
);

-- 문의 게시판
CREATE TABLE inquiries
(
    id            INT AUTO_INCREMENT NOT NULL,
    member_id     VARCHAR(100)       NOT NULL,
    inquiry_text  TEXT               NOT NULL,
    response_text TEXT,
    create_day    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_day    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    CONSTRAINT fk_inquiry_member FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE
);

-- 공지사항
CREATE TABLE notice
(
    id         INT AUTO_INCREMENT NOT NULL,
    title      VARCHAR(255)       NOT NULL,
    content    TEXT               NOT NULL,
    create_day TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    update_day TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

-- 댓글
CREATE TABLE comment
(
    id         INT AUTO_INCREMENT NOT NULL,
    report_id  INT,                                 -- 신고 ID (NULL 가능, 문의에 대한 댓글인 경우)
    inquiry_id INT,                                 -- 문의 ID (NULL 가능, 신고에 대한 댓글인 경우)
    member_id  VARCHAR(100)       NOT NULL,         -- 댓글 작성자 (회원 ID)
    admin_id   VARCHAR(100),                        -- 댓글 작성자 (관리자 ID, NULL 가능)
    comment    TEXT               NOT NULL,         -- 댓글 내용
    create_day TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 댓글 작성 일자
    PRIMARY KEY (id),
    CONSTRAINT fk_comment_report FOREIGN KEY (report_id) REFERENCES report (id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_inquiry FOREIGN KEY (inquiry_id) REFERENCES inquiries (id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_member FOREIGN KEY (member_id) REFERENCES member (member_id) ON DELETE CASCADE,
    CONSTRAINT fk_comment_admin FOREIGN KEY (admin_id) REFERENCES admin (admin_id) ON DELETE CASCADE
);
