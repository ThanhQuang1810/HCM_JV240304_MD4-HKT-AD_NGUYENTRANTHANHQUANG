create database MD04_Database_ThucHanh_AD;
use  MD04_Database_ThucHanh_AD;
drop database MD04_Database_ThucHanh_AD;
CREATE TABLE Category (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL UNIQUE,
    status TINYINT DEFAULT 1 CHECK (status IN (0 , 1))
);

CREATE TABLE Room (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    status TINYINT DEFAULT 1 CHECK (status IN (0, 1)),
    price FLOAT NOT NULL CHECK (price >= 100000),
    salePrice FLOAT DEFAULT 0,
    createdDate DATE DEFAULT(curdate()),
    categoryId INT NOT NULL,
    INDEX idx_name (name),
    INDEX idx_createddate (createdDate),
    INDEX idx_price (price)
);


CREATE TABLE customer (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+.[A-Z|a-z]{2,}$'),
    phone VARCHAR(50) NOT NULL UNIQUE,
    address VARCHAR(255),
    createdDate DATE DEFAULT(curdate()) ,
    gender TINYINT NOT NULL CHECK (gender IN (0 , 1, 2)),
    birthday DATE NOT NULL
);

CREATE TABLE booking (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customerId INT NOT NULL,
    status TINYINT DEFAULT 1 CHECK (status IN (0 , 1, 2, 3)),
    bookingdate DATETIME DEFAULT(curdate())
);

CREATE TABLE bookingdetail (
    bookingId INT NOT NULL,
    roomId INT NOT NULL,
    price FLOAT NOT NULL,
    startDate DATETIME NOT NULL,
    endDate DATETIME NOT NULL 
);

ALTER table room add foreign key (categoryId) references Category(id);
ALTER table Booking add foreign key (customerId) references customer(id);
ALTER table bookingdetail add foreign key (bookingId) references booking(id);
ALTER table bookingdetail add foreign key (roomid) references Room(id);

INSERT INTO Category (name, status) VALUES 
('Deluxe', 1),
('Standard', 1),
('Suite', 1),
('Economy', 1),
('Penthouse', 1);


INSERT INTO Room (name, status, price, salePrice, createdDate, categoryId) VALUES 
('Phòng A', 1, 150000, 120000, CURDATE(), 1),
('Phòng B', 1, 200000, 180000, CURDATE(), 1),
('Phòng C', 1, 250000, 220000, CURDATE(), 2),
('Phòng D', 1, 300000, 280000, CURDATE(), 2),
('Phòng E', 1, 350000, 320000, CURDATE(), 3),
('Phòng F', 1, 400000, 370000, CURDATE(), 3),
('Phòng G', 1, 450000, 420000, CURDATE(), 4),
('Phòng H', 1, 500000, 470000, CURDATE(), 4),
('Phòng I', 1, 550000, 520000, CURDATE(), 5),
('Phòng J', 1, 600000, 570000, CURDATE(), 5),
('Phòng K', 1, 650000, 620000, CURDATE(), 1),
('Phòng L', 1, 700000, 670000, CURDATE(), 2),
('Phòng M', 1, 750000, 720000, CURDATE(), 3),
('Phòng N', 1, 800000, 770000, CURDATE(), 4),
('Phòng O', 1, 850000, 820000, CURDATE(), 5);

INSERT INTO customer (name, email, phone, address, gender, birthday) VALUES 
('Nguyễn Văn A', 'nguyenvana@example.com', '0912345678', '123 Đường A, Thành phố B', 1, '1990-01-01'),
('Trần Thị B', 'tranthib@example.com', '0987654321', '456 Đường C, Thành phố D', 0, '1985-05-15'),
('Lê Văn C', 'levanc@example.com', '0976543210', '789 Đường E, Thành phố F', 1, '1992-12-20');

INSERT INTO booking (customerId, status, bookingdate) VALUES 
(1, 1, CURDATE()),
(2, 1, CURDATE()),
(3, 1, CURDATE());


INSERT INTO bookingdetail (bookingId, roomId, price, startDate, endDate) VALUES 
(1, 1, 120000, '2024-09-01', '2024-09-05'),
(1, 2, 180000, '2024-09-01', '2024-09-05'),
(2, 3, 220000, '2024-09-10', '2024-09-15'),
(2, 4, 280000, '2024-09-10', '2024-09-15'),
(3, 5, 320000, '2024-10-01', '2024-10-10'),
(3, 6, 370000, '2024-10-01', '2024-10-10');

-- Lấy ra danh phòng có sắp xếp giảm dần theo Price gồm các cột sau: Id, Name, Price,
-- SalePrice, Status, CategoryName, CreatedDate

select r.id as id,
    r.name AS Name,
    r.price as Price,
    r.salePrice as SalePrice,
    r.status AS Status,
    c.name CategoryName,
    r.createdDate as CreatedDate
FROM
    room r
        JOIN
    category c ON r.categoryId = c.id
ORDER BY r.price DESC;


--  Lấy ra danh sách Category gồm: Id, Name, TotalRoom, Status (Trong đó cột Status nếu = 0, Ẩn,
-- = 1 là Hiển thị ) 
SELECT 
    c.id AS Id,
    c.name AS Name,
    COUNT(r.id) AS TotalRoom,
    CASE 
        WHEN c.status = 1 THEN 'Hiển thị'
        ELSE 'Ẩn'
    END AS Status
FROM 
    Category c
LEFT JOIN Room r ON c.id = r.categoryId
GROUP BY c.id, c.name, c.status;

-- 1.3 Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender,
-- BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )

select Id,
name,
email, 
phone,
address,
createddate,
case 
when gender =0 then 'nam'
when gender =1 then 'nữ'
else 'khác'
end as gender,
birthday,
TIMESTAMPDIFF(YEAR, birthday, CURDATE()) AS Age
 from customer;
 
 -- 1.4 Truy vấn danh sách Customer gồm: Id, Name, Email, Phone, Address, CreatedDate, Gender,
-- BirthDay, Age (Age là cột suy ra từ BirthDay, Gender nếu = 0 là Nam, 1 là Nữ,2 là khác )

select Id,
name,
email, 
phone,
address,
createddate,
case 
when gender =0 then 'nam'
when gender =1 then 'nữ'
else 'khác'
end as gender,
birthday,
TIMESTAMPDIFF(YEAR, birthday, CURDATE()) AS Age
 from customer;
 
 
-- View v_getRoomInfo Lấy ra danh sách của 10 phòng có giá cao nhất
CREATE VIEW v_getRoomInfo AS
    SELECT 
        r.id, r.name, r.status, r.price, r.createddate
    FROM
        room r
    ORDER BY price DESC
    LIMIT 10;
    
  --  View v_getBookingList hiển thị danh sách phiếu đặt hàng gồm: Id, BookingDate, Status,
  -- CusName,Email, Phone,TotalAmount ( Trong đó cột Status nếu = 0 Chưa duyệt, = 1 Đã duyệt,
--   = 2 Đã thanh toán, = 3 Đã hủy ) 
   
   CREATE VIEW v_getBookingList AS
SELECT 
    b.id   BookingId,
    b.bookingdate   BookingDate,
    CASE 
        WHEN b.status = 0 THEN 'Chưa duyệt'
        WHEN b.status = 1 THEN 'Đã duyệt'
        WHEN b.status = 2 THEN 'Đã thanh toán'
        WHEN b.status = 3 THEN 'Đã hủy'
        ELSE 'Không xác định'
    END AS Status,
    c.name  Customer_Name,
    c.email  Email,
    c.phone  Phone,
    SUM(d.price)  TotalAmount
FROM 
    booking b
JOIN 
    customer c ON b.customerId = c.id
JOIN 
    bookingdetail d ON b.id = d.bookingId
GROUP BY 
    b.id, b.bookingdate, b.status, c.name, c.email, c.phone;
    
-- Thủ tục addRoomInfo thực hiện thêm mới Room, khi gọi thủ tục truyền đầy đủ các giá trị 
-- của bảng Room ( Trừ cột tự động tăng )
    
    DELIMITER //

CREATE PROCEDURE addRoomInfo(
    IN p_name VARCHAR(150),
    IN p_status TINYINT,
    IN p_price FLOAT,
    IN p_salePrice FLOAT,
    IN p_createdDate DATE,
    IN p_categoryId INT
)
BEGIN
    INSERT INTO Room (name, status, price, salePrice, createdDate, categoryId)
    VALUES (p_name, p_status, p_price, p_salePrice, p_createdDate, p_categoryId);
END //

DELIMITER ;

-- Thủ tục getBookingByCustomerId hiển thị danh sách phieus đặt phòng của khách hàng
-- theo Id khách hàng gồm: Id, BookingDate, Status, TotalAmount (Trong đó cột Status nếu = 0
-- Chưa duyệt, = 1 Đã duyệt,, = 2 Đã thanh toán, = 3 Đã hủy), Khi gọi thủ tục truyền vào id cảu
-- khách hàng
    
   DELIMITER //

CREATE PROCEDURE getBookingByCustomerId(
    IN p_customer_Id INT
)
BEGIN
    SELECT 
        b.id AS BookingId,
        b.bookingdate AS BookingDate,
        CASE
            WHEN b.status = 0 THEN 'Chưa duyệt'
            WHEN b.status = 1 THEN 'Đã duyệt'
            WHEN b.status = 2 THEN 'Đã thanh toán'
            WHEN b.status = 3 THEN 'Đã hủy'
        END AS Status,
        SUM(bd.price) AS TotalAmount
    FROM
        booking b
        JOIN bookingdetail bk ON b.id = bk.bookingId
    WHERE b.customerId = p_customer_Id
    GROUP BY b.id, b.bookingdate, b.status;
END //
DELIMITER ;

-- Thủ tục getRoomPaginate lấy ra danh sách phòng có phân trang gồm: Id, Name, Price,
-- SalePrice, Khi gọi thủ tuc truyền vào limit và page 
DELIMITER //
create procedure getRoomPaginate (
p_limit int, p_page int
)
BEGIN
    declare set_page int;
    set set_page = (p_page - 1) * p_limit;
SELECT r.id AS Id,
    r.name AS Name,
    r.price AS Price,
    r.salePrice AS SalePrice
FROM room r
LIMIT SET_PAGE , P_LIMIT;
END //

DELIMITER ;