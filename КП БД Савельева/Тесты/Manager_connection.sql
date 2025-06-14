-- ===============================
-- ТЕСТ ПРОЦЕДУР И ФУНКЦИЙ МЕНЕДЖЕРА
-- ===============================

-- 1. Оформление бронирования от имени клиента
BEGIN
  MakeBooking(75, 30); -- user_id, tour_id (замени при необходимости)
END;
/

-- 2. Подтверждение оплаты этого бронирования
DECLARE
  v_booking_id NUMBER;
BEGIN
  SELECT MAX(BookingId)
  INTO v_booking_id
  FROM Bookings
  WHERE UserId = 75 AND TourId = 30;

  ConfirmBookingPayment(v_booking_id, 850.00, 'Visa');
END;
/

-- 3. Отмена бронирования
DECLARE
  v_booking_id NUMBER;
BEGIN
  SELECT MAX(BookingId)
  INTO v_booking_id
  FROM Bookings
  WHERE UserId = 75 AND TourId = 30;

  CancelBooking(v_booking_id);
END;
/

-- 4. Получение выручки по туру (если есть GetTourRevenue)

SELECT GetTourRevenue(30) AS Revenue FROM dual;


-- 5. Просмотр информации по отзывам
SELECT * FROM View_TourReviewsExtended WHERE Tour = (SELECT ShortTitle FROM Tours WHERE TourId = 30);

-- 6. Просмотр бронирований
SELECT * FROM View_BookingDetails WHERE TourName LIKE '%30%';

-- 7. Просмотр оплат
SELECT * FROM View_PaymentSummary WHERE ClientName LIKE '%Пользователь%';

-- 8. Попытка использовать экспорт (должна вызвать ошибку — нет EXECUTE)
BEGIN
  ExportToursToXML;
END;
/
